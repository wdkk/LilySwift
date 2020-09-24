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

import Foundation

public extension LCImageSaverInternal
{
    func saveTarga( _ img_:LCImageSmPtr, _ file_path_:LCStringSmPtr, _ option_:LLImageSaveOption ) -> Bool {
        // TODO: RLE圧縮の対応
        let HEADER_SIZE:Int = 18

        let wid = LCImageWidth( img_ )
        let hgt = LCImageHeight( img_ )
        let type = LCImageGetType( img_ )
        
        var channel = 3
        switch option_.targa_info {
            case .bit24: channel = 3; break
            case .bit32: channel = 4; break
        }

        let fw = LCFileWriterMake( file_path_, false )
        if !LCFileWriterIsActive( fw ) { return false }

        // ヘッダの準備
        let header = UnsafeMutablePointer<LLUInt8>.allocate(capacity: HEADER_SIZE )
        defer { header.deallocate() }
        
        // ヘッダ内容の設定
        var wid16 = wid.u16!
        var hgt16 = hgt.u16!
        
        header[0] = 0                              // ID
        header[1] = 0                              // マップの有無
        header[2] = 2                              // フルカラータイプ
        memset( &header[3], 0x00, 2 )              // カラーマップエントリ
        memset( &header[5], 0x00, 2 )              // カラーマップエントリ長
        header[7] = 0                              // カラーマップエントリ色深度
        memset( &header[8], 0x00, 2 )              // X座標
        memset( &header[10], 0x00, 2 )             // Y座標
        memcpy( &header[12], &wid16, 2 )           // 横幅
        memcpy( &header[14], &hgt16, 2 )           // 高さ
        header[16] = (8 * channel).u8!             // 色深度(24 or 32)
        header[17] = 0;                            // スタイル

        // ヘッダ書き込み
        LCFileWriterWrite( fw, header, HEADER_SIZE.i64 )

        // オリジンのチェック
        let x_origin = (header[17] >> 4 & 0x01) == 0 ?  1 : -1
        let y_origin = (header[17] >> 5 & 0x01) == 0 ? -1 :  1
        var tga_x  = (x_origin > 0) ? 0 : wid - 1
        var tga_y  = (y_origin > 0) ? 0 : hgt - 1
        // x方向ループスキャンごとに用いるx初期値
        let tga_xs = tga_x

        // [32bit 無圧縮]
        if channel == 4 {
            let tga_mem = UnsafeMutablePointer<LLUInt8>.allocate(capacity: wid * hgt * 4 )
            defer { tga_mem.deallocate() }
            
            let tga_ptr = tga_mem
            // 8bitデータ
            if type == .rgba8 {
                guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        pp.pointee     = mat8[y][x].B
                        (pp+1).pointee = mat8[y][x].G
                        (pp+2).pointee = mat8[y][x].R
                        (pp+3).pointee = mat8[y][x].A
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // 16bitデータ
            else if type == .rgba16 {
                guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        pp.pointee     = LLConv16to8( mat16[y][x].B )
                        (pp+1).pointee = LLConv16to8( mat16[y][x].G )
                        (pp+2).pointee = LLConv16to8( mat16[y][x].R )
                        (pp+3).pointee = LLConv16to8( mat16[y][x].A )
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }    
            }
            // 32bitデータ
            else if type == .rgbaf {
                guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {            
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        pp.pointee     = LLConvfto8( matf[y][x].B )
                        (pp+1).pointee = LLConvfto8( matf[y][x].G )
                        (pp+2).pointee = LLConvfto8( matf[y][x].R )
                        (pp+3).pointee = LLConvfto8( matf[y][x].A )
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }    
            }
            // グレー8ビット
            else if type == .grey8 {
                guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        let g8 = mat_g8[y][x]
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = LLColor8_MaxValue
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // グレー16ビット
            else if type == .grey16 {
                guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        let g8 = LLConv16to8( mat_g16[y][x] )
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = LLColor8_MaxValue
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // グレーfloat
            else if type == .greyf {
                guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        let g8 = LLConvfto8( mat_gf[y][x] )
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        (pp+3).pointee = LLColor8_MaxValue
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // hsv(float)データ
            else if type == .hsvf {
                guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        let c  = LLHSVftoColor8( mat_hsvf[y][x] )
                        pp.pointee     = c.B
                        (pp+1).pointee = c.G
                        (pp+2).pointee = c.R
                        (pp+3).pointee = c.A
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // hsv(16,8,8)データ
            else if type == .hsvi {
                guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 4)
                        let c  = LLHSVitoColor8( mat_hsvi[y][x] )
                        pp.pointee     = c.B
                        (pp+1).pointee = c.G
                        (pp+2).pointee = c.R
                        (pp+3).pointee = c.A
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // データ配列を書き込み
            LCFileWriterWrite( fw, tga_mem, (wid * hgt * 4).i64 )
        }
        // [24bit 無圧縮]
        else if channel == 3 {
            let tga_mem = UnsafeMutablePointer<LLUInt8>.allocate(capacity: wid * hgt * 3 )
            defer { tga_mem.deallocate() }
            
            let tga_ptr = tga_mem
            // 8bitデータ
            if type == .rgba8 {
                guard let mat8 = LCImageRGBA8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        pp.pointee     = mat8[y][x].B
                        (pp+1).pointee = mat8[y][x].G
                        (pp+2).pointee = mat8[y][x].R
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // 16bitデータ
            else if type == .rgba16 {
                guard let mat16 = LCImageRGBA16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        pp.pointee     = LLConv16to8( mat16[y][x].B )
                        (pp+1).pointee = LLConv16to8( mat16[y][x].G )
                        (pp+2).pointee = LLConv16to8( mat16[y][x].R )
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }  
            }
            // 32bitデータ
            else if type == .rgbaf {
                guard let matf = LCImageRGBAfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {            
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        pp.pointee     = LLConvfto8( matf[y][x].B )
                        (pp+1).pointee = LLConvfto8( matf[y][x].G )
                        (pp+2).pointee = LLConvfto8( matf[y][x].R )
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }       
            }
            // グレー8ビット
            else if type == .grey8 {
                guard let mat_g8 = LCImageGrey8Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        let g8 = mat_g8[y][x]
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // グレー16ビット
            else if type == .grey16 {
                guard let mat_g16 = LCImageGrey16Matrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        let g8 = LLConv16to8( mat_g16[y][x] )
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // グレーfloat
            else if type == .greyf {
                guard let mat_gf = LCImageGreyfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        let g8 = LLConvfto8( mat_gf[y][x] )
                        pp.pointee     = g8
                        (pp+1).pointee = g8
                        (pp+2).pointee = g8
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // HSV(float)データ
            else if type == .hsvf {
                guard let mat_hsvf = LCImageHSVfMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        let c  = LLHSVftoColor8( mat_hsvf[y][x] )
                        pp.pointee     = c.B
                        (pp+1).pointee = c.G
                        (pp+2).pointee = c.R
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }
            // HSV(float)データ
            else if type == .hsvi {
                guard let mat_hsvi = LCImageHSViMatrix( img_ ) else { return false }
                for y in 0 ..< hgt {
                    tga_x = tga_xs
                    for x in 0 ..< wid {
                        let pp = tga_ptr + ((tga_x + tga_y * wid) * 3)
                        let c  = LLHSVitoColor8( mat_hsvi[y][x] )
                        pp.pointee     = c.B
                        (pp+1).pointee = c.G
                        (pp+2).pointee = c.R
                        tga_x += x_origin
                    }
                    tga_y += y_origin
                }
            }

            // データ配列を書き込み
            LCFileWriterWrite( fw, tga_mem, (wid * hgt * 3).i64 )
        }

        return true;
    }
}

#endif
