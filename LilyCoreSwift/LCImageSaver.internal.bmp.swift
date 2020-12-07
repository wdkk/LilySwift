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

import Foundation

struct LLBitmapInfo
{
    var width:Int = 0
    var height:Int = 0
    var mod:Int = 0
    var row_byte:Int = 0
    var header_length:Int = 0
    var file_size:Int = 0
    var memory = [UInt8](repeating: 0, count: 54)
}

public extension LCImageSaverInternal
{
    fileprivate func LCImageSaverBitmapHeader( _ img_:LCImageSmPtr, _ bmp_type_:LLImageBitmapInfo ) -> LLBitmapInfo {
        var info = LLBitmapInfo()
        info.width  = LCImageWidth( img_ )
        info.height = LCImageHeight( img_ )
        
        if bmp_type_ == .bit24 {
            info.mod = (info.width * 3) % 4 != 0 ? 4 - ( (info.width * 3) % 4) : 0
            info.row_byte = info.width * 3 + info.mod
        }
        else {
            info.mod = 0
            info.row_byte = info.width * 4
        }
        info.header_length = 54
        info.file_size = info.header_length + info.row_byte * info.height

        var bit_count = 24
        switch bmp_type_  {
            case .bit24: bit_count = 24; break
            case .bit32: bit_count = 32; break
        }

        // Bitmap file header(14バイト)
        var bfh_type:LLUInt16 = 0x4d42
        var bfh_size:LLUInt32 = info.file_size.u32!
        var bfh_reserved1:LLUInt16 = 0
        var bfh_reserved2:LLUInt16 = 0
        var bfh_offbits:LLUInt32 = info.header_length.u32!
        // Bitmap info header(40バイト)
        var bih_size:LLUInt32 = 40
        var bih_width:LLInt32 = info.width.i32!
        var bih_height:LLInt32 = info.height.i32!
        var bih_planes:LLUInt16 = 1
        var bih_bit_count:LLUInt16 = bit_count.u16!
        var bih_compression:LLUInt32 = 0          // = BI_RGB
        var bih_size_image:LLUInt32 = ( info.file_size - info.header_length ).u32!
        var bih_x_pels_per_meter:LLInt32 = ( 72 * 100.0 / 2.54 ).i32!
        var bih_y_pels_per_meter:LLInt32 = ( 72 * 100.0 / 2.54 ).i32!
        var bih_color_used:LLUInt32 = 0
        var bih_color_important:LLUInt32 = 0

        var p:Int = 0
        memcpy( &info.memory[p], &bfh_type, 2 ); p += 2
        memcpy( &info.memory[p], &bfh_size, 4 ); p += 4
        memcpy( &info.memory[p], &bfh_reserved1, 2 ); p += 2
        memcpy( &info.memory[p], &bfh_reserved2, 2 ); p += 2
        memcpy( &info.memory[p], &bfh_offbits, 4 ); p += 4

        memcpy( &info.memory[p], &bih_size, 4 ); p += 4
        memcpy( &info.memory[p], &bih_width, 4 ); p += 4
        memcpy( &info.memory[p], &bih_height, 4 ); p += 4
        memcpy( &info.memory[p], &bih_planes, 2 ); p += 2
        memcpy( &info.memory[p], &bih_bit_count, 2 ); p += 2
        memcpy( &info.memory[p], &bih_compression, 4 ); p += 4
        memcpy( &info.memory[p], &bih_size_image, 4 ); p += 4
        memcpy( &info.memory[p], &bih_x_pels_per_meter, 4 ); p += 4
        memcpy( &info.memory[p], &bih_y_pels_per_meter, 4 ); p += 4
        memcpy( &info.memory[p], &bih_color_used, 4 ); p += 4
        memcpy( &info.memory[p], &bih_color_important, 4 )

        return info
    }
    
    func saveBitmap( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr, _ option_:LLImageSaveOption ) -> Bool {
        let type = LCImageGetType( img_ )

        // ヘッダデータの内挿とBitmap情報の返却
        let info = LCImageSaverBitmapHeader( img_, option_.bitmap_info )
        // メモリオーバーラン防止のための余剰分確保(CGImageなどとの取り合わせ)
        let buf_offset = info.row_byte * 8    
        let buffer = UnsafeMutablePointer<LLUInt8>.allocate(capacity: info.file_size + buf_offset )
        
        // ヘッダ分のデータをコピー
        memcpy( buffer, info.memory, info.header_length )
        
        let wid = info.width
        let hgt = info.height
        let row = info.row_byte

        // ピクセルデータの先頭ポインタ
        let p = buffer + info.header_length
        
        // 24bit
        if option_.bitmap_info == .bit24 {
            if type == .rgba8 {
                guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = mat8[y][x]
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .rgba16 {
                guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLColor16to8( mat16[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .rgbaf {
                guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLColorfto8( matf[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .grey8 {
                guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLGrey8toColor8( mat_g8[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .grey16 {
                guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLGrey16toColor8( mat_g16[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .greyf {
                guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLGreyftoColor8( mat_gf[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .hsvf {
                guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLHSVftoColor8( mat_hsvf[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
            else if type == .hsvi {
                guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let c8 = LLHSVitoColor8( mat_hsvi[y][x] )
                        let pp = p + (x * 3 + (hgt - y - 1) * row)
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                    }
                }
            }
        }
        // 32bit
        else if option_.bitmap_info == .bit32 {
            if type == .rgba8 {
                guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                // 透明部の補完カラー
                let bc = LLColor8Make( LLColor8_MaxValue, LLColor8_MaxValue, LLColor8_MaxValue, LLColor8_MaxValue )
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        var c8 = mat8[y][x]
                        let k = c8.A.i
                        let ik = LLColor8_MaxValue.i - k
                        let w = LLColor8_MaxValue.i
                        c8.R = ((c8.R.i * k + bc.R.i * ik) / w).u8!
                        c8.G = ((c8.G.i * k + bc.G.i * ik) / w).u8!
                        c8.B = ((c8.B.i * k + bc.B.i * ik) / w).u8!                 
                        pp.pointee = c8.B
                        (pp+1).pointee = c8.G
                        (pp+2).pointee = c8.R
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .rgba16 {
                guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                // 透明部の補完カラー
                let bc = LLColor16Make( LLColor16_MaxValue, LLColor16_MaxValue, LLColor16_MaxValue, LLColor16_MaxValue )
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        var c16 = mat16[y][x]
                        let k = c16.A.i
                        let ik = LLColor16_MaxValue.i - k
                        let w = LLColor16_MaxValue.i
                        c16.R = ((c16.R.i * k + bc.R.i * ik) / w).u16!
                        c16.G = ((c16.G.i * k + bc.G.i * ik) / w).u16!
                        c16.B = ((c16.B.i * k + bc.B.i * ik) / w).u16!                 
                        pp.pointee = LLConv16to8( c16.B )
                        (pp+1).pointee = LLConv16to8( c16.G )
                        (pp+2).pointee = LLConv16to8( c16.R )
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .rgbaf {
                guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                // 透明部の補完カラー
                let bc = LLColorMake( LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue )
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        var cf = matf[y][x]
                        let k = cf.A
                        let ik = LLColor_MaxValue - k
                        let w = LLColor_MaxValue
                        cf.R = ((cf.R * k + bc.R * ik) / w)
                        cf.G = ((cf.G * k + bc.G * ik) / w)
                        cf.B = ((cf.B * k + bc.B * ik) / w)                 
                        pp.pointee = LLConvfto8( cf.B )
                        (pp+1).pointee = LLConvfto8( cf.G )
                        (pp+2).pointee = LLConvfto8( cf.R )
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .grey8 {
                guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        let g8 = mat_g8[y][x]               
                        pp.pointee = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .grey16 {
                guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        let g8 = LLConv16to8( mat_g16[y][x] )            
                        pp.pointee = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .greyf {
                guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        let g8 = LLConvfto8( mat_gf[y][x] )            
                        pp.pointee = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .hsvf {
                guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                // 透明部の補完カラー
                let bc = LLColorMake( LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue )
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        var cf = LLHSVftoColorf( mat_hsvf[y][x] )
                        let k = cf.A
                        let ik = LLColor_MaxValue - k
                        let w = LLColor_MaxValue
                        cf.R = ((cf.R * k + bc.R * ik) / w)
                        cf.G = ((cf.G * k + bc.G * ik) / w)
                        cf.B = ((cf.B * k + bc.B * ik) / w)                 
                        pp.pointee = LLConvfto8( cf.B )
                        (pp+1).pointee = LLConvfto8( cf.G )
                        (pp+2).pointee = LLConvfto8( cf.R )
                        (pp+3).pointee = 0
                    }
                }
            }
            else if type == .hsvi {
                guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                // 透明部の補完カラー
                let bc = LLColorMake( LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue, LLColor_MaxValue )
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let pp = p + (x * 4 + (hgt - y - 1) * row)
                        var cf = LLHSVitoColorf( mat_hsvi[y][x] )
                        let k = cf.A
                        let ik = LLColor_MaxValue - k
                        let w = LLColor_MaxValue
                        cf.R = ((cf.R * k + bc.R * ik) / w)
                        cf.G = ((cf.G * k + bc.G * ik) / w)
                        cf.B = ((cf.B * k + bc.B * ik) / w)                 
                        pp.pointee = LLConvfto8( cf.B )
                        (pp+1).pointee = LLConvfto8( cf.G )
                        (pp+2).pointee = LLConvfto8( cf.R )
                        (pp+3).pointee = 0
                    }
                }
            }
        }

        // ファイル書き出し
        let fw = LCFileWriterMake( file_path_, false )
        return LCFileWriterWrite( fw, buffer, info.file_size.i64 )
    }
}

#endif
