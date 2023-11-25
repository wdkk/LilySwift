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
    open class DeferredShadingPass
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        public var shadowPassDesc:MTLRenderPassDescriptor?
        public var shadowDepthState: MTLDepthStencilState?
        
        public var GBufferPassDesc:MTLRenderPassDescriptor?
        public var GBufferDepthState:MTLDepthStencilState?
        
        public init( device:MTLDevice, renderTextures:RenderTextures ) {
            self.device = device
            
            // シャドウレンダーパスの準備
            shadowPassDesc = .make {
                $0.depthAttachment.texture = renderTextures.shadowMap
                $0.depthAttachment
                .clearDepth( 0.0 )
                .action( load:.clear, store:.store )
            }
            // シャドウデプスステートの作成
            shadowDepthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .greater )
                .depthWriteEnabled( true )
            })
            
            // G-Bufferのレンダーパスの準備
            GBufferPassDesc = .make {
                $0.depthAttachment
                .clearDepth( 0.0 )
                .action( load:.clear, store:.store )
                
                #if !targetEnvironment(simulator)
                $0.colorAttachments[0].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[1].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[2].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[3].clearColor( .white )
                $0.colorAttachments[3].action( load:.clear, store:.dontCare )
                #else
                // シミュレータはテクスチャを保存する
                $0.colorAttachments[0].action( load:.dontCare, store:.store )
                $0.colorAttachments[1].action( load:.dontCare, store:.store )
                $0.colorAttachments[2].action( load:.dontCare, store:.store )
                $0.colorAttachments[3].clearColor( .white )
                $0.colorAttachments[3].action( load:.clear, store:.store )
                #endif
                // colorAttachments[4]が毎フレームのバックバッファの受け取り口
                $0.colorAttachments[4].action( load:.dontCare, store:.store )
            }
            
            // G-BufferのDepth stateの作成
            GBufferDepthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .greater )
                .depthWriteEnabled( true )
            })
        }
        
        public func updatePass( 
            renderTextures:RenderTextures, 
            rasterizationRateMap:MTLRasterizationRateMap?,
            renderTargetCount:Int
        ) 
        {            
            // テクスチャの差し替え
            GBufferPassDesc?.colorAttachments[0].texture = renderTextures.GBuffer0
            GBufferPassDesc?.colorAttachments[1].texture = renderTextures.GBuffer1
            GBufferPassDesc?.colorAttachments[2].texture = renderTextures.GBuffer2
            GBufferPassDesc?.colorAttachments[3].texture = renderTextures.GBufferDepth
            GBufferPassDesc?.rasterizationRateMap = rasterizationRateMap
            #if os(visionOS)
            GBufferPassDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
                        
        public func setGBufferDestination( texture:MTLTexture? ) {
            GBufferPassDesc?.colorAttachments[4].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            GBufferPassDesc?.depthAttachment.texture = texture
        }
    }
}
