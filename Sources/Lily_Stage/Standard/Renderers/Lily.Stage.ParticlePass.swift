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
    open class ParticlePass
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        public var particlePassDesc:MTLRenderPassDescriptor?
        public var particleDepthState: MTLDepthStencilState?
        
        public init( device:MTLDevice, renderTextures:RenderTextures ) {
            self.device = device
            // パーティクルのレンダーパスの準備
            particlePassDesc = .make {
                $0.depthAttachment
                .action( load:.load, store:.store )
                
                $0.colorAttachments[0]
                .action( load:.load, store:.store )
            }
            // パーティクルのDepth stateの作成
            particleDepthState = device.makeDepthStencilState(descriptor:.make {
                $0
                .depthCompare( .greater )
                .depthWriteEnabled( false )
            })
        }
        
        public func updatePass(
            renderTextures:RenderTextures,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            #if !targetEnvironment(macCatalyst)
            particlePassDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            particlePassDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
        
        public func setDestination( texture:MTLTexture? ) {
            particlePassDesc?.colorAttachments[0].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            particlePassDesc?.depthAttachment.texture = texture
        }
    }
}
