//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

#if os(iOS)

import UIKit

public extension LCImageSaverInternal
{
    func save( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr, _ option_:LLImageSaveOption = LLImageSaveOptionDefault() ) 
    -> Bool {
        autoreleasepool {
            let wid    = LCImageWidth( img_ )
            let hgt    = LCImageHeight( img_ )
            let type   = LCImageGetType( img_ )
            let row    = wid * 4
            let sz     = row * hgt
            let buffer = UnsafeMutablePointer<LLUInt8>.allocate( capacity: sz )
            defer { buffer.deallocate() }
                        
            if type == .rgba8 {
                guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // CGBitmapコンテクストでpremultiになるため、あらかじめ掛け算しておく
                        let c = LLColor8tof( mat8[y][x] )
                        let k = c.A
                        buffer[x*4 + y*row]   = LLConvfto8( c.R * k )
                        buffer[x*4 + y*row+1] = LLConvfto8( c.G * k )
                        buffer[x*4 + y*row+2] = LLConvfto8( c.B * k )
                        buffer[x*4 + y*row+3] = LLConvfto8( c.A )
                    }
                }
            }
            else if type == .rgba16 {
                guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // CGBitmapコンテクストでpremultiになるため、あらかじめ掛け算しておく
                        let c = LLColor16tof( mat16[y][x] )
                        let k = c.A
                        buffer[x*4 + y*row]   = LLConvfto8( c.R * k )
                        buffer[x*4 + y*row+1] = LLConvfto8( c.G * k )
                        buffer[x*4 + y*row+2] = LLConvfto8( c.B * k )
                        buffer[x*4 + y*row+3] = LLConvfto8( c.A )
                    }
                }
            }
            else if type == .rgbaf {
                guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // CGBitmapコンテクストでpremultiになるため、あらかじめ掛け算しておく
                        let c = matf[y][x]
                        let k = c.A
                        buffer[x*4 + y*row]   = LLConvfto8( c.R * k )
                        buffer[x*4 + y*row+1] = LLConvfto8( c.G * k )
                        buffer[x*4 + y*row+2] = LLConvfto8( c.B * k )
                        buffer[x*4 + y*row+3] = LLConvfto8( c.A )
                    }
                }
            }
            else if type == .grey8 {
                guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let g8 = mat_g8[y][x]
                        buffer[x*4 + y*row]   = g8
                        buffer[x*4 + y*row+1] = g8
                        buffer[x*4 + y*row+2] = g8
                        buffer[x*4 + y*row+3] = LLColor8_MaxValue
                    }
                }
            }
            else if type == .grey16 {
                guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let g8 = LLGrey16to8( mat_g16[y][x] )
                        buffer[x*4 + y*row]   = g8
                        buffer[x*4 + y*row+1] = g8
                        buffer[x*4 + y*row+2] = g8
                        buffer[x*4 + y*row+3] = LLColor8_MaxValue
                    }
                }
            }
            else if type == .greyf {
                guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let g8 = LLGreyfto8( mat_gf[y][x] )
                        buffer[x*4 + y*row]   = g8
                        buffer[x*4 + y*row+1] = g8
                        buffer[x*4 + y*row+2] = g8
                        buffer[x*4 + y*row+3] = LLColor8_MaxValue
                    }
                }
            }
            else if type == .hsvf {
                guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // CGBitmapコンテクストでpremultiになるため、あらかじめ掛け算しておく
                        let c = LLHSVftoColorf( mat_hsvf[y][x] )
                        let k = c.A
                        buffer[x*4 + y*row]   = LLConvfto8( c.R * k )
                        buffer[x*4 + y*row+1] = LLConvfto8( c.G * k )
                        buffer[x*4 + y*row+2] = LLConvfto8( c.B * k )
                        buffer[x*4 + y*row+3] = LLConvfto8( c.A )
                    }
                }
            }
            else if type == .hsvi {
                guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // CGBitmapコンテクストでpremultiになるため、あらかじめ掛け算しておく
                        let c = LLHSVitoColorf( mat_hsvi[y][x] )
                        let k = c.A
                        buffer[x*4 + y*row]   = LLConvfto8( c.R * k )
                        buffer[x*4 + y*row+1] = LLConvfto8( c.G * k )
                        buffer[x*4 + y*row+2] = LLConvfto8( c.B * k )
                        buffer[x*4 + y*row+3] = LLConvfto8( c.A )
                    }
                }
            }
            else {
                return false
            }
            
            let color_space = CGColorSpaceCreateDeviceRGB()
            let bitmap_info = CGBitmapInfo( rawValue: CGImageAlphaInfo.premultipliedLast.rawValue )
            
            let cg_context = CGContext( data: buffer, 
                                        width: wid,
                                        height: hgt,
                                        bitsPerComponent: 8,
                                        bytesPerRow: wid * 4,
                                        space: color_space,
                                        bitmapInfo: bitmap_info.rawValue )
    
            guard let nonnull_cg_context = cg_context else { return false } 
            guard let cg_img = nonnull_cg_context.makeImage() else { return false }
            
            let ui_img = UIImage(cgImage: cg_img )
            let path = String( file_path_ )
            let url = URL( fileURLWithPath: path )
            
            switch option_.type {
            case .png:
                do {
                    guard let data = ui_img.pngData() else { return false }
                    try data.write( to: url )
                    return true
                }
                catch {
                    return false
                }
            case .jpeg:
                do {
                    guard let data = ui_img.jpegData( compressionQuality: option_.jpeg_quality.cgf ) else { return false }
                    try data.write( to: url )
                    return true
                }
                catch {
                    return false 
                }
            default:
                return false
            }
        }
    }
}

#endif

#endif
