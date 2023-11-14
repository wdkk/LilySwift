//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

import QuartzCore
import Metal

open class LLImage
{
    var _imgc:LCImageSmPtr
    
    public init( wid:Int, hgt:Int, type:LLImageType = .rgbaf ) { 
        _imgc = LCImageMake( wid, hgt, type )
    }
    
    public init( _ path:LLString ) { 
        _imgc = LCImageMakeWithFile( path.lcStr )
    }
    
    public init( assetName:LLString ) {
        _imgc = LCImageMake( 0, 0, .rgbaf )
        #if os(macOS)
        guard let llimg = NSImage( named:assetName )?.llImage else { return }
        LCImageCopy( llimg._imgc, self._imgc ) 
        #else
        guard let llimg = UIImage( named:assetName )?.llImage else { return }
        LCImageCopy( llimg._imgc, self._imgc ) 
        #endif
    }
    
    public init( _ imgptr:LCImageSmPtr ) {
        _imgc = LCImageClone( imgptr ) 
    }
    
    public init( _ cgImage:CGImage ) {
        _imgc = CGImage2LCImage( cgImage )
    }
    
    public convenience init?( _ texture:MTLTexture ) {
        // TODO: もう少しテクスチャのパターンに対応したい
        if texture.pixelFormat == .rgba16Unorm {
            self.init( wid: texture.width, hgt: texture.height, type: .rgba16 )
        }
        else if texture.pixelFormat == .rgba32Float {
            self.init( wid: texture.width, hgt: texture.height, type: .rgbaf )
        }
        else if texture.pixelFormat == .rgba8Unorm {
            self.init( wid: texture.width, hgt: texture.height, type: .rgba8 )
        }
        else if texture.pixelFormat == .rgba8Unorm_srgb {
            self.init( wid: texture.width, hgt: texture.height, type: .rgba8 )
        }
        else { return nil }
        
        guard let nonnull_memory:LLBytePtr = memory else { return nil }
        guard let opaque_memory:OpaquePointer = OpaquePointer( nonnull_memory ) else { return nil }
    
        texture.getBytes( UnsafeMutableRawPointer( opaque_memory ),
                          bytesPerRow: rowBytes,
                          from: MTLRegionMake2D(0, 0, texture.width, texture.height),
                          mipmapLevel: 0 )
    }

    open var available:Bool { return LCImageGetType( _imgc ) != .none }
    
    open var lcImage:LCImageSmPtr { return self._imgc }
    
    open var cgImage:CGImage? { 
        return LCImage2CGImage( self.lcImage )?.takeUnretainedValue()
    }
    
    #if os(iOS) || os(visionOS)
    open var uiImage:UIImage? { return LCImage2UIImage( self._imgc ) }
    #elseif os(macOS)
    open var nsImage:NSImage? { return LCImage2NSImage( self._imgc ) }
    #endif
        
    open var rgba8Matrix:LLColor8Matrix? { return LCImageRGBA8Matrix( self._imgc ) }

    open var rgba16Matrix:LLColor16Matrix? { return LCImageRGBA16Matrix( self._imgc ) }

    open var rgbafMatrix:LLColorMatrix? { return LCImageRGBAfMatrix( self._imgc ) }
    
    open var grey8Matrix:LLUInt8Matrix? { return LCImageGrey8Matrix( self._imgc ) }
    
    open var grey16Matrix:LLUInt16Matrix? { return LCImageGrey16Matrix( self._imgc ) }
 
    open var greyfMatrix:LLFloatMatrix? { return LCImageGreyfMatrix( self._imgc ) }

    open var hsviMatrix:LLHSViMatrix? { return LCImageHSViMatrix( self._imgc ) }

    open var hsvfMatrix:LLHSVfMatrix? { return LCImageHSVfMatrix( self._imgc ) }
    
    open var memory:LLBytePtr? { return LCImageRawMemory( self._imgc ) }
    
    open var width:Int { return LCImageWidth( self._imgc ) }

    open var height:Int { return LCImageHeight( self._imgc ) }

    open var type:LLImageType { return LCImageGetType( self._imgc ) }
    
    open var scale:LLFloat { return LCImageScale( self._imgc ) }
    
    open var rowBytes:Int { return LCImageRowBytes( self._imgc ) }
    
    open var memoryLength:Int { return LCImageMemoryLength( self._imgc ) }
        
    open func clone() -> LLImage { return LLImage( self._imgc ) }
  
    open func copy( to dest:LLImage ) { LCImageCopy( self._imgc, dest._imgc ) }
    
    open func resize( wid:Int, hgt:Int ) { LCImageResize( self._imgc, wid, hgt ) }

    open func resize( wid:Int, hgt:Int, type:LLImageType ) { LCImageResizeWithType( self._imgc, wid, hgt, type ) }
    
    open func convertType( to type:LLImageType ) { LCImageConvertType( self._imgc, type ) }
    
    @discardableResult
    open func save( to path:String ) -> Bool {
        return LCImageSaveFile( self._imgc, path.lcStr )
    }
    
    @discardableResult
    open func save( to path:String, option:LLImageSaveOption ) -> Bool {
        return LCImageSaveFileWithOption( self._imgc, path.lcStr, option )
    }
}

public extension LLImage
{
    var pixelBuffer:CVPixelBuffer? {
        let dst_row_bytes = self.width * 4
        guard let dst_addr = malloc( self.height * dst_row_bytes ) else { return nil }
                
        var result_buffer:CVPixelBuffer?
        
        guard CVPixelBufferCreateWithBytes( 
           kCFAllocatorDefault,
           self.width, self.height,
           kCVPixelFormatType_32BGRA,
           dst_addr,
           dst_row_bytes,
           { 
               if let buf = $1 {
                   free( UnsafeMutableRawPointer( mutating: buf ) )
               }
           },
           nil, nil,
           &result_buffer )
        == kCVReturnSuccess else {
            free( dst_addr )
            return nil
        }
        
        var src = self
        if self.type != .rgba8 {
            src = self.clone()
            src.convertType(to: .rgba8 )
        }
        
        let src_mat = self.rgba8Matrix!
        
        let dst_ptr = UnsafeMutablePointer<LLUInt8>( OpaquePointer( dst_addr ) )
        
        for j in 0 ..< self.height {
            for i in 0 ..< self.width {
                let ptr = dst_ptr.advanced(by: i * 4 + j * dst_row_bytes )
                (ptr + 2).pointee = src_mat[j][i].R
                (ptr + 1).pointee = src_mat[j][i].G
                (ptr).pointee = src_mat[j][i].B
                (ptr + 3).pointee = src_mat[j][i].A
            }
        }
        
        return result_buffer
    }
}
