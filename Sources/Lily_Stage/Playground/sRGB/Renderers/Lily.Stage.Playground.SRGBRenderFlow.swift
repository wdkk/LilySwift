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

extension Lily.Stage.Playground.sRGB
{
    open class RenderFlow
    : Lily.Stage.Playground.BaseRenderFlow
    {
        public typealias Playground = Lily.Stage.Playground
        
        var pass:Lily.Stage.Playground.sRGB.Pass?
        
        weak var mediumTexture:Playground.MediumTexture?
        
        var sRGBRenderer:Renderer?
        
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            mediumTexture:Playground.MediumTexture
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            self.mediumTexture = mediumTexture
            
            self.sRGBRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount
            )
            
            super.init( device:device )
        }
        
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
            guard let pass = self.pass else { return }
            
            guard let mediumTexture = mediumTexture else { LLLog( "mediumTextureが設定されていません" ); return }
            
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            pass.setDestination( texture:destinationTexture )

            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground SRGB Render" )
            .cullMode( .front )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // sRGB変換
            sRGBRenderer?.draw(
                with:encoder,
                mediumTexture:mediumTexture
            )

            encoder?.endEncoding()
        }
    }
}
