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

extension Lily.Stage.Playground.Billboard
{
    open class Pass
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        public var passDesc:MTLRenderPassDescriptor?
        public var depthState: MTLDepthStencilState?
        
        public init( device:MTLDevice ) {
            self.device = device
            // パーティクルのレンダーパスの準備
            passDesc = .make {
                $0.depthAttachment
                .action( load:.load, store:.store )
                
                $0.colorAttachments[0].action( load:.load, store:.store )
            }
            // パーティクルのDepth stateの作成
            depthState = device.makeDepthStencilState(descriptor:.make {
                $0
                .depthCompare( .less )
                .depthWriteEnabled( false )
            })
        }
        
        public func updatePass(
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            #if !targetEnvironment(macCatalyst)
            passDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            passDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
        
        public func setDestination( texture:MTLTexture? ) {
            passDesc?.colorAttachments[0].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            passDesc?.depthAttachment.texture = texture
        }
    }
}

#endif
