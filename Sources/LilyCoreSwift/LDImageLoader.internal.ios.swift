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

#if os(iOS)

import UIKit

public extension LCImageLoaderInternal
{
    func load( _ file_path_:LCStringSmPtr, _ option_:LLImageLoadOption = LLImageLoadOptionDefault() ) -> LCImageSmPtr {
        if !LCFileExists( file_path_ ) {
            LLLog( "ファイルが見つかりません.:\( String( file_path_ ) )" )
            return LCImageZero()
        }
        
        // Targaの場合別途処理
        if option_.type == .targa {
            return loadTarga( file_path_, option_ )
        }
        
        let path = String( file_path_ ) 
        guard let ui_img = UIImage(contentsOfFile: path ) else { return LCImageZero() }
        guard let cg_img = ui_img.cgImage else { return LCImageZero() }
        let wid = cg_img.width
        let hgt = cg_img.height
        let bytes_per_row = cg_img.bytesPerRow
        let samples = bytes_per_row / wid
        let pixel_bits = cg_img.bitsPerPixel
        
        var depth = LLInt32()
        var channel = LLInt32()
        
        switch pixel_bits {
            case 8:
                depth = 8
                channel = 1
                break
            case 16:
                depth = 16
                channel = 1
                break
            case 24:
                depth = 8
                channel = 3
                break
            case 32:
                depth = 8
                channel = 4
                break
            case 48:
                depth = 16
                channel = 3
                break
            case 64:
                depth = 16
                channel = 4
                break
            default:
                return LCImageZero()
        }
        
        guard let prov = cg_img.dataProvider else { return LCImageZero() }
        guard let cf_data = prov.data else { return LCImageZero() }

        let img = LCImageMake( wid, hgt, .rgba8 )
        
        if depth == 8 {
            LCImageResizeWithType( img, wid, hgt, .rgba8 )
            guard let mat = LCImageRGBA8Matrix( img ) else { return LCImageZero() }
            guard let buffer = CFDataGetBytePtr( cf_data ) else { return LCImageZero() }
            
            let xstride = samples
            let row = bytes_per_row
            
            switch channel {
            case 1:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer.advanced(by: x * xstride + y * row)
                        mat[y][x].R = p.pointee
                        mat[y][x].G = p.pointee
                        mat[y][x].B = p.pointee
                        mat[y][x].A = LLColor8_MaxValue
                    }
                }
                break
            case 3:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer.advanced(by: x * xstride + y * row)
                        mat[y][x].R = p.pointee
                        mat[y][x].G = (p + 1).pointee
                        mat[y][x].B = (p + 2).pointee
                        mat[y][x].A = LLColor8_MaxValue
                    }
                }
                break
            case 4:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        // TODO: iOS13からalpha処理が不要になった? このあたりちょっと謎だが要対応
                        let p = buffer.advanced(by: x * xstride + y * row)
                        mat[y][x].R = p.pointee
                        mat[y][x].G = (p + 1).pointee
                        mat[y][x].B = (p + 2).pointee
                        mat[y][x].A = (p + 3).pointee
                    }
                }
                break
            default:
                return LCImageZero()
            }
        }
        else if depth == 16 {
            LCImageResizeWithType( img, wid, hgt, .rgba16 )
            guard let mat16 = LCImageRGBA16Matrix( img ) else { return LCImageZero() }
            guard let buffer = CFDataGetBytePtr( cf_data ) else { return LCImageZero() }
            guard let buffer16 = UnsafePointer<LLUInt16>( OpaquePointer( UnsafeRawPointer( buffer ) ) )
            else { return LCImageZero() }
            
            let xstride = samples / 2
            let row = bytes_per_row / 2
            
            switch channel {
            case 1:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer16.advanced(by: x * xstride + y * row) 
                        mat16[y][x].R = p.pointee
                        mat16[y][x].G = p.pointee
                        mat16[y][x].B = p.pointee
                        mat16[y][x].A = LLColor16_MaxValue
                    }
                }
                break 
            case 3:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer16.advanced(by: x * xstride + y * row) 
                        mat16[y][x].R = p.pointee
                        mat16[y][x].G = (p+1).pointee
                        mat16[y][x].B = (p+2).pointee
                        mat16[y][x].A = LLColor16_MaxValue
                    }
                }
                break
            case 4:
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer16.advanced(by: x * xstride + y * row) 
                        mat16[y][x].R = p.pointee
                        mat16[y][x].G = (p+1).pointee
                        mat16[y][x].B = (p+2).pointee
                        mat16[y][x].A = (p+3).pointee
                    }
                }
                break
            default:
                return LCImageZero()
            }
        }
        
        return img
    }
}

#endif
