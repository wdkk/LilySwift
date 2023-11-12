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
            shadowPassDesc = setupShadowRenderPassDescriptor( renderTextures.shadowMap )
            // シャドウデプスステートの作成
            shadowDepthState = makeShadowDepthState() 
            
            // G-Bufferのレンダーパスの準備
            GBufferPassDesc = setupGBufferRenderPassDescriptor()
            // G-BufferのDepth stateの作成
            GBufferDepthState = makeGBufferDepthState()
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
                
        // シャドウマップディスクリプタの作成
        func setupShadowRenderPassDescriptor( _ shadowMap:MTLTexture? ) -> MTLRenderPassDescriptor {
            let desc = MTLRenderPassDescriptor()
            desc.depthAttachment.texture = shadowMap
            desc.depthAttachment
            .clearDepth( 0.0 )
            .action( load:.clear, store:.store )
            return desc
        }
        
        func makeShadowDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .greater
            desc.isDepthWriteEnabled = true
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        // G-Bufferのディスクリプタの作成
        func setupGBufferRenderPassDescriptor() -> MTLRenderPassDescriptor {
            let desc = MTLRenderPassDescriptor()
            
            desc.depthAttachment
            .clearDepth( 0.0 )
            .action( load:.clear, store:.store )
            
            #if !targetEnvironment(simulator)
            desc.colorAttachments[0].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[1].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[2].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[3].clearColor( .white )
            desc.colorAttachments[3].action( load:.clear, store:.dontCare )
            #else
            // シミュレータはテクスチャを保存する
            desc.colorAttachments[0].action( load:.dontCare, store:.store )
            desc.colorAttachments[1].action( load:.dontCare, store:.store )
            desc.colorAttachments[2].action( load:.dontCare, store:.store )
            desc.colorAttachments[3].clearColor( .white )
            desc.colorAttachments[3].action( load:.clear, store:.store )
            #endif
            // colorAttachments[4]が毎フレームのバックバッファの受け取り口
            desc.colorAttachments[4].action( load:.dontCare, store:.store )
            
            return desc
        }
        
        func makeGBufferDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .greater
            desc.isDepthWriteEnabled = true
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        public func setGBufferDestination( texture:MTLTexture? ) {
            GBufferPassDesc?.colorAttachments[4].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            GBufferPassDesc?.depthAttachment.texture = texture
        }
    }
}
