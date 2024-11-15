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

extension Lily.Stage.Playground.sRGB
{
    open class RenderFlow
    : Lily.Stage.Playground.BaseRenderFlow
    {
        public typealias Playground = Lily.Stage.Playground
        
        var pass:Lily.Stage.Playground.sRGB.Pass?
        
        weak var mediumResource:Playground.MediumResource?
        
        var sRGBRenderer:Renderer?
        
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Metal.ShaderEnvironment,
            viewCount:Int,
            mediumResource:Playground.MediumResource
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            self.mediumResource = mediumResource
            
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
            
            guard let mediumResource = mediumResource else { LLLog( "mediumResourceが設定されていません" ); return }
            
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetViewIndex:viewCount        
            )
            
            pass.setDestination( texture:destinationTexture )

            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground SRGB Render" )
            .cullMode( .front )
            .viewports( viewports )
            .vertexAmplification( viewports:viewports )
            
            // sRGB変換
            sRGBRenderer?.draw(
                with:encoder,
                mediumResource:mediumResource
            )

            encoder?.endEncoding()
        }
    }
}

#endif
