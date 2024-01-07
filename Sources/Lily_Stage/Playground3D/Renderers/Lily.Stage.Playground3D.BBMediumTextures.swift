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
    open class BBMediumRenderTextures
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        var billboardTexture: MTLTexture?

        public init( device:MTLDevice ) {
            self.device = device
        }
        
        @discardableResult
        public func updateBuffers( size:CGSize, viewCount:Int ) -> Bool {
            if billboardTexture != nil && 
               billboardTexture!.width.d == size.width && 
               billboardTexture!.height.d == size.height 
            { return false }
            
            // テクスチャ再生成の作業
            let tex_desc = MTLTextureDescriptor.texture2DDescriptor( 
                pixelFormat:.rgba8Unorm,
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
            
            // particleTextureの再生成
            tex_desc.pixelFormat = Lily.Stage.BufferFormats.linearSRGBBuffer
            billboardTexture = device.makeTexture( descriptor:tex_desc )
            billboardTexture?.label = "Billboard Texture"
            
            return true
        }
    }
}
