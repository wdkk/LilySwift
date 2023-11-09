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
import simd

extension Lily.Stage
{               
    open class RenderFlow
    {
        var device:MTLDevice
        var uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>
        
        var renderTextures:RenderTextures
        var deferredShadingPass:DeferredShading?
        var particlePass:ParticlePass?
        
        var objectRenderer:ObjectRenderer?
        var particleRenderer:ParticleRenderer?
        var lightingRenderer:LightingRenderer?
        
        public init( device:MTLDevice, uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray> ) {
            self.device = device
            self.uniforms = uniforms

            self.renderTextures = .init( device:device )
            self.deferredShadingPass = .init( device:device, renderTextures:renderTextures )
            self.particlePass = .init( device:device, renderTextures:renderTextures )

            // レンダラーの用意
            objectRenderer = .init( device:device, viewCount:1 )
            particleRenderer = .init( device:device, viewCount:1 )
            lightingRenderer = .init( device:device, viewCount:1 )
        }
        
        public func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:MTLRasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            shadowViewport:MTLViewport,
            shadowScissor:MTLScissorRect,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?
        )
        {
            guard let deferred_shading_pass = deferredShadingPass, let particle_pass = particlePass else { return }
            
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
