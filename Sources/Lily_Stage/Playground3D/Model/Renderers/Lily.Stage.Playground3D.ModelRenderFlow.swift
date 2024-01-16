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

extension Lily.Stage.Playground3D.Model
{   
    open class ModelRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        weak var modelRenderTextures:ModelRenderTextures?
        weak var mediumTexture:Lily.Stage.Playground3D.MediumTexture?
        
        var modelPass:ModelPass?
        
        public private(set) var storage:ModelStorage
        
        var modelObjectRenderer:ModelObjectRenderer?
        var modelLightingRenderer:ModelLightingRenderer?

        let viewCount:Int
        
        public init(
            device:MTLDevice, 
            viewCount:Int,
            renderTextures:ModelRenderTextures,
            mediumTexture:Lily.Stage.Playground3D.MediumTexture
        ) 
        {
            self.modelRenderTextures = renderTextures
            self.mediumTexture = mediumTexture
            
            self.modelPass = .init( device:device, renderTextures:renderTextures )
            
            self.viewCount = viewCount

            // レンダラーの用意
            modelObjectRenderer = .init( device:device, viewCount:viewCount )
            modelLightingRenderer = .init( device:device, viewCount:viewCount )
            
            self.storage = .init( 
                device:device, 
                objCount:64,
                cameraCount:( Lily.Stage.Shared.Const.shadowCascadesCount + 1 ),
                modelAssets:[ "acacia1" ]
            )
            
            super.init( device:device )
            
            self.storage.statuses.update { acc, _ in
                for iid in 0 ..< self.storage.capacity {
                    let idx = iid / self.storage.cameraCount
                    let x = idx / 8
                    let z = idx % 8
                    // オブジェクトの位置
                    let world_pos = LLFloatv3( 20.0 + -10.0 * x.f, -2.0, 20.0 + -10.0 * z.f )
                    
                    let object_scale = LLFloatv3( 8.0, 8.0, 8.0 )
                    
                    let up = LLFloatv3( 0, 1, 0 )
                    let right = normalize( cross( up, LLFloatv3( 1.0, 0.0, 1.0 ) ) )
                    let fwd = cross( up, right )
                    
                    let world_matrix = float4x4(   
                        LLFloatv4( fwd * object_scale, 0 ),
                        LLFloatv4( up * object_scale, 0 ),
                        LLFloatv4( right * object_scale, 0 ),
                        LLFloatv4( world_pos, 1 )
                    )
                    
                    acc[iid].modelIndex = 0
                    acc[iid].matrix = world_matrix
                }
            }
        }
        
        public override func changeSize( scaledSize:CGSize ) {
            
        }
        
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
            
            let shadowViewport = modelRenderTextures!.shadowViewport()
            let shadowScissor = modelRenderTextures!.shadowScissor()
            
            // 共通処理
            // パスの更新
            modelPass.updatePass( 
                renderTextures:modelRenderTextures!,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount
            )
            
            // カスケードシャドウマップ
            for c_idx in 0 ..< Lily.Stage.Shared.Const.shadowCascadesCount {
                modelPass.shadowPassDesc?.depthAttachment.slice = c_idx
                
                let shadow_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:modelPass.shadowPassDesc! ) 
                
                shadow_encoder?
                .label( "Playground3D Shadow Cascade \(c_idx)" )
                .cullMode( .front )
                .frontFacing( .counterClockwise )
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
            modelPass.setGBufferDestination( texture:mediumTexture?.resultTexture )
            modelPass.setDepth( texture:depthTexture )
            
            let deferred_shading_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:modelPass.GBufferPassDesc! )
            
            deferred_shading_encoder?
            .label( "Playground3D G-Buffer Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
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
                renderTextures:modelRenderTextures
            )

            deferred_shading_encoder?.endEncoding()
        }
    }
}
