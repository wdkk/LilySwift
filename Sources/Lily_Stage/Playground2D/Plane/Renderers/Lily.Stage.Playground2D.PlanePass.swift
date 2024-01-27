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

extension Lily.Stage.Playground2D.Plane
{
    open class PlanePass
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
                .clearDepth( 1.0 )
                // テクスチャに落とすことにしたのでストアする
                $0.colorAttachments[0].action( load:.clear, store:.store ).clearColor( .darkGrey )
                // colorAttachments[1]が毎フレームのバックバッファの受け取り口
                $0.colorAttachments[1].action( load:.clear, store:.store ).clearColor( .darkGrey )
            }
            
            // Depth stateの作成
            depthState = device.makeDepthStencilState( descriptor:.make {
                $0
                .depthCompare( .lessEqual )
                .depthWriteEnabled( true )
            } )
        }
        
        // 公開ファンクション
        public func updatePass(
            mediumTextures:Lily.Stage.Playground2D.MediumTextures,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            passDesc?.colorAttachments[0].texture = mediumTextures.resultTexture
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
            if let color = color {
                passDesc?.colorAttachments[0].clearColor( color )
                passDesc?.colorAttachments[0].action( load:.clear, store:.store )
            }
            else {
                passDesc?.colorAttachments[0].clearColor( .clear )
                passDesc?.colorAttachments[0].action( load:.load, store:.store )
            }
        }
        
        public func setClearColor( _ color:MTLClearColor ) {
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.store )
        }
    }
}
