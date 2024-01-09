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

extension Lily.Stage.Playground3D
{   
    open class ModelRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        weak var renderTextures:Lily.Stage.RenderTextures?
        
        var deferredShadingPass:Lily.Stage.DeferredShadingPass?
        
        var modelObjectRenderer:ModelObjectRenderer?
        var modelLightingRenderer:ModelLightingRenderer?

        let viewCount:Int
        
        public init( device:MTLDevice, viewCount:Int, renderTextures:Lily.Stage.RenderTextures ) {
            self.renderTextures = renderTextures
            self.deferredShadingPass = .init( device:device, renderTextures:renderTextures )
            
            self.viewCount = viewCount

            // レンダラーの用意
            modelObjectRenderer = .init( device:device, viewCount:viewCount )
            modelLightingRenderer = .init( device:device, viewCount:viewCount )
            
            super.init( device:device )
        }
        
        public override func changeSize( scaledSize:CGSize ) {
            renderTextures!.updateBuffers( size:scaledSize, viewCount:viewCount )
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
            guard let deferred_shading_pass = deferredShadingPass else { return }
            
            let shadowViewport = renderTextures!.shadowViewport()
            let shadowScissor = renderTextures!.shadowScissor()
            
            // 共通処理
            // パスの更新
            deferred_shading_pass.updatePass( 
                renderTextures:renderTextures!,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount
            )
            
            // オブジェクトの生成
            modelObjectRenderer?.generateObject( with:commandBuffer )
            
            // カスケードシャドウマップ
            for c_idx in 0 ..< Lily.Stage.Shared.Const.shadowCascadesCount {
                deferred_shading_pass.shadowPassDesc?.depthAttachment.slice = c_idx
                
                let shadow_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:deferred_shading_pass.shadowPassDesc! ) 
                
                shadow_encoder?
                .label( "Shadow Cascade \(c_idx)" )
                .cullMode( .front )
                .frontFacing( .counterClockwise )
                .depthClipMode( .clamp )
                .depthStencilState( deferred_shading_pass.shadowDepthState )
                .viewport( shadowViewport )
                .scissor( shadowScissor )
                
                var vp_matrix = uniforms.current!.uniforms.0.shadowCameraUniforms[ c_idx ].viewProjectionMatrix
                
                shadow_encoder?.setVertexBytes( &vp_matrix, length:MemoryLayout<float4x4>.stride, index:3 )
                
                // 陰影の描画
                modelObjectRenderer?.drawShadows(
                    with:shadow_encoder, 
                    globalUniforms:uniforms, 
                    cascadeIndex:c_idx 
                )
                
                shadow_encoder?.endEncoding()
            }
            
            // レンダーパスのcolor[0]をGBufferPassの書き込み先として指定する
            deferred_shading_pass.setGBufferDestination( texture:destinationTexture )
            deferred_shading_pass.setDepth( texture:depthTexture )
            
            let deferred_shading_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:deferred_shading_pass.GBufferPassDesc! )
            
            deferred_shading_encoder?
            .label( "G-Buffer Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .depthStencilState( deferred_shading_pass.GBufferDepthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // オブジェクトの描画
            modelObjectRenderer?.draw( 
                with:deferred_shading_encoder, 
                globalUniforms:uniforms
            )

            // ライティングの描画
            modelLightingRenderer?.draw(
                with:deferred_shading_encoder, 
                globalUniforms:uniforms, 
                renderTextures:renderTextures!
            )

            deferred_shading_encoder?.endEncoding()
        }
    }
}
