//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import MetalKit

extension Lily.Stage.Playground.Model
{   
    open class ModelRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        weak var modelRenderTextures:ModelRenderTextures?
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        
        public var modelPass:ModelPass?
        
        public weak var storage:ModelStorage?
        
        public var modelObjectRenderer:ModelObjectRenderer?
        public var modelLightingRenderer:ModelLightingRenderer?

        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            renderTextures:ModelRenderTextures,
            mediumTexture:Lily.Stage.Playground.MediumTexture,
            storage:ModelStorage?
        ) 
        {
            self.modelRenderTextures = renderTextures
            self.mediumTexture = mediumTexture
            
            self.modelPass = .init( device:device, renderTextures:renderTextures )
            
            self.viewCount = viewCount

            // レンダラーの用意
            modelObjectRenderer = .init( device:device, environment:environment, viewCount:viewCount )
            modelLightingRenderer = .init( device:device, environment:environment, viewCount:viewCount )
            
            self.storage = storage
            
            super.init( device:device )
        }
        
        public override func changeSize( scaledSize:CGSize ) {}
        
        public override func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>
        )
        {
            guard let modelPass = modelPass else { return }

            guard let modelRenderTextures = self.modelRenderTextures else { LLLog( "modelRenderTextureが設定されていません" ); return }
            
            guard let mediumTexture = self.mediumTexture else { LLLog( "mediumTextureが設定されていません" ); return }
            
            guard let storage = self.storage else { return }
            
            let shadowViewport = modelRenderTextures.shadowViewport()
            let shadowScissor = modelRenderTextures.shadowScissor()
            
            storage.statuses.update { acc, _ in
                for i in 0 ..< acc.count-1 {
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    acc[i].position += acc[i].deltaPosition
                    acc[i].scale += acc[i].deltaScale
                    acc[i].angle += acc[i].deltaAngle
                    acc[i].color += acc[i].deltaColor
                    acc[i].life += acc[i].deltaLife
                }
            }
            
            // 共通処理
            // パスの更新
            modelPass.updatePass( 
                renderTextures:modelRenderTextures,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount
            )
            
            // カスケードシャドウマップ
            for c_idx in 0 ..< Lily.Stage.Shared.Const.shadowCascadesCount {
                modelPass.shadowPassDesc?.depthAttachment.slice = c_idx
                
                let shadow_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:modelPass.shadowPassDesc! ) 
                
                shadow_encoder?
                .label( "Playground Shadow Cascade \(c_idx)" )
                .cullMode( .front )
                .depthClipMode( .clamp )
                .depthStencilState( modelPass.shadowDepthState )
                .viewport( shadowViewport )
                .scissor( shadowScissor )
                
                // viewCount分の配列で渡す
                var shadow_cam_vp_matrices:[LLMatrix4x4] = []
                for amp_idx in 0 ..< viewCount { 
                    let shadow_cam_vp_matrix = uniforms.current![ amp_idx ].shadowCameraUniforms[ c_idx ].viewProjectionMatrix
                    shadow_cam_vp_matrices.append( shadow_cam_vp_matrix )
                }
                
                // 陰影の描画
                modelObjectRenderer?.drawShadows(
                    with:shadow_encoder, 
                    globalUniforms:uniforms,
                    shadowCamVPMatrices:shadow_cam_vp_matrices,
                    storage:storage,
                    cascadeIndex:c_idx 
                )
                
                shadow_encoder?.endEncoding()
            }
            
            // レンダーパスの書き込み先を指定
            modelPass.setGBufferDestination( texture:mediumTexture.resultTexture )
            modelPass.setDepth( texture:depthTexture )
            
            let deferred_shading_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:modelPass.GBufferPassDesc! )
            
            deferred_shading_encoder?
            .label( "Playground G-Buffer Render" )
            .cullMode( .front )
            .depthStencilState( modelPass.GBufferDepthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // オブジェクトの描画
            modelObjectRenderer?.draw( 
                with:deferred_shading_encoder, 
                globalUniforms:uniforms,
                storage:storage
            )

            // ライティングの描画
            modelLightingRenderer?.draw(
                with:deferred_shading_encoder, 
                globalUniforms:uniforms,
                storage:storage,
                renderTextures:modelRenderTextures
            )

            deferred_shading_encoder?.endEncoding()
        }
    }
}
