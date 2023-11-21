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
            particlePassDesc = setupRenderPassDescriptor()
            // パーティクルのDepth stateの作成
            particleDepthState = makeDepthState()
        }
        
        public func updatePass(
            renderTextures:RenderTextures,
            rasterizationRateMap:MTLRasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            particlePassDesc?.rasterizationRateMap = rasterizationRateMap
            #if os(visionOS)
            particlePassDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
                  
        // パーティクルのディスクリプタの作成
        func setupRenderPassDescriptor() -> MTLRenderPassDescriptor {
            let desc = MTLRenderPassDescriptor()
            
            desc.depthAttachment
            .action( load:.load, store:.store )
            
            desc.colorAttachments[0].action( load:.load, store:.store )

            return desc
        }
        
        func makeDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .greater
            desc.isDepthWriteEnabled = false
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        public func setDestination( texture:MTLTexture? ) {
            particlePassDesc?.colorAttachments[0].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            particlePassDesc?.depthAttachment.texture = texture
        }
    }
}
