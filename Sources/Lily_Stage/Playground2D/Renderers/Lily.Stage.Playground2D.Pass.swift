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

extension Lily.Stage.Playground2D
{
    open class Pass
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        public var passDesc:MTLRenderPassDescriptor?
        public var depthState:MTLDepthStencilState?
        
        public init( device:MTLDevice ) {
            self.device = device
            // パーティクルのレンダーパスの準備
            passDesc = setupRenderPassDescriptor()
            // パーティクルのDepth stateの作成
            depthState = makeDepthState()
        }
        
        public func updatePass(
            rasterizationRateMap:MTLRasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            passDesc?.rasterizationRateMap = rasterizationRateMap
            #if os(visionOS)
            passDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
                  
        // パーティクルのディスクリプタの作成
        func setupRenderPassDescriptor() -> MTLRenderPassDescriptor {
            let desc = MTLRenderPassDescriptor()
            
            desc.depthAttachment.action( load:.clear, store:.store )
            desc.depthAttachment.clearDepth = 0.0
            
            desc.colorAttachments[0].action( load:.clear, store:.store )
            desc.colorAttachments[0].clearColor = LLColor.lightGrey.metalColor
            
            return desc
        }
        
        func makeDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .greaterEqual
            desc.isDepthWriteEnabled = false
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        // 公開ファンクション
        
        public func setDestination( texture:MTLTexture? ) {
            passDesc?.colorAttachments[0].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            passDesc?.depthAttachment.texture = texture
        }
        
        public func setClearColor( _ color:LLColor? ) {
            guard let color = color else {
                passDesc?.colorAttachments[0].clearColor = LLColor.clear.metalColor
                passDesc?.colorAttachments[0].action( load:.load, store:.store )
                return
            }
            passDesc?.colorAttachments[0].clearColor = color.metalColor
            passDesc?.colorAttachments[0].action( load:.clear, store:.store )
        }
    }
}
