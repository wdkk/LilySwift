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

extension Lily.Stage
{             
    open class BaseRenderFlow
    {
        var device:MTLDevice
        
        public init( device:MTLDevice ) {
            self.device = device
        }
        
        // TODO: おいおいプロトコルにしたい
        open func updateBuffers( size:CGSize ) {
            LLLog( "overrideしてください" )
        }
        
        open func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:MTLRasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>
        )
        {
            LLLog( "overrideしてください" )
        }
    }
}
