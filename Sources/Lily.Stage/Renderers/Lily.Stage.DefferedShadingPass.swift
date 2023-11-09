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
    open class DefferedShadingPass
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        var shadowPassDesc:MTLRenderPassDescriptor?
        var shadowDepthState: MTLDepthStencilState?
        
        var GBufferPassDesc:MTLRenderPassDescriptor?
        var GBufferDepthState:MTLDepthStencilState?
        
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
            desc.depthAttachment.clearDepth( 0.0 )
            desc.depthAttachment.action( load:.clear, store:.store )
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
            // G-Buffer0,1,2は保存しない(M1以降はiOS/macともにオンチップで保存不要になった
            desc.colorAttachments[0].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[1].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[2].action( load:.dontCare, store:.dontCare )
            desc.colorAttachments[3].clearColor( .white )
            desc.colorAttachments[3].action( load:.clear, store:.dontCare )
            // colorAttachments[4]が毎フレームのバックバッファの受け取り口
            desc.colorAttachments[4].action( load:.dontCare, store:.store )
            #else
            // シミュレータはテクスチャを保存する
            desc.colorAttachments[0].action( load:.dontCare, store:.store )
            desc.colorAttachments[1].action( load:.dontCare, store:.store )
            desc.colorAttachments[2].action( load:.dontCare, store:.store )
            desc.colorAttachments[3].clearColor( .white )
            desc.colorAttachments[3].action( load:.clear, store:.store )     
            // colorAttachments[4]が毎フレームのバックバッファの受け取り口
            desc.colorAttachments[4].action( load:.dontCare, store:.store )
            #endif
            
            return desc
        }
        
        func makeGBufferDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .greater
            desc.isDepthWriteEnabled = true
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        func setGBufferDestination( texture:MTLTexture? ) {
            GBufferPassDesc?.colorAttachments[4].texture = texture
        }
        
        func setDepth( texture:MTLTexture? ) {
            GBufferPassDesc?.depthAttachment.texture = texture
        }
    }
}
