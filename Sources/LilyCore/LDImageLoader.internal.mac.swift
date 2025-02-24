//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

#if os(macOS)

import AppKit

public extension LCImageLoaderInternal
{
    func load( _ file_path_:String, _ option:LLImageLoadOption = LLImageLoadOptionDefault() ) async -> LCImageSmPtr {
        if !LCFileExists( file_path_.lcStr ) {
            LLLogWarning( "ファイルが見つかりません.:\( String( file_path_ ) )" )
            return await LCImageZero()
        }
        
        let path = file_path_
        let ns_img = NSImage(contentsOfFile: path )
        guard let tiff_presen = ns_img?.tiffRepresentation else { return await LCImageZero() }
        guard let bmp_rep = NSBitmapImageRep( data: tiff_presen ) else { return await LCImageZero() }
    
        let wid = bmp_rep.pixelsWide
        let hgt = bmp_rep.pixelsHigh
        let bytes_per_row = bmp_rep.bytesPerRow
        let depth = bmp_rep.bitsPerSample
        let samples = bytes_per_row / wid
        let has_alpha = bmp_rep.hasAlpha

        let img = await LCImageMake( wid, hgt, .rgba8 )
        
        if depth == 8 {
            await LCImageResizeWithType( img, wid, hgt, .rgba8 )
            guard let mat = await LCImageRGBA8Matrix( img ) else { return await LCImageZero() }
            guard let buffer = bmp_rep.bitmapData else { return await LCImageZero() }
            
            let xstride = samples
            let row = bytes_per_row
            
            // アルファあり
            if has_alpha {
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer.advanced(by: x * xstride + y * row)
                        mat[y][x].R = p.pointee
                        mat[y][x].G = (p + 1).pointee
                        mat[y][x].B = (p + 2).pointee
                        mat[y][x].A = (p + 3).pointee
                    }
                }
            }
            // アルファなし
            else {
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer.advanced(by: x * xstride + y * row)
                        mat[y][x].R = p.pointee
                        mat[y][x].G = (p + 1).pointee
                        mat[y][x].B = (p + 2).pointee
                        mat[y][x].A = LLColor8_MaxValue
                    }
                }
            }
        }
        else if depth == 16 {
            await LCImageResizeWithType( img, wid, hgt, .rgba16 )
            guard let mat16 = await LCImageRGBA16Matrix( img ) else { return await LCImageZero() }
            guard let buffer = bmp_rep.bitmapData else { return await LCImageZero() }
            guard let buffer16 = UnsafePointer<LLUInt16>( OpaquePointer( UnsafeRawPointer( buffer ) ) )
            else { return await LCImageZero() }
            
            let xstride = samples / 2
            let row = bytes_per_row / 2
            
            // アルファあり
            if has_alpha {
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer16.advanced(by: x * xstride + y * row) 
                        mat16[y][x].R = p.pointee
                        mat16[y][x].G = (p+1).pointee
                        mat16[y][x].B = (p+2).pointee
                        mat16[y][x].A = (p+3).pointee
                    }
                }
            }
            // アルファなし
            else {
                for y in 0 ..< hgt {
                    for x in 0 ..< wid {
                        let p = buffer16.advanced(by: x * xstride + y * row) 
                        mat16[y][x].R = p.pointee
                        mat16[y][x].G = (p+1).pointee
                        mat16[y][x].B = (p+2).pointee
                        mat16[y][x].A = LLColor16_MaxValue
                    }
                }
            }
        }
        
        return img
    }
}

#endif
