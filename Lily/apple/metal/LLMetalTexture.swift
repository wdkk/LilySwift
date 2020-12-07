//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Metal
import MetalKit

public class LLMetalTexture 
{    
    public private(set) var metalTexture:MTLTexture?
    
    public var width:Int { return metalTexture != nil ? metalTexture!.width : 0 }
    public var height:Int { return metalTexture != nil ? metalTexture!.height : 0 }
    
    // 空のテクスチャで生成
    public init() {}
    
    // バンドル画像からの読み込み
    public init( named bundle_path:String ) {
        let image = LLImage( LLPath.bundle( bundle_path ) )
        if !image.available { 
            self.metalTexture = nil
            return
        }
        
        self.setImage( image )
    }
    
    // パスを指定しての読み込み
    public init( _ path:String ) {
        let image = LLImage( path )
        if !image.available { 
            self.metalTexture = nil
            return
        }
        
        self.setImage( image )
    }
    
    // Lily画像オブジェクトからの作成
    public init( llImage img:LLImage ) {
        let reg = MTLRegionMake2D( 0, 0, img.width, img.height )
        guard let memory = img.memory, 
            let pointer = UnsafeRawPointer( memory ) else { 
                LLLogWarning( "メモリが取得できませんでした" )
                return 
        }
        
        switch img.type {
        case .rgba8:
            allocate( img.width, img.height )
            self.metalTexture?.replace( region: reg, mipmapLevel: 0, withBytes: pointer, bytesPerRow: img.rowBytes )
            break
        case .rgba16:
            allocate( img.width, img.height, .rgba16Unorm )
            self.metalTexture?.replace( region: reg, mipmapLevel: 0, withBytes: pointer, bytesPerRow: img.rowBytes )
            break
        case .rgbaf:
            allocate( img.width, img.height, .rgba32Float )
            self.metalTexture?.replace( region: reg, mipmapLevel: 0, withBytes: pointer, bytesPerRow: img.rowBytes )
        default:
            LLLogWarning( "未対応のLLImageの形式です." )
        }
    }
    
    public init( mtlTexture:MTLTexture? ) {
        guard let mtltex = mtlTexture else { 
            self.metalTexture = nil
            return
        }
        self.metalTexture = mtltex
    }
    
    public func setImage( _ img:LLImage ) {       
        allocate( img.width, img.height )

        let reg = MTLRegionMake2D( 0, 0, img.width, img.height )
        let pointer = unsafeBitCast( img.memory, to: UnsafeRawPointer.self )
        self.metalTexture?.replace( region: reg, mipmapLevel: 0, withBytes: pointer, bytesPerRow: img.rowBytes )
    }
    
    private func allocate( _ width:Int, _ height:Int, _ pixelFormat:MTLPixelFormat = .rgba8Unorm ) {
        if let tex = self.metalTexture,
           tex.width == width && tex.height == height && tex.pixelFormat == pixelFormat {
           return
        }
        
        let tex_desc = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: pixelFormat,
            width: width,
            height: height,
            mipmapped: false )
        tex_desc.usage = [.shaderRead, .shaderWrite]
        
        self.metalTexture = LLMetalManager.shared.device?.makeTexture( descriptor: tex_desc )
    }
}
