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

private let LCDataOffsetByte:Int = 16

/// LilyCoreデータモジュール
public class LCDataSmPtr
{
    /// 内部実装オブジェクト(ここではSwiftのDataを援用)
    fileprivate var dt:Data = Data()
}

/// データオブジェクトを作成
/// - Returns: データ量0のデータオブジェクト
public func LCDataMake() -> LCDataSmPtr {
    return LCDataMakeWithSize( 0 )
}

/// データオブジェクトを初期データの長さを指定して作成
/// - Parameter length: 初期に確保するバイト数
/// - Returns: データ量lengthバイトのデータオブジェクト
public func LCDataMakeWithSize( _ length:LLInt64 ) -> LCDataSmPtr {
    let d:LCDataSmPtr = LCDataSmPtr()
    guard let leng:Int = length.i else { return d }
    
    // FIXME: Data型が16バイト未満だとポインタをまともに作成できないため下駄を履かせる(Swift5.1). 
    d.dt = Data( repeating: 0, count: leng + LCDataOffsetByte )     // ゼロクリア
    return d
}

/// データオブジェクトを指定したポインタのメモリから作成
/// - Parameters:
///   - bin: 元になるデータのポインタ
///   - length: データの長さ
/// - Returns: ポインタからの値をコピーしたデータ量lengthバイトのデータオブジェクト
public func LCDataMakeWithBytes( _ bin:LLBytePtr?, _ length:LLInt64 ) -> LCDataSmPtr {
    let d:LCDataSmPtr = LCDataMakeWithSize( length )
    guard let nonnull_bin:LLBytePtr = bin else { LLLogWarning( "引数binがnilです." ); return d }
    guard let leng:Int = length.i else { return d }
    let ptr:LLUInt8Ptr = LCDataPointer( d )
    memcpy( ptr, nonnull_bin, leng )
    return d
}

/// データオブジェクトを指定したポインタのメモリから作成
/// - Parameters:
///   - chars: 元になるデータのポインタ
/// - Returns: ポインタからの値をコピーしたデータ量lengthバイトのデータオブジェクト
public func LCDataMakeWithCChars( _ chars:LLConstCCharsPtr ) -> LCDataSmPtr {
    let d:LCDataSmPtr = LCDataMake()
    let str:String = String( cString: chars )
    let length:Int = str.lengthOfBytes( using: .utf8 )
    d.dt.append( unsafeBitCast( chars, to: LLUInt8Ptr.self )!, count:length )
    return d
} 

/// データオブジェクトを文字列から作成
/// - Parameters:
///   - chars: LilyCore文字列オブジェクト
/// - Returns: 文字列をデータ列に変換したデータオブジェクト
public func LCDataMakeWithString( _ str:LCStringSmPtr ) -> LCDataSmPtr {
    let d:LCDataSmPtr = LCDataMake()
    let ptr:LLCChars = LCStringToCChars( str )
    LCDataAppendChars( d, ptr )
    return d
} 

/// ファイルを読み込んでデータオブジェクトを作成
/// - Parameter path: 読み込むファイルのパス
/// - Returns: ファイルを読み込んだデータオブジェクト
public func LCDataMakeWithFile( _ path:LCStringSmPtr ) -> LCDataSmPtr {
    /* Swift実装
    do {
        d.dt = try Data(contentsOf: String( path ).url )
        return d
    }
    catch {
        return d
    }
    */
 
    // LilyCore実装
    let fr:LCFileReaderSmPtr = LCFileReaderMake( path )
    if !LCFileReaderIsActive( fr ) { return LCDataMake() }
    
    let length:LLInt64 = LCFileGetSize( path )
    
    let d:LCDataSmPtr = LCDataMakeWithSize( length )
    guard let ptr:UnsafeMutablePointer<UInt8> = LCDataPointer( d ) else { return LCDataMake() }
    
    LCFileReaderRead( fr, ptr, length )
    
    return d
}

/// データオブジェクトを複製して新しいオブジェクトを生成する
/// - Parameters:
///   - data: 対象のデータオブジェクト
public func LCDataMakeWithData( _ data:LCDataSmPtr ) -> LCDataSmPtr {
    let d:LCDataSmPtr = LCDataMake()
    guard let ptr:UnsafeMutablePointer<UInt8> = LCDataPointer( data ) else { 
        LLLogWarning( "dataのポインタを取得できませんでした. サイズ0のLCDataを返します." )
        return d 
    }
    d.dt = Data( bytes: ptr, count: LCDataLength( data ).i! )
    return d
}

/// データオブジェクトのCポインタを取得
/// - Parameter data: 対象のデータオブジェクト
/// - Returns: データの先頭ポインタ(データが0のとき = nil)
public func LCDataPointer( _ data:LCDataSmPtr ) -> LLUInt8Ptr {
    // 下駄分より下回っていたら無しと捉える
    if data.dt.count <= LCDataOffsetByte { return nil }

    guard let ptr:UnsafeMutableRawPointer = data.dt.withUnsafeMutableBytes( { $0.baseAddress } ) else {
        LLLogWarning( "LCDataのポインタを取得できませんでした." )
        return nil
    }
    
    // ポインタは先頭に下駄があるので、下駄分ずらしたポインタを返す
    return ptr.assumingMemoryBound(to: LLUInt8.self ).advanced( by: LCDataOffsetByte )
}

/// データオブジェクトのバイト数を取得
/// - Parameter data: 対象のデータオブジェクト
/// - Returns: データの長さ(バイト)
public func LCDataLength( _ data:LCDataSmPtr ) -> LLInt64 {
    // 下駄分を差し引く
    return LLInt64( max( 0, data.dt.count - LCDataOffsetByte ) )
}

/// データオブジェクトの最後尾にデータを追加する
/// - Parameters:
///   - data: 対象のデータオブジェクト
///   - src: 追加するデータオブジェクト
public func LCDataAppend( _ data:LCDataSmPtr, _ src:LCDataSmPtr ) {
    data.dt.append( src.data )
}

/// データオブジェクトの最後尾にデータを追加する
/// - Parameters:
///   - data: 対象のデータオブジェクト
///   - bin: 追加するデータの先頭ポインタ
///   - length: 追加する長さ(バイト)
public func LCDataAppendBytes( _ data:LCDataSmPtr, _ bin:LLUInt8Ptr, _ length:LLInt64 ) {
    guard let ptr = bin else {
        LLLogWarning( "LCDataのポインタを取得できませんでした." )
        return
    }
    guard let leng:Int = length.i else { return }
    
    data.dt.append( ptr, count: leng )
}

/// データオブジェクトの最後尾に文字データを追加する
/// - Parameters:
///   - data: 対象のデータオブジェクト
///   - chars: 追加する文字列データの先頭ポインタ
public func LCDataAppendChars( _ data:LCDataSmPtr, _ chars:LLConstCCharsPtr ) {
    let optr:OpaquePointer = OpaquePointer( chars )
    let uint8_ptr:LLNonNullUInt8Ptr = LLNonNullUInt8Ptr( optr )
    let length:Int = strlen( chars )
    data.dt.append( uint8_ptr, count: length )
}

/// データオブジェクトの中身を空にする
/// - Parameters:
///   - data: 対象のデータオブジェクト
public func LCDataClear( _ data:LCDataSmPtr ) {
    data.dt.removeAll()
}
