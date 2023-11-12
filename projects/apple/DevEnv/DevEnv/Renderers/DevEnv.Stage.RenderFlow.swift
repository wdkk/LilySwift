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
import LilySwift

extension DevEnv.Stage
{   
    open class RenderFlow
    : BaseRenderFlow
    {
        var renderTextures:RenderTextures
        var deferredShadingPass:DeferredShadingPass?
        var particlePass:ParticlePass?
        
        var objectRenderer:ObjectRenderer?
        var particleRenderer:ParticleRenderer?
        var lightingRenderer:LightingRenderer?
        
        public override init( device:MTLDevice ) {
            self.renderTextures = .init( device:device )
            self.deferredShadingPass = .init( device:device, renderTextures:renderTextures )
            self.particlePass = .init( device:device, renderTextures:renderTextures )

            // レンダラーの用意
            objectRenderer = .init( device:device, viewCount:1 )
            particleRenderer = .init( device:device, viewCount:1 )
            lightingRenderer = .init( device:device, viewCount:1 )
            
            super.init( device:device )
        }
        
        public override func updateBuffers(size: CGSize) {
            renderTextures.updateBuffers( size:size )
        }
        
        public override func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:MTLRasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>
        )
        {
            guard let deferred_shading_pass = deferredShadingPass, let particle_pass = particlePass else { return }
            
            let shadowViewport = renderTextures.shadowViewport()
            let shadowScissor = renderTextures.shadowScissor()
            
            // 共通処理
            // パスの更新
            deferred_shading_pass.updatePass( 
                renderTextures:renderTextures,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount
            )
            
            particle_pass.updatePass( 
                renderTextures:renderTextures,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // オブジェクトの生成
            objectRenderer?.generateObject( with:commandBuffer )
            
            // カスケードシャドウマップ
            for c_idx in 0 ..< Shared.Const.shadowCascadesCount {
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
                objectRenderer?.drawShadows(
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
            objectRenderer?.draw( 
                with:deferred_shading_encoder, 
                globalUniforms:uniforms
            )

            // ライティングの描画
            lightingRenderer?.draw(
                with:deferred_shading_encoder, 
                globalUniforms:uniforms, 
                renderTextures:renderTextures
            )

            deferred_shading_encoder?.endEncoding()
            
            // フォワードレンダリング : パーティクルの描画の設定
            
            particle_pass.setDestination( texture:destinationTexture )
            particle_pass.setDepth( texture:depthTexture )
            
            let particle_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:particle_pass.particlePassDesc! )
            
            particle_encoder?
            .label( "Particle Render" )
            .cullMode( .none )
            .depthStencilState( particle_pass.particleDepthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // 半透明パーティクル描画
            particleRenderer?.draw(
                with:particle_encoder,
                globalUniforms:uniforms,
                renderTextures:renderTextures
            )
            
            particle_encoder?.endEncoding()
        }
    }
}
