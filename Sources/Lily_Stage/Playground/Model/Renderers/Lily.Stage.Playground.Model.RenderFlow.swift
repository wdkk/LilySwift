//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import MetalKit

extension Lily.Stage.Playground.Model
{   
    open class RenderFlow
    : Lily.Stage.Playground.BaseRenderFlow
    {
        weak var modelRenderTextures:RenderTextures?
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        
        public var modelPass:Pass?
        
        public weak var storage:ModelStorage?
        
        var comDelta:Mesh.ComDelta?
        
        public var meshRenderer:Mesh.Renderer?
        public var lightingRenderer:Lighting.Renderer?

        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Metal.ShaderEnvironment,
            viewCount:Int,
            renderTextures:RenderTextures,
            mediumTexture:Lily.Stage.Playground.MediumTexture,
            storage:ModelStorage?
        ) 
        {
            self.modelRenderTextures = renderTextures
            self.mediumTexture = mediumTexture
            
            self.modelPass = .init( device:device, renderTextures:renderTextures )
            
            self.viewCount = viewCount

            // レンダラーの用意
            meshRenderer = .init(
                device:device, 
                environment:environment,
                viewCount:viewCount 
            )
            
            lightingRenderer = .init(
                device:device,
                environment:environment, 
                viewCount:viewCount 
            )
            
            self.comDelta = .init(
                device: device, 
                environment: environment
            )
            
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
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>
        )
        {
            guard let modelPass = modelPass else { return }

            guard let modelRenderTextures = self.modelRenderTextures else { LLLog( "modelRenderTextureが設定されていません" ); return }
            
            guard let mediumTexture = self.mediumTexture else { LLLog( "mediumTextureが設定されていません" ); return }
            
            guard let storage = self.storage else { return }
            
            let shadowViewport = modelRenderTextures.shadowViewport()
            let shadowScissor = modelRenderTextures.shadowScissor()
                        
            // 共通処理
            // パスの更新
            modelPass.updatePass( 
                renderTextures:modelRenderTextures,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetViewIndex:viewCount
            )
            
            // カスケードシャドウマップ
            for c_idx in 0 ..< Lily.Stage.Playground.shadowCascadesCount {
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
                meshRenderer?.drawShadows(
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
            .vertexAmplification( viewports:viewports )
            
            // オブジェクトの描画
            meshRenderer?.draw( 
                with:deferred_shading_encoder, 
                globalUniforms:uniforms,
                storage:storage
            )

            // ライティングの描画
            lightingRenderer?.draw(
                with:deferred_shading_encoder, 
                globalUniforms:uniforms,
                storage:storage,
                renderTextures:modelRenderTextures
            )

            deferred_shading_encoder?.endEncoding()
            
            comDelta?.updateMatrices(
                with:commandBuffer, 
                globalUniforms: uniforms,
                storage: storage
            )
        }
    }
}

#endif
