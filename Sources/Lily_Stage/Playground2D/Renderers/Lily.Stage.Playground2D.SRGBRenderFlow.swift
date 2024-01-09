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
    open class SRGBRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground2D.SRGBPass?
        
        weak var mediumTextures:MediumTextures?
        weak var renderTextures:Lily.Stage.RenderTextures?
        
        var sRGBRenderer:SRGBRenderer?
        
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            viewCount:Int,
            mediumTextures:MediumTextures,
            environment:Lily.Stage.ShaderEnvironment
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount

            self.mediumTextures = mediumTextures
            
            self.sRGBRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount
            )
            
            super.init( device:device )
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
            guard let pass = self.pass else { return }
            
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            pass.setDestination( texture:destinationTexture )

            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 2D SRGB Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // sRGB変換
            sRGBRenderer?.draw(
                with:encoder,
                mediumTextures:mediumTextures!
            )

            encoder?.endEncoding()
        }
    }
}
