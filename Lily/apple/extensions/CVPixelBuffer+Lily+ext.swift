//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Accelerate

public extension CVPixelBuffer 
{
    func crop( rect cropRect:CGRect ) -> CVPixelBuffer? {
        let flags = CVPixelBufferLockFlags( rawValue:0 )
        if CVPixelBufferLockBaseAddress( self, flags ) != kCVReturnSuccess { return nil }
        
        defer { CVPixelBufferUnlockBaseAddress( self, flags ) }
        
        guard let src_addr = CVPixelBufferGetBaseAddress( self ) else { return nil }
        
        let x = cropRect.x.i!
        let y = cropRect.y.i!
        let wid = cropRect.width.i!
        let hgt = cropRect.height.i!
        
        if wid < 1 || hgt < 1 { return nil }
        
        let src_row_bytes = CVPixelBufferGetBytesPerRow( self )
        let offset = y * src_row_bytes + x * 4
        var src_buffer = vImage_Buffer( data: src_addr.advanced( by:offset ),
                                        height: hgt.u!,
                                        width: wid.u!,
                                        rowBytes: src_row_bytes )
        
        let dst_row_bytes = wid * 4
        guard let dst_addr = malloc( hgt * dst_row_bytes ) else { return nil }
        
        var dst_buffer = vImage_Buffer( data: dst_addr,
                                        height: hgt.u!,
                                        width: wid.u!,
                                        rowBytes: dst_row_bytes )
        
        if vImageScale_ARGB8888( &src_buffer, &dst_buffer, nil, 0 ) != kvImageNoError {
            free( dst_addr )
            return nil
        }
        
        var result_buffer:CVPixelBuffer?
        
        guard CVPixelBufferCreateWithBytes( 
           kCFAllocatorDefault,
           wid, hgt,
           CVPixelBufferGetPixelFormatType( self ),
           dst_addr,
           dst_row_bytes,
           { 
               // メモリ解放 
               free( UnsafeMutableRawPointer( mutating: $1 ) )
           },
           nil, nil,
           &result_buffer )
        == kCVReturnSuccess else {
            free( dst_addr )
            return nil
        }
        
        return result_buffer
    }
    
    func cropToLLImage( rect cropRect:CGRect ) -> LLImage? {
        let flags = CVPixelBufferLockFlags( rawValue:0 )
        if CVPixelBufferLockBaseAddress( self, flags ) != kCVReturnSuccess { return nil }
        
        defer { CVPixelBufferUnlockBaseAddress( self, flags ) }
        
        guard let src_addr = CVPixelBufferGetBaseAddress( self ) else { return nil }
        
        let x = cropRect.x.i!
        let y = cropRect.y.i!
        let wid = cropRect.width.i!
        let hgt = cropRect.height.i!
        
        if wid < 1 || hgt < 1 { return nil }
        
        let src_row_bytes = CVPixelBufferGetBytesPerRow( self )
        
        let dst_img = LLImage( wid: wid, hgt: hgt, type: .rgba8 )
        let dst_mat = dst_img.rgba8Matrix!
        
        let src_ptr = UnsafeMutablePointer<LLUInt8>( OpaquePointer( src_addr ) )
        
        for j in 0 ..< hgt {
            for i in 0 ..< wid {
                let ptr = src_ptr.advanced(by: (x+i) * 4 + (y+j) * src_row_bytes )
                dst_mat[j][i].R = (ptr + 2).pointee
                dst_mat[j][i].G = (ptr + 1).pointee
                dst_mat[j][i].B = (ptr).pointee
                dst_mat[j][i].A = (ptr + 3).pointee
            }
        }
        
        return dst_img
    }
    
    var llImage:LLImage? {
        let flags = CVPixelBufferLockFlags( rawValue:0 )
        if CVPixelBufferLockBaseAddress( self, flags ) != kCVReturnSuccess { return nil }
        
        defer { CVPixelBufferUnlockBaseAddress( self, flags ) }
        
        guard let src_addr = CVPixelBufferGetBaseAddress( self ) else { return nil }
        
        let x = 0
        let y = 0
        let wid = CVPixelBufferGetWidth( self )
        let hgt = CVPixelBufferGetHeight( self )

        let src_row_bytes = CVPixelBufferGetBytesPerRow( self )
        
        let dst_img = LLImage( wid: wid, hgt: hgt, type: .rgba8 )
        let dst_mat = dst_img.rgba8Matrix!
        
        let src_ptr = UnsafeMutablePointer<LLUInt8>( OpaquePointer( src_addr ) )
        
        for j in 0 ..< hgt {
            for i in 0 ..< wid {
                let ptr = src_ptr.advanced(by: (x+i) * 4 + (y+j) * src_row_bytes )
                dst_mat[j][i].R = (ptr + 2).pointee
                dst_mat[j][i].G = (ptr + 1).pointee
                dst_mat[j][i].B = (ptr).pointee
                dst_mat[j][i].A = (ptr + 3).pointee
            }
        }
        
        return dst_img
    }
}

#endif
