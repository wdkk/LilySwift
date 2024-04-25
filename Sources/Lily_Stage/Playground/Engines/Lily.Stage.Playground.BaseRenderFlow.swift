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

extension Lily.Stage.Playground
{   
    open class BaseRenderFlow
    {
        var device:MTLDevice
        
        public init( device:MTLDevice ) {
            self.device = device
        }
        
        // TODO: おいおいプロトコルにしたい
        open func changeSize( scaledSize:CGSize ) { }
        
        open func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>
        )
        {
            LLLog( "overrideしてください" )
        }
    }
}

#endif
