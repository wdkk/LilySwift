//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public extension LCImageLoaderInternal
{
    // RLE圧縮の復号
    private func decodeTargaRLE( _ dst:LLUInt8Ptr, _ src:LLUInt8Ptr, _ dst_size:Int, _ src_size:Int, _ mem_size:Int ) {
        var n:Int = 0
        var pos:Int = 0
        var dst_pos:Int = 0
        let decode_size:Int = mem_size / 8 // 1ピクセルのデータサイズ
        var rle_count:Int = 0
        var rle_repeating:Int = 0
        var read_next_pixel:Int = 0

        var dec_ptr:[LLUInt8] = [LLUInt8]( repeating: 0, count: decode_size )
        
        while pos < src_size && dst_pos < dst_size {
            if rle_count == 0 {
                n = src![pos].i
                pos += 1
                
                let rle_cmd:Int = n
                rle_count = 1 + ( rle_cmd & 127 )
                rle_repeating = rle_cmd >> 7
                read_next_pixel = 1
            }
            else if rle_repeating < 1 {
                read_next_pixel = 1
            }

            if read_next_pixel > 0 {
                for i:Int in 0 ..< decode_size {
                    dec_ptr[i] = src![pos]
                    pos += 1
                }
                read_next_pixel = 0
            }

            for i:Int in 0 ..< decode_size {
                dst![dst_pos] = dec_ptr[i]
                dst_pos += 1
            }

            rle_count -= 1
        }
    }
    
    func loadTarga( _ file_path_:LCStringSmPtr, _ option_:LLImageLoadOption = LLImageLoadOptionDefault() ) -> LCImageSmPtr {
        let HEADER_SIZE:Int = 18
        
        let fr:LCFileReaderSmPtr = LCFileReaderMake( file_path_ )
        if !LCFileReaderIsActive( fr ) { return LCImageZero() }
        
        // ヘッダの読み込み
        var header:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate( capacity: HEADER_SIZE )
        defer { header.deallocate() }
        LCFileReaderRead( fr, header, LLInt64(HEADER_SIZE) )
        
        //LLUInt8 ID                  = header[0]
        //LLUInt8 colorMap            = header[1]
        let image_type:LLUInt8        = header[2]
        //LLInt16 color_entry      = (int)*((LLInt16*)(&header[3]))
        let color_entry_length:LLInt16 = UnsafePointer<LLInt16>( OpaquePointer( header.advanced(by: 5) ) ).pointee
        let color_entry_depth:LLUInt8  = header[7]
        //LLInt16 X                = (int)*((LLInt16*)(&header[8]))
        //LLInt16 Y                = (int)*((LLInt16*)(&header[10]))
        let wid:Int                   = UnsafePointer<LLInt16>( OpaquePointer( header.advanced(by: 12) ) ).pointee.i
        let hgt:Int                   = UnsafePointer<LLInt16>( OpaquePointer( header.advanced(by: 14) ) ).pointee.i
        let depth:LLUInt8             = header[16]
        let style:LLUInt8             = header[17]
    
        // 対応しているTARGA形式のチェック
        if( !( image_type == 2 ) &&    // フルカラー
            !( image_type == 10 ) &&    // フルカラー圧縮
            !( image_type == 1 && color_entry_length != 0 && color_entry_depth != 0 )    // 256色
            ) 
        {
            return LCImageZero()        
        }
        
        // 画像メモリのリサイズ
        let img:LCImageSmPtr = LCImageMake( wid, hgt, .rgba8 )
        guard let mat:LLColor8Matrix = LCImageRGBA8Matrix( img ) else { return LCImageZero() }
        
        // オリジンのチェック
        let x_origin:Int = ( style >> 4 & 0x01 ) == 0 ?  1 : -1
        let y_origin:Int = ( style >> 5 & 0x01 ) == 0 ? -1 :  1
        var tga_x:Int = (x_origin > 0) ? 0 : wid - 1
        var tga_y:Int = (y_origin > 0) ? 0 : hgt - 1
        // x方向ループスキャンごとに用いるx初期値
        let tga_xs:Int = tga_x
        
        // 色深度のチェック
        if depth == 32 {
            var tga_mem:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: wid * hgt * 4 )
            defer { tga_mem.deallocate() }
            
            // 圧縮している場合
            if image_type == 10 {
                // ヘッダをのぞいたメモリサイズを取得
                let buf_size:Int = LCFileGetSize( file_path_ ).i! - HEADER_SIZE
                let tga_mem_tmp:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: buf_size )
                defer { tga_mem_tmp.deallocate() }
                
                LCFileReaderRead( fr, tga_mem_tmp, buf_size.i64 )
                // 復号化
                decodeTargaRLE( tga_mem, tga_mem_tmp, wid * hgt * 4, buf_size, 32 )
            }
            // 無圧縮の場合    
            else {
                LCFileReaderRead( fr, tga_mem, (wid * hgt * 4).i64 )    
            }
            
            let tga_ptr:UnsafeMutablePointer<LLUInt8> = tga_mem
            for y:Int in 0 ..< hgt {
                tga_x = tga_xs
                for x:Int in 0 ..< wid {
                    mat[y][x].B = tga_ptr[(tga_x + tga_y * wid) * 4]
                    mat[y][x].G = tga_ptr[(tga_x + tga_y * wid) * 4 + 1]
                    mat[y][x].R = tga_ptr[(tga_x + tga_y * wid) * 4 + 2]
                    mat[y][x].A = tga_ptr[(tga_x + tga_y * wid) * 4 + 3]
                    tga_x += x_origin
                }
                tga_y += y_origin
            }
        }
        else if depth == 24 {
            var tga_mem:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: wid * hgt * 3 )
            defer { tga_mem.deallocate() }
            // 圧縮している場合
            if image_type == 10 {
                // ヘッダをのぞいたメモリサイズを取得
                let buf_size:Int = LCFileGetSize( file_path_ ).i! - HEADER_SIZE
                let tga_mem_tmp:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: buf_size )
                defer { tga_mem_tmp.deallocate() }
                // 復号化
                decodeTargaRLE( tga_mem, tga_mem_tmp, wid * hgt * 3, buf_size, 24 )
            }
            // 無圧縮の場合    
            else {
                LCFileReaderRead( fr, tga_mem, (wid * hgt * 3).i64 )    
            }
            
            let tga_ptr:UnsafeMutablePointer<LLUInt8> = tga_mem
            for y:Int in 0 ..< hgt {
                tga_x = tga_xs
                for x:Int in 0 ..< wid {
                    mat[y][x].B = tga_ptr[(tga_x + tga_y * wid) * 3]
                    mat[y][x].G = tga_ptr[(tga_x + tga_y * wid) * 3 + 1]
                    mat[y][x].R = tga_ptr[(tga_x + tga_y * wid) * 3 + 2]
                    mat[y][x].A = LLColor8_MaxValue
                    tga_x += x_origin
                }
                tga_y += y_origin
            } 
        }
        else if depth == 8 {
            // カラーマップの取得
            let map_length:Int = color_entry_length.i        // カラーマップの数
            let map_size:Int = color_entry_depth.i / 8    // バイト数に直す
            var map_color:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: map_length * map_size )
            defer { map_color.deallocate() }
            
            LCFileReaderRead( fr, map_color, (map_length * map_size).i64 )
            
            // tgaメモリ配列の取得
            var tga_mem:UnsafeMutablePointer<LLUInt8> = UnsafeMutablePointer<LLUInt8>.allocate(capacity: wid * hgt )
            defer { tga_mem.deallocate() }
            
            LCFileReaderRead( fr, tga_mem, (wid * hgt).i64 )
            
            let tga_ptr:UnsafeMutablePointer<LLUInt8> = tga_mem
            let color_ptr:UnsafeMutablePointer<LLUInt8> = map_color
            for y:Int in 0 ..< hgt {
                tga_x = tga_xs
                for x:Int in 0 ..< wid {
                    let idx:Int = tga_ptr[ (tga_x + tga_y * wid) ].i
                    
                    mat[y][x].B = color_ptr[idx * map_size]
                    mat[y][x].G = color_ptr[idx * map_size + 1]
                    mat[y][x].R = color_ptr[idx * map_size + 2]
                    mat[y][x].A = LLColor8_MaxValue
                    
                    tga_x += x_origin
                }
                tga_y += y_origin
            }
        }
        
        return img
    }
}
