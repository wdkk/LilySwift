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

extension Lily.Stage.Playground.Model
{
    open class Pass
    { 
        var device:MTLDevice
        
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
                .clearDepth( 1.0 )
                .action( load:.clear, store:.store )
            }
            // シャドウデプスステートの作成
            shadowDepthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .less )
                .depthWriteEnabled( true )
            })
            
            // G-Bufferのレンダーパスの準備
            GBufferPassDesc = .make {
                $0.depthAttachment
                .clearDepth( 1.0 )
                .action( load:.clear, store:.store )
                
                #if !targetEnvironment(simulator)
                $0.colorAttachments[IDX_GBUFFER_0].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[IDX_GBUFFER_1].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[IDX_GBUFFER_2].action( load:.dontCare, store:.dontCare )
                $0.colorAttachments[IDX_GBUFFER_DEPTH].action( load:.clear, store:.dontCare ).clearColor( .white )
                #else
                // シミュレータはテクスチャを保存する
                $0.colorAttachments[IDX_GBUFFER_0].action( load:.dontCare, store:.store )
                $0.colorAttachments[IDX_GBUFFER_1].action( load:.dontCare, store:.store )
                $0.colorAttachments[IDX_GBUFFER_2].action( load:.dontCare, store:.store )
                $0.colorAttachments[IDX_GBUFFER_DEPTH].action( load:.clear, store:.store ).clearColor( .white )
                #endif
                // colorAttachments[IDX_OUTPUT]が毎フレームのバックバッファの受け取り口
                $0.colorAttachments[IDX_OUTPUT].action( load:.dontCare, store:.store )
            }
            
            // G-BufferのDepth stateの作成
            GBufferDepthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .less )
                .depthWriteEnabled( true )
            })
        }
        
        public func updatePass( 
            renderTextures:RenderTextures, 
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        ) 
        {            
            // テクスチャの差し替え
            GBufferPassDesc?.colorAttachments[IDX_GBUFFER_0].texture = renderTextures.GBuffer0
            GBufferPassDesc?.colorAttachments[IDX_GBUFFER_1].texture = renderTextures.GBuffer1
            GBufferPassDesc?.colorAttachments[IDX_GBUFFER_2].texture = renderTextures.GBuffer2
            GBufferPassDesc?.colorAttachments[IDX_GBUFFER_DEPTH].texture = renderTextures.GBufferDepth
            #if !targetEnvironment(macCatalyst)
            GBufferPassDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            GBufferPassDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
                        
        public func setGBufferDestination( texture:MTLTexture? ) {
            GBufferPassDesc?.colorAttachments[IDX_OUTPUT].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            GBufferPassDesc?.depthAttachment.texture = texture
        }
    }
}
