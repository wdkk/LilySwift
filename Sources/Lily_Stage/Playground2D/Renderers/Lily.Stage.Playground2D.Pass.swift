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
            // レンダーパスの準備
            passDesc = .make {
                $0.depthAttachment
                .action( load:.clear, store:.store )
                .clearDepth( 0.0 )
                
                $0.colorAttachments[0]
                .action( load:.clear, store:.store )
                .clearColor( .lightGrey )
            }
            
            // Depth stateの作成
            depthState = device.makeDepthStencilState( descriptor:.make {
                $0
                .depthCompare( .greaterEqual )
                .depthWriteEnabled( false )
            } )
        }
        
        // 公開ファンクション
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
        
        public func setClearColor( _ color:LLColor? ) {
            guard let color = color else {
                passDesc?.colorAttachments[0].clearColor( .clear )
                passDesc?.colorAttachments[0].action( load:.load, store:.store )
                return
            }
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.store )
        }
        
        public func setClearColor( _ color:MTLClearColor ) {
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.store )
        }
    }
}
