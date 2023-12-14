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
    open class RenderTextures
    { 
        var device:MTLDevice
        var commandQueue:MTLCommandQueue?
        
        var particleTexture: MTLTexture?

        public init( device:MTLDevice ) {
            self.device = device
        }
        
        @discardableResult
        public func updateBuffers( size:CGSize, viewCount:Int ) -> Bool {
            if particleTexture != nil && 
               particleTexture!.width.d == size.width && 
               particleTexture!.height.d == size.height 
            { return false }
            
            // テクスチャ再生成の作業
            let tex_desc = MTLTextureDescriptor.texture2DDescriptor( 
                pixelFormat:.rgba8Unorm,
                width:size.width.i!,
                height:size.height.i!,
                mipmapped:false 
            )
            
            tex_desc.sampleCount = Lily.Stage.BufferFormats.sampleCount
            #if !targetEnvironment(simulator)
            if #available( macCatalyst 14.0, * ) {
                tex_desc.storageMode = .memoryless
            }
            else {
                tex_desc.storageMode = .private            
            }
            #else
            tex_desc.storageMode = .private
            #endif
            if viewCount > 1 {
                tex_desc.textureType = .type2DArray
                tex_desc.arrayLength = viewCount
            }
            tex_desc.usage = [ tex_desc.usage, MTLTextureUsage.renderTarget ]
            
            // GBuffer0の再生成
            tex_desc.pixelFormat = Lily.Stage.BufferFormats.particleBuffer
            particleTexture = device.makeTexture( descriptor:tex_desc )
            
            return true
        }
    }
}
