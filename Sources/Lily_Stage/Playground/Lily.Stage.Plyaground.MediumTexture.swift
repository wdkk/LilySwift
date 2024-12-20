//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import MetalKit
import simd

extension Lily.Stage.Playground
{    
    open class MediumResource
    { 
        var device:MTLDevice
        
        var resultTexture:MTLTexture?

        public init( device:MTLDevice ) {
            self.device = device
        }
        
        @discardableResult
        public func updateBuffers( size:CGSize, viewCount:Int ) -> Bool {
            if resultTexture != nil && 
               resultTexture!.width.d == size.width && 
               resultTexture!.height.d == size.height 
            { return false }
            
            // テクスチャ再生成の作業
            let tex_desc = MTLTextureDescriptor.texture2DDescriptor( 
                pixelFormat:BufferFormats.linearSRGBBuffer,
                width:size.width.i!,
                height:size.height.i!,
                mipmapped:false 
            )
            
            tex_desc.sampleCount = BufferFormats.sampleCount
            tex_desc.storageMode = .private
            tex_desc.textureType = .type2DArray
            tex_desc.arrayLength = viewCount
            tex_desc.usage = [ tex_desc.usage, .renderTarget ]
            
            // planeTextureの再生成
            resultTexture = device.makeTexture( descriptor:tex_desc )
            resultTexture?.label = "MediumResource.resultTexture"
            
            return true
        }
        
        // シャドウマップテクスチャの作成
        public func createShadowMap( size:LLSizeInt, arrayLength:Int ) -> MTLTexture? {
            let desc = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: BufferFormats.shadowDepth,
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

#endif
