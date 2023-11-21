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

extension Lily.Stage.Playground2D
{
    open class RenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var renderTextures:Lily.Stage.RenderTextures
        var particlePass:Lily.Stage.ParticlePass?
        
        var renderer:Renderer?
        
        let viewCount:Int
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.renderTextures = .init( device:device )
            self.particlePass = .init( device:device, renderTextures:renderTextures )
            
            self.viewCount = viewCount

            // レンダラーの用意
            renderer = .init( device:device, viewCount:viewCount )
            
            super.init( device:device )
        }
        
        public override func updateBuffers( size:CGSize ) {
            renderTextures.updateBuffers( size:size, viewCount:viewCount )
        }
        
        public override func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:MTLRasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>
        )
        {
            guard let particle_pass = particlePass else { return }
            
            let shadowViewport = renderTextures.shadowViewport()
            let shadowScissor = renderTextures.shadowScissor()
            
            // 共通処理
            particle_pass.updatePass( 
                renderTextures:renderTextures,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            particle_pass.setDestination( texture:destinationTexture )
            particle_pass.setDepth( texture:depthTexture )
            
            let particle_encoder = commandBuffer.makeRenderCommandEncoder( descriptor:particle_pass.particlePassDesc! )
            
            particle_encoder?
            .label( "Playground 2D Render" )
            .cullMode( .none )
            .depthStencilState( particle_pass.particleDepthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // Playground2Dレンダー描画
            renderer?.draw(
                with:particle_encoder,
                globalUniforms:uniforms,
                renderTextures:renderTextures
            )
            
            particle_encoder?.endEncoding()
        }
    }
}
