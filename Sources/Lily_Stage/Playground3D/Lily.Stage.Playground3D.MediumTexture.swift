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

extension Lily.Stage.Playground3D
{   
    open class MediumTexture
    { 
        var device:MTLDevice
        
        var resultTexture: MTLTexture?
        
        public init( device:MTLDevice ) {
            self.device = device
        }
        
        @discardableResult
        public func updateBuffers( size:CGSize, viewCount:Int ) -> Bool {
            if resultTexture != nil && resultTexture!.width.d == size.width && resultTexture!.height.d == size.height { return false }
            
            // テクスチャ再生成の作業
            let tex_desc = MTLTextureDescriptor.texture2DDescriptor( 
                pixelFormat: Lily.Stage.BufferFormats.linearSRGBBuffer,
                width:size.width.i!,
                height:size.height.i!,
                mipmapped:false 
            )
            
            tex_desc.sampleCount = Lily.Stage.BufferFormats.sampleCount
            tex_desc.storageMode = .private
            if viewCount > 1 {
                tex_desc.textureType = .type2DArray
                tex_desc.arrayLength = viewCount
            }
            tex_desc.usage = [ tex_desc.usage, .renderTarget ]
          
            resultTexture = device.makeTexture( descriptor:tex_desc )
            resultTexture?.label = "MediumTexture.resultTexture"
            
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
