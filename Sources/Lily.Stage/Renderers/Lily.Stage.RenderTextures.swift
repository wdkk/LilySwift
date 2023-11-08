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
    public enum BufferFormats
    {
        public static let GBuffer0:MTLPixelFormat = .bgra8Unorm_srgb
        public static let GBuffer1:MTLPixelFormat = .rgba8Unorm
        public static let GBuffer2:MTLPixelFormat = .rgba8Unorm
        public static let GBufferDepth:MTLPixelFormat = .r32Float
        public static let backBuffer:MTLPixelFormat = .bgra8Unorm_srgb
        public static let depth:MTLPixelFormat = .depth32Float_stencil8
        public static let shadowDepth:MTLPixelFormat = .depth32Float_stencil8
        public static let sampleCount:Int = 1
    }
    
    open class RenderTextures
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        // G-Buffer
        var GBuffer0: MTLTexture? // albedo( r, g, b ) 
        var GBuffer1: MTLTexture? // normal( x, y, z )
        var GBuffer2: MTLTexture? // specPower, specIntensity, shadow, ambient occulusion
        var GBufferDepth: MTLTexture?
        // シャドウテクスチャ
        var shadowMap: MTLTexture?
        // デプステクスチャ
        var depth: MTLTexture?
        
        public init( device:MTLDevice ) {
            self.device = device
            // レンダパスディスクリプタを同じテクスチャポインタで揃えるためシャドウ・マップを事前に作成
            shadowMap = createShadowMap( size:LLSizeIntMake( 1024, 1024 ), arrayLength:Shared.Const.shadowCascadesCount )
        }
        
        @discardableResult
        public func updateBuffers( size:CGSize ) -> Bool {
            if GBuffer0 != nil && GBuffer0!.width.d == size.width && GBuffer0!.height.d == size.height { return false }
            
            // テクスチャ再生成作業
            let texDesc = MTLTextureDescriptor.texture2DDescriptor( 
                pixelFormat:BufferFormats.GBuffer0,
                width:size.width.i!,
                height:size.height.i!,
                mipmapped:false 
            )
            
            texDesc.sampleCount = BufferFormats.sampleCount
            #if !targetEnvironment(simulator)
            texDesc.storageMode = .memoryless
            #else
            texDesc.storageMode = .private
            #endif
            texDesc.usage = [ texDesc.usage, MTLTextureUsage.renderTarget ]
            
            // GBuffer0の再生成
            GBuffer0 = device.makeTexture( descriptor:texDesc )
            
            // GBuffer1の再生成
            texDesc.pixelFormat = BufferFormats.GBuffer1
            GBuffer1 = device.makeTexture( descriptor:texDesc )
            
            // GBuffer2の再生成
            texDesc.pixelFormat = BufferFormats.GBuffer2
            GBuffer2 = device.makeTexture( descriptor:texDesc )
            
            // GDepthの再生成
            texDesc.storageMode = .private
            texDesc.pixelFormat = BufferFormats.GBufferDepth
            GBufferDepth = device.makeTexture( descriptor:texDesc )
            
            // iOSでのストレージモードの違いに備えて, デプステクスチャはプライベートモードに設定して作成する
            texDesc.storageMode = .private
            texDesc.pixelFormat = BufferFormats.depth
            depth = device.makeTexture( descriptor:texDesc )
            
            return true
        }
        
        // シャドウマップテクスチャの作成
        func createShadowMap( size:LLSizeInt, arrayLength:Int ) -> MTLTexture? {
            let desc = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: Lily.Stage.BufferFormats.shadowDepth,
                width: size.width, 
                height: size.height,
                mipmapped: false 
            )
            desc.textureType = .type2DArray
            desc.arrayLength = arrayLength
            desc.usage       = [desc.usage, .renderTarget]
            desc.storageMode = .private
            
            let shadowTexture = device.makeTexture( descriptor:desc )
            shadowTexture?.label = "ShadowMap"
            
            return shadowTexture
        }
    }
}
