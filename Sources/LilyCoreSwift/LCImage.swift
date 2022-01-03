//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public func LCImageRawTreat( _ lcimg_:LCImageSmPtr, _ wid_:Int, _ hgt_:Int, _ type_:LLImageType ) {
    switch type_ {
    case .rgba8:
        lcimg_.rawimg = LCImageRGBA8( wid_, hgt_ )
        break
    case .rgba16:
        lcimg_.rawimg = LCImageRGBA16( wid_, hgt_ )
        break
    case .rgbaf:
        lcimg_.rawimg = LCImageRGBAf( wid_, hgt_ )
        break
    case .grey8:
        lcimg_.rawimg = LCImageGrey8( wid_, hgt_ )
        break
    case .grey16:
        lcimg_.rawimg = LCImageGrey16( wid_, hgt_ )
        break
    case .greyf:
        lcimg_.rawimg = LCImageGreyf( wid_, hgt_ )
        break
    case .hsvf:
        lcimg_.rawimg = LCImageHSVf( wid_, hgt_ )
        break
    case .hsvi:
        lcimg_.rawimg = LCImageHSVi( wid_, hgt_ )
        break
    default:
        break
    }
}

public func LCImageZero() -> LCImageSmPtr {
    let lcimg:LCImageSmPtr = LCImageSmPtr()
    LCImageRawTreat( lcimg, 0, 0, .none )
    return lcimg
}

public func LCImageMake( _ wid_:Int, _ hgt_:Int, _ type_:LLImageType ) -> LCImageSmPtr {
    let lcimg:LCImageSmPtr = LCImageSmPtr()
    LCImageRawTreat( lcimg, wid_, hgt_, type_ )
    return lcimg
}

public func LCImageMakeWithFile( _ file_path_:LCStringSmPtr ) -> LCImageSmPtr {
    return LDImageLoadFileWithOption( file_path_, LLImageLoadOptionDefault() )
}

public func LCImageMakeWithFileAndOption( _ file_path_:LCStringSmPtr, _ option_:LLImageLoadOption ) -> LCImageSmPtr {
    return LDImageLoadFileWithOption( file_path_, option_ )
}

public func LCImageSaveFile( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr ) -> Bool {
    return LDImageSaveFileWithOption( img_, file_path_, LLImageSaveOptionDefault() )
}

public func LCImageSaveFileWithOption( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr,
                                       _ option_:LLImageSaveOption ) -> Bool {
    return LDImageSaveFileWithOption( img_, file_path_, option_ )
}

public func LCImageClone( _ img_src_:LCImageSmPtr ) -> LCImageSmPtr {
    let lcimg:LCImageSmPtr = LCImageSmPtr()
    lcimg.rawimg = img_src_.rawimg?.clone()
    return lcimg
}

public func LCImageClonePremultipliedAlpha( _ img_src_:LCImageSmPtr ) -> LCImageSmPtr {  
    let lcimg:LCImageSmPtr = LCImageSmPtr()
    lcimg.rawimg = img_src_.rawimg?.clonePremultipliedAlpha()
    return lcimg
}

public func LCImageRawMatrix( _ img_:LCImageSmPtr ) -> LLVoidMatrix? {
    guard let rawimg:LCImageRaw = img_.rawimg else { return nil }
    return rawimg.getRawMatrix()
}

public func LCImageRGBA8Matrix( _ img_:LCImageSmPtr ) -> LLColor8Matrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .rgba8 { return nil }
    return LLColor8Matrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageRGBA16Matrix( _ img_:LCImageSmPtr ) -> LLColor16Matrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .rgba16 { return nil }
    return LLColor16Matrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageRGBAfMatrix( _ img_:LCImageSmPtr ) -> LLColorMatrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .rgbaf { return nil }
    return LLColorMatrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageGrey8Matrix( _ img_:LCImageSmPtr ) -> LLUInt8Matrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .grey8 { return nil }
    return LLUInt8Matrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageGrey16Matrix( _ img_:LCImageSmPtr ) -> LLUInt16Matrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .grey16 { return nil }
    return LLUInt16Matrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageGreyfMatrix( _ img_:LCImageSmPtr ) -> LLFloatMatrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .greyf { return nil }
    return LLFloatMatrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageHSViMatrix( _ img_:LCImageSmPtr ) -> LLHSViMatrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .hsvi { return nil }
    return LLHSViMatrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageHSVfMatrix( _ img_:LCImageSmPtr ) -> LLHSVfMatrix? {
    guard let raw_matrix:LLVoidMatrix = img_.rawimg?.getRawMatrix() else { return nil }
    if LCImageGetType( img_ ) != .hsvf { return nil }
    return LLHSVfMatrix( OpaquePointer( UnsafeRawPointer( raw_matrix ) ) )
}

public func LCImageRawMemory( _ img_:LCImageSmPtr ) -> LLBytePtr? {
    guard let rawimg:LCImageRaw = img_.rawimg else { return nil }
    return rawimg.getRawMemory()
}

public func LCImageWidth( _ img_:LCImageSmPtr ) -> Int {
    guard let rawimg:LCImageRaw = img_.rawimg else { return 0 }
    return rawimg.getWidth()
}

public func LCImageHeight( _ img_:LCImageSmPtr ) -> Int {
    guard let rawimg:LCImageRaw = img_.rawimg else { return 0 }
    return rawimg.getHeight()
}

public func LCImageRowBytes( _ img_:LCImageSmPtr ) -> Int {
    guard let rawimg:LCImageRaw = img_.rawimg else { return 0 }
    return rawimg.getRowBytes()
}

public func LCImageMemoryLength( _ img_:LCImageSmPtr ) -> Int {
    guard let rawimg:LCImageRaw = img_.rawimg else { return 0 }
    return rawimg.getMemoryLength()
}

public func LCImageGetType( _ img_:LCImageSmPtr ) -> LLImageType {
    guard let rawimg:LCImageRaw = img_.rawimg else { return .none }
    return rawimg.getImageType()
}

public func LCImageScale( _ img_:LCImageSmPtr ) -> LLFloat {
    guard let rawimg:LCImageRaw = img_.rawimg else { return 0.0 }
    return rawimg.getScale()
}

public func LCImageChangeScale( _ img_:LCImageSmPtr, _ sc_:LLFloat ) {
    guard let rawimg:LCImageRaw = img_.rawimg else { return }
    rawimg.setScale( sc_ )
}

// resize image
public func LCImageResize( _ img_:LCImageSmPtr, _ wid_:Int, _ hgt_:Int ) {
    LCImageResizeWithType( img_, wid_, hgt_, LCImageGetType( img_ ) )
}

public func LCImageCopy( _ img_src_:LCImageSmPtr, _ img_dst_:LCImageSmPtr ) {
    img_dst_.rawimg = img_src_.rawimg?.clone()
}

// resize image contained depth
public func LCImageResizeWithType( _ img_:LCImageSmPtr, _ wid_:Int, _ hgt_:Int, _ type_:LLImageType ) {
    if type_ == .none { return }

    if LCImageWidth( img_ ) == wid_ && LCImageHeight( img_ ) == hgt_ && LCImageGetType( img_ ) == type_ { return }
    
    LCImageRawTreat( img_, wid_, hgt_, type_ )
}

public func LCImageConvertType( _ img_:LCImageSmPtr, _ type_:LLImageType ) {
    if LCImageGetType( img_ ) == type_ { return }
    guard let rawimg:LCImageRaw = img_.rawimg else { return }
    
    img_.rawimg = rawimg.convert( type_ )
}

public func LCImageCheckLoadTypeByExtension( _ option_:LLImageLoadOption, _ ext_:LCStringSmPtr ) -> LLImageLoadType {
    let extc:LLCChars = LCStringToCChars( ext_ )
    // autoではない場合はそのまま返す
    if option_.type != .auto { return option_.type }

    // reading image file
    if( strcmp( extc, "jpg" ) == 0 || strcmp( extc, "JPG" ) == 0 || strcmp( extc, "jpeg" ) == 0 || strcmp( extc, "JPEG" ) == 0 ) {
        return .jpeg
    }
    else if( strcmp( extc, "png" ) == 0 || strcmp( extc, "PNG" ) == 0 ) {
        return .png
    }
    else if( strcmp( extc, "bmp" ) == 0 || strcmp( extc, "BMP" ) == 0 ) {
        return .bitmap
    }
    else if( strcmp( extc, "tif" ) == 0 || strcmp( extc, "TIF" ) == 0 || strcmp( extc, "tiff" ) == 0 || strcmp( extc, "TIFF" ) == 0 ) {
        return .tiff
    }
    else if( strcmp( extc, "gif" ) == 0 || strcmp( extc, "GIF" ) == 0 ) {
        return .gif
    }
    else if( strcmp( extc, "tga" ) == 0 || strcmp( extc, "TGA" ) == 0 ) {
        return .targa
    }

    return option_.type
}

public func LCImageCheckSaveTypeByExtension(_ option_:LLImageSaveOption, _ ext_:LCStringSmPtr ) -> LLImageSaveType {
    let extc:LLCChars = LCStringToCChars( ext_ )
    // autoではない場合はそのまま返す
    if option_.type != .auto { return option_.type }

    if( strcmp( extc, "jpg" ) == 0 || strcmp( extc, "JPG" ) == 0 || strcmp( extc, "jpeg" ) == 0 || strcmp( extc, "JPEG" ) == 0 ) {
        return .jpeg
    }
    else if( strcmp( extc, "png" ) == 0 || strcmp( extc, "PNG" ) == 0 ) {
        return .png
    }
#if !os(iOS)
    if( strcmp( extc, "bmp" ) == 0 || strcmp( extc, "BMP" ) == 0 ) {
        return .bitmap
    }
    else if( strcmp( extc, "tif" ) == 0 || strcmp( extc, "tiff" ) == 0 || strcmp( extc, "TIF" ) == 0 || strcmp( extc, "TIFF" ) == 0 ) {
        return .tiff
    }
    else if( strcmp( extc, "tga" ) == 0 || strcmp( extc, "TGA" ) == 0 ) {
        return .targa
    }
#endif
    
    return option_.type
}


#if os(iOS)

import UIKit

// iPhone only
public func LCImage2UIImage( _ img_:LCImageSmPtr ) -> UIImage? {    
    let wid:Int = LCImageWidth( img_ )
    let hgt:Int = LCImageHeight( img_ )
    
    // 乗算済みアルファをCGImageへ
    let lcimg:LCImageSmPtr = LCImageClonePremultipliedAlpha( img_ )
    // rgba8bitに変換
    LCImageConvertType( lcimg, .rgba8 )
    
    let color_space:CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
    guard let memory:LLBytePtr = LCImageRawMemory( lcimg ) else { return nil }
    let cg_context:CGContext? = CGContext( data: memory, width: wid, height: hgt,
                                           bitsPerComponent: 8, 
                                           bytesPerRow: wid * 4,
                                           space: color_space,
                                           bitmapInfo: CGBitmapInfo.alphaInfoMask.rawValue + 
                                            CGImageAlphaInfo.premultipliedLast.rawValue )
    
    guard let nonnull_cg_context:CGContext = cg_context else { return nil } 
    guard let cg_img:CGImage = nonnull_cg_context.makeImage() else { return nil }
    
    let ui_img:UIImage = UIImage(cgImage: cg_img, scale: LCImageScale( lcimg ).cgf, orientation: .up )
    
    return ui_img
}

public func UIImage2LCImage( _ img_:UIImage ) -> LCImageSmPtr {    
    let wid:Int = img_.size.width.i!
    let hgt:Int = img_.size.height.i!
    
    let lcimg:LCImageSmPtr = LCImageMake( wid, hgt, .rgba8 )
    
    guard let input_image_ref:CGImage = img_.cgImage else { return LCImageSmPtr() } 
    
    let color_space:CGColorSpace = CGColorSpaceCreateDeviceRGB()
    
    guard let memory = LCImageRawMemory( lcimg ) else { return LCImageSmPtr() }
    let cg_context:CGContext? = CGContext( data: memory, width: wid, height: hgt,
                                           bitsPerComponent: 8,
                                           bytesPerRow: wid * 4,
                                           space: color_space,
                                           bitmapInfo: CGBitmapInfo.alphaInfoMask.rawValue + 
                                            CGImageAlphaInfo.premultipliedLast.rawValue )
    guard let nonnull_cg_context:CGContext = cg_context else { return LCImageSmPtr() }     

    nonnull_cg_context.draw( input_image_ref, in: CGRect( 0, 0, wid.cgf, hgt.cgf ) )
    
    guard let conv_img:CGImage = nonnull_cg_context.makeImage() else { return LCImageSmPtr() }
    
    guard let provider:CGDataProvider = conv_img.dataProvider else { return LCImageSmPtr() }
    let input_data:CFData? = provider.data
    let row:Int = conv_img.bytesPerRow
    
    guard let pixel_data:UnsafePointer<UInt8> = CFDataGetBytePtr( input_data ) else { return LCImageSmPtr() }
    guard let mat:LLColor8Matrix = LCImageRGBA8Matrix( lcimg ) else { return LCImageSmPtr() }

    for y in 0 ..< hgt {
        for x in 0 ..< wid {
            mat[y][x] = LLColor8Make(
                pixel_data[x * 4 + y * row],
                pixel_data[x * 4 + y * row + 1],
                pixel_data[x * 4 + y * row + 2],
                pixel_data[x * 4 + y * row + 3] )
        }
    }

    LCImageChangeScale( lcimg, img_.scale.f )
    
    return lcimg
}

#elseif os(macOS)

import AppKit

public func LCImage2NSImage( _ img_:LCImageSmPtr ) -> NSImage {
    guard let cg_img = LCImage2CGImage( img_ ) else { 
        return NSImage(size: CGSize( LCImageWidth( img_ ), LCImageHeight( img_ ) ) )
    }
    
    return NSImage(cgImage: cg_img.takeUnretainedValue(), 
                   size: CGSize( LCImageWidth( img_ ), LCImageHeight( img_ ) ) )
}

public func NSImage2LCImage( _ img_:NSImage ) -> LCImageSmPtr {
    var nsimage_rect:CGRect = CGRect( 0, 0, img_.size.width, img_.size.height )
    let cgimg:CGImage = img_.cgImage( forProposedRect:&nsimage_rect, 
                                      context: nil,
                                      hints: nil)!
    return CGImage2LCImage( cgimg )
}
#endif

public func LCImage2CGImage( _ img_:LCImageSmPtr ) -> Unmanaged<CGImage>? {  
    let wid:Int = LCImageWidth( img_ )
    let hgt:Int = LCImageHeight( img_ )
    
    // 乗算済みアルファを作成しCGImage化
    let lcimg:LCImageSmPtr = LCImageClonePremultipliedAlpha( img_ )
    LCImageConvertType( lcimg, .rgba8 )
    
    guard let memory:LLBytePtr = LCImageRawMemory( lcimg ) else { return nil }
    
    let bitmap_info:CGBitmapInfo = CGBitmapInfo( rawValue:
        CGBitmapInfo.alphaInfoMask.rawValue & 
        CGImageAlphaInfo.premultipliedLast.rawValue )
    
    let color_space:CGColorSpace = CGColorSpaceCreateDeviceRGB()
    let cg_context:CGContext? = CGContext( data: memory, width: wid, height: hgt,
                                           bitsPerComponent: 8,
                                           bytesPerRow: wid * 4,
                                           space: color_space,
                                           bitmapInfo: bitmap_info.rawValue )

    guard let nn_cg_context:CGContext = cg_context else { return nil } 
    guard let cg_img = nn_cg_context.makeImage() else { return nil }
    let unmanaged_cg_img = Unmanaged<CGImage>.passRetained( cg_img )
    return unmanaged_cg_img.autorelease()
}

public func CGImage2LCImage( _ img_:CGImage ) -> LCImageSmPtr {

    let data:CFData? = img_.dataProvider?.data
    let width:Int = img_.width
    let height:Int = img_.height
    let length:CFIndex = CFDataGetLength( data )
    
    let lcimg:LCImageSmPtr = LCImageMake( width, height, .rgba8 )
    let memory:LLBytePtr? = LCImageRawMemory( lcimg )
    CFDataGetBytes( data, CFRangeMake( 0, length ), memory )
    let matrix:LLColor8Matrix = LCImageRGBA8Matrix( lcimg )!
    
    for y in 0 ..< height { 
        for x in 0 ..< width {
            LLSwap( &matrix[y][x].R, &matrix[y][x].B )
        }
    }
    
    return lcimg
}
