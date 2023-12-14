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
                
                #if !targetEnvironment(simulator)
                $0.colorAttachments[0].action( load:.clear, store:.dontCare ).clearColor( .lightGrey )
                #else
                // シミュレータはテクスチャを保存する
                $0.colorAttachments[0].action( load:.clear, store:.store ).clearColor( .lightGrey )
                #endif
                // colorAttachments[1]が毎フレームのバックバッファの受け取り口
                $0.colorAttachments[1].action( load:.dontCare, store:.store )
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
            renderTextures:RenderTextures,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            passDesc?.colorAttachments[0].texture = renderTextures.particleTexture
            #if !targetEnvironment(macCatalyst)
            passDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            passDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
        
        public func setDestination( texture:MTLTexture? ) {
            passDesc?.colorAttachments[1].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            passDesc?.depthAttachment.texture = texture
        }
        
        public func setClearColor( _ color:LLColor? ) {
            guard let color = color else {
                passDesc?.colorAttachments[0].clearColor( .clear )
                passDesc?.colorAttachments[0].action( load:.load, store:.dontCare )
                return
            }
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.dontCare )
        }
        
        public func setClearColor( _ color:MTLClearColor ) {
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.dontCare )
        }
    }
}
