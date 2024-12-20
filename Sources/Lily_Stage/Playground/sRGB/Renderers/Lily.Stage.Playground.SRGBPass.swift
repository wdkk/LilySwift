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
import simd

extension Lily.Stage.Playground.sRGB
{
    open class Pass
    { 
        var device:MTLDevice
 
        public var passDesc:MTLRenderPassDescriptor?

        public init( device:MTLDevice ) {
            self.device = device

            passDesc = .make {                
                $0.colorAttachments[0].action( load:.load, store:.store )
            }
        }
        
        public func updatePass(
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetViewIndex:Int
        )
        {
            #if !targetEnvironment(macCatalyst)
            passDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            passDesc?.renderTargetArrayLength = renderTargetViewIndex
            #endif
        }

        public func setDestination( texture:MTLTexture? ) {
            passDesc?.colorAttachments[0].texture = texture
        }
    }
}

#endif
