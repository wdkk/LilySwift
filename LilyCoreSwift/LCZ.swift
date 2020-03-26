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
import zlib
import Compression

/// zlib圧縮タイプ列挙子
public enum LLZCompressionType : Int
{
    /// 無圧縮
    case no_compression = 0     
    /// 圧縮スピード優先
    case best_speed = 1         
    /// 圧縮率優先
    case best_compression = 9   
    /// 標準品質の圧縮
    case default_compression = -1
}

private let ZLIB_VERSION = "1.2.11"
private let Z_ALLOC_BUFFER_SIZE = 2097152    // 2MB

/// zlibの伸長処理
/// - Parameters:
///   - ptr: 圧縮したデータポインタ
///   - length: データ長(バイト)
/// - Returns: LilyCoreデータオブジェクト
public func LCZInflate( _ ptr:LLNonNullUInt8Ptr, _ length:Int ) -> LCDataSmPtr {
    let full_length = uInt( length )
    if full_length == 0 { 
        LLLogWarning( "データサイズが0です.zlib伸長を中止します." )
        return LCDataMake()
    }
    
    var done = false
    
    var strm = z_stream()
    strm.next_in = ptr
    strm.avail_in = full_length
    strm.total_out = 0
    strm.zalloc = nil //Z_NULL
    strm.zfree = nil  //Z_NULL
    strm.opaque = nil //Z_NULL
    
    if inflateInit_( &strm, ZLIB_VERSION, MemoryLayout.size(ofValue: strm ).i32! ) != Z_OK {
        LLLogWarning( "zlib伸長の初期化に失敗しました." )
        return LCDataMake()
    }

    var buf = unsafeBitCast( malloc( Z_ALLOC_BUFFER_SIZE ), to: LLUInt8Ptr.self )
    var bufsize = Z_ALLOC_BUFFER_SIZE
    var tmp:LLUInt8Ptr?
    
    var status = Z_OK

    while !done {
        if( status == Z_STREAM_END ) { 
            done = true
        }
        else if( status != Z_BUF_ERROR && status != Z_OK ) {
            break
        }
    
        if( strm.total_out >= bufsize ) {
            tmp = unsafeBitCast( malloc( bufsize ), to: LLUInt8Ptr.self )
            memcpy( tmp!, buf, bufsize )
            free( buf )
            
            buf = unsafeBitCast( malloc( bufsize + Z_ALLOC_BUFFER_SIZE ), to: LLUInt8Ptr.self )
            memcpy( buf, tmp!, bufsize )
            free( tmp! )
            
            bufsize += Z_ALLOC_BUFFER_SIZE
        }
                
        strm.next_out  = buf!.advanced(by: Int( strm.total_out ) )
        strm.avail_out = uInt( bufsize - Int( strm.total_out ) )
        
        status = inflate( &strm, Z_NO_FLUSH )
    }
    
    if status != Z_STREAM_END {
        LLLogWarning( "zlib伸長に失敗しました" )
        free( buf )
        inflateEnd( &strm )
        return LCDataMake()
    }
    
    if inflateEnd( &strm ) != Z_OK {
        LLLogWarning( "zlib伸長に失敗しました" )
        free( buf )
        return LCDataMake()
    }
    
    let out_size = strm.total_out
    if out_size == 0 {
        LLLogWarning( "zlib伸長結果のサイズが0です" )
        free( buf )
        return LCDataMake()
    }

    let new_data = LCDataMakeWithBytes( buf, Int64( out_size ) )
    free( buf )
    
    return new_data
}

/// zlibの圧縮処理
/// - Parameters:
///   - ptr: 圧縮したデータポインタ
///   - length: データ長(バイト)
///   - type: 圧縮タイプ
/// - Returns: LilyCoreデータオブジェクト
public func LCZDeflate( _ ptr:LLNonNullUInt8Ptr, _ length:Int, _ type:LLZCompressionType ) -> LCDataSmPtr {
    let full_length = uInt( length )
    if full_length == 0 { 
        LLLogWarning( "データサイズが0です.zlib圧縮を中止します." );
        return LCDataMake()
    }

    var strm = z_stream()
    strm.next_in   = ptr
    strm.avail_in  = full_length
    strm.total_out = 0
    strm.zalloc    = nil // Z_NULL
    strm.zfree     = nil // Z_NULL
    strm.opaque    = nil // Z_NULL

    if deflateInit_( &strm, type.rawValue.i32!, ZLIB_VERSION, MemoryLayout.size(ofValue: strm ).i32! ) != Z_OK {
        LLLogWarning( "zlib圧縮の初期化に失敗しました." )
        return LCDataMake()
    }
    
    var buf = unsafeBitCast( malloc( Z_ALLOC_BUFFER_SIZE ), to: LLUInt8Ptr.self )
    var bufsize = Z_ALLOC_BUFFER_SIZE
    var tmp:LLUInt8Ptr?
    
    var result = Z_OK

    while true {
        if result == Z_STREAM_END { break }
        
        if strm.total_out >= bufsize {
            tmp = unsafeBitCast( malloc( bufsize ), to: LLUInt8Ptr.self )
            memcpy( tmp!, buf, bufsize )
            free( buf )
            buf = unsafeBitCast( malloc( bufsize + Z_ALLOC_BUFFER_SIZE ), to: LLUInt8Ptr.self )
            memcpy( buf, tmp!, bufsize )
            free( tmp! )
            
            bufsize += Z_ALLOC_BUFFER_SIZE
        }
                
        strm.next_out  = buf!.advanced(by: Int( strm.total_out ) )
        strm.avail_out = uInt( bufsize - Int( strm.total_out ) )

        result = deflate( &strm, Z_FINISH )
        if result == Z_STREAM_ERROR { break }
    }

    if result != Z_STREAM_END {
        LLLogWarning( "zlib圧縮に失敗しました." )
        free( buf )
        deflateEnd( &strm )
        return LCDataMake()
    }

    let out_size = strm.total_out
    if out_size == 0 {
        LLLogWarning( "zlib圧縮結果のサイズが0です." )
        free( buf )
        deflateEnd( &strm )
        return LCDataMake()
    }
    
    let new_data = LCDataMakeWithBytes( buf, Int64( out_size ) )
    
    free( buf )
    deflateEnd( &strm )
    return new_data
}
