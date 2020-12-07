//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

#if os(macOS)

import AppKit

public extension LCImageSaverInternal
{
    func save( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr, _ option_:LLImageSaveOption = LLImageSaveOptionDefault() ) 
    -> Bool {
        autoreleasepool {
            var properties = [NSBitmapImageRep.PropertyKey:Any]()
            var file_type:NSBitmapImageRep.FileType = .png
            var sample_bit:Int = 32
            
            // Targa
            if option_.type == .targa {
                // 自作関数に任せる
                return saveTarga( img_, file_path_, option_ )
            }
            // Bitmap
            else if option_.type == .bitmap {
                // 自作関数に任せる
                return saveBitmap( img_, file_path_, option_ )
            }
            // PNG
            else if option_.type == .png {
                sample_bit = 32
                file_type = .png
                properties[ .compressionFactor ] = NSNumber(value: option_.png_compress )
            }
            // JPEG
            else if option_.type == .jpeg {
                sample_bit = 24
                file_type = .jpeg
                properties[ .compressionFactor ] = NSNumber(value: option_.jpeg_quality )
            }
            // Tiff
            else if option_.type == .tiff {
                file_type = .tiff
                var comp:NSBitmapImageRep.TIFFCompression = .none
                switch option_.tiff_info {
                case .none: comp = .none; break
                case .lzw:  comp = .lzw; break
                }
                properties[ .compressionMethod ] = NSNumber(value: comp.rawValue )
                properties[ .compressionFactor ] = NSNumber(value: 0.0 )
            }
            
            let wid = LCImageWidth( img_ )
            let hgt = LCImageHeight( img_ )
            let type = LCImageGetType( img_ )
            var bmp_rep:NSBitmapImageRep? = nil
          
            // [32bit]
            if sample_bit == 32 {
                let row = wid * 4
                let sz  = row * hgt
                let buffer = UnsafeMutablePointer<LLUInt8>.allocate( capacity: sz )
                defer { buffer.deallocate() }
                
                if type == .rgba8 {
                    guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = mat8[y][x]
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .rgba16 {
                    guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLColor16to8( mat16[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .rgbaf {
                    guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLColorfto8( matf[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .grey8 {
                    guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGrey8toColor8( mat_g8[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .grey16 {
                    guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGrey16toColor8( mat_g16[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if( type == .greyf ) {
                    guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGreyftoColor8( mat_gf[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .hsvf {
                    guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLHSVftoColor8( mat_hsvf[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else if type == .hsvi {
                    guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLHSVitoColor8( mat_hsvi[y][x] )
                            let k = LLFloat( c.A ) / LLFloat( LLColor8_MaxValue )
                            buffer[x * 4 + y * row]     = (c.R.f * k).u8!
                            buffer[x * 4 + y * row + 1] = (c.G.f * k).u8!
                            buffer[x * 4 + y * row + 2] = (c.B.f * k).u8!
                            buffer[x * 4 + y * row + 3] = c.A
                        }
                    }
                }
                else {
                    return false
                }
            
                var buffer_2d:UnsafeMutablePointer<LLUInt8>? = buffer
                
                bmp_rep = NSBitmapImageRep(
                            bitmapDataPlanes: &buffer_2d,
                            pixelsWide:wid,
                            pixelsHigh:hgt,
                            bitsPerSample:8,
                            samplesPerPixel:4,
                            hasAlpha:true,
                            isPlanar:false,
                            colorSpaceName:NSColorSpaceName.deviceRGB,
                            bytesPerRow:row,
                            bitsPerPixel:32 )
            }
            // [24bit]
            else if sample_bit == 24 {
                let row = wid * 3
                let sz  = row * hgt
                let buffer = UnsafeMutablePointer<LLUInt8>.allocate( capacity: sz )
                defer { buffer.deallocate() }
                
                if type == .rgba8 {
                    guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = mat8[y][x]
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .rgba16 {
                    guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLColor16to8( mat16[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .rgbaf {
                    guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLColorfto8( matf[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .grey8 {
                    guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGrey8toColor8( mat_g8[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .grey16 {
                    guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGrey16toColor8( mat_g16[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .greyf {
                    guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLGreyftoColor8( mat_gf[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .hsvf {
                    guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLHSVftoColor8( mat_hsvf[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else if type == .hsvi {
                    guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                    for y in 0 ..< hgt {
                        for x in 0 ..< wid {
                            let c = LLHSVitoColor8( mat_hsvi[y][x] )
                            let p = buffer + (x * 3 + y * row)
                            p.pointee = c.R
                            (p+1).pointee = c.G
                            (p+2).pointee = c.B
                        }
                    }
                }
                else {
                    return false
                }
                
                var buffer_2d:UnsafeMutablePointer<LLUInt8>? = buffer
                
                bmp_rep = NSBitmapImageRep(
                            bitmapDataPlanes: &buffer_2d,
                            pixelsWide:wid,
                            pixelsHigh:hgt,
                            bitsPerSample:8,
                            samplesPerPixel:3,
                            hasAlpha:false,
                            isPlanar:false,
                            colorSpaceName:NSColorSpaceName.deviceRGB,
                            bytesPerRow:row,
                            bitsPerPixel:24 )
            }
            
            if bmp_rep == nil { return false }
            
            // 書き込みData型の作成
            guard let data = bmp_rep!.representation( using: file_type, properties: properties ) else { return false }
        
            // 書き込み
            do {
                try data.write(to: URL(fileURLWithPath: String( file_path_ ) ) )
                return true
            }
            catch {
                return false
            }
        }
        
    }
}

#endif

#endif
