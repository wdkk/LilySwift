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

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// LilyCore文字列モジュール
public class LCStringSmPtr
{
    /// 内部オブジェクト(SwiftのStringを使用)
    var s = String()
    
    fileprivate init() {}
}

/// LilyCore文字列配列モジュール
public class LCStringArraySmPtr
{
    /// 内部オブジェクト(LCStringSmPtrのSwift配列型)
    fileprivate var strings = [LCStringSmPtr]()
    
    fileprivate init() {}
}

/// 空のLilyCore文字列を作成
/// - Returns: 空のLilyCore文字列
public func LCStringZero() -> LCStringSmPtr {
    return LCStringSmPtr()
}

/// LilyCore文字列からLilyCore文字列を作成
/// - Parameter cstr: 元の文字列
/// - Returns: cstrと同内容のLilyCore文字列
public func LCStringMake( _ cstr:LCStringSmPtr ) -> LCStringSmPtr {
    let cptr = cstr.s.cChar
    return LCStringMakeWithCChars( cptr )
}

/// C文字列からLilyCore文字列を作成
/// - Parameter text: C言語文字列
/// - Returns: C言語文字列と同内容のLilyCore文字列
/// - Description: ヌル文字までを文字列として認識する
public func LCStringMakeWithCChars( _ text:LLConstCCharsPtr ) -> LCStringSmPtr {
    let cstr = LCStringSmPtr()
    cstr.s = String( cString: text )
    return cstr
}

/// Char型からLilyCore文字列を作成
/// - Parameter chr: Char型(1文字)
/// - Returns: 1文字のLilyCore文字列
public func LCStringMakeWithChar( _ chr:LLInt8 ) -> LCStringSmPtr {
    let cstr = LCStringSmPtr()
    cstr.s = String( cString: [chr] )
    return cstr
}

/// Cバイト列からLilyCore文字列を作成
/// - Parameters:
///   - bin: C言語バイト列
///   - length: 長さ(バイト)
/// - Returns: C言語バイト列を文字で認識したLilyCore文字列 (失敗した場合 = 長さ0の文字列オブジェクト)
/// - Description: ヌル文字がない場合に適用するバイト列と長さを指定して文字列として認識する
public func LCStringMakeWithBytes( _ bin:LLUInt8Ptr, _ length:Int ) -> LCStringSmPtr {
    let cstr = LCStringSmPtr()
    guard let nonnull_bin = bin else { return cstr }
    
    let data = Data( bytes: nonnull_bin, count: length )
    
    // 文字列変換の試行
    guard let str = String( data: data, encoding: .utf8 ) else { return cstr }
    // うまくいった場合LCStringSmPtrに代入して返す
    cstr.s = str
    return cstr
}

/// LilyCore文字列配列を作成
/// - Returns: LilyCore文字列配列(要素数0)
public func LCStringArrayMake() -> LCStringArraySmPtr {
    return LCStringArraySmPtr()
}

/// LilyCore文字列が同じ文字であるかを返す
/// - Parameters:
///   - str1: LilyCore文字列1
///   - str2: LilyCore文字列2
/// - Returns: true = 同じ文字列, false = 異なる文字列
public func LCStringIsEqual( _ str1:LCStringSmPtr, _ str2:LCStringSmPtr ) -> Bool {
    return ( str1.s == str2.s )
}

/// LilyCore文字列の順序を比較する(バイトコードの昇順)
/// - Parameters:
///   - str1: LilyCore文字列1
///   - str2: LilyCore文字列2
/// - Returns: true = str1 < str2
public func LCStringCompare( _ str1:LCStringSmPtr, _ str2:LCStringSmPtr ) -> Bool {
    return ( str1.s < str2.s )
}

/// LilyCore文字列が空を確認
/// - Parameter cstr: 対象文字列
/// - Returns: true = 空文字, false = 文字あり
public func LCStringIsEmpty( _ cstr:LCStringSmPtr ) -> Bool {
    return cstr.s.isEmpty
}

/// LilyCore文字列の長さを取得
/// - Parameter cstr: 対象文字列
/// - Returns: 文字列の長さ
public func LCStringCount( _ cstr:LCStringSmPtr ) -> Int {
    return cstr.s.count
}

/// LilyCore文字列のバイト長を取得
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 文字列の長さ(バイト)
public func LCStringByteLength( _ cstr:LCStringSmPtr ) -> Int {
    return LLCharByteLength( LCStringToCChars( cstr ) )
}

/// LilyCore文字列のCChar配列を取得
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: CChar配列(ポインタではなく別の実体として返す)
public func LCStringToCChars( _ cstr:LCStringSmPtr ) -> LLCChars {
    guard let cchar = cstr.s.cString(using: .utf8 ) else { return [CChar]() }
    return cchar
}

/// LLInt8へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 8ビット整数型, 変換失敗時 = 0
public func LCStringToI8( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLInt8 {
    guard let v = LLInt8( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "int8に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLInt16へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 16ビット整数型, 変換失敗時 = 0
public func LCStringToI16( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLInt16 {
    guard let v = LLInt16( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "int16に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLInt32へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 32ビット整数型, 変換失敗時 = 0
public func LCStringToI32( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLInt32 {
    guard let v = LLInt32( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "int32に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLInt64へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 64ビット整数型, 変換失敗時 = 0
public func LCStringToI64( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLInt64 {
    guard let v = LLInt64( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "int64に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// Intへ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 整数型, 変換失敗時 = 0
public func LCStringToI( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> Int {
    guard let v = Int( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "intに変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLUInt8へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 8ビット符号無し整数型, 変換失敗時 = 0
public func LCStringToU8( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLUInt8 {
    guard let v = LLUInt8( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "uint8に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLUInt16へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 16ビット符号無し整数型, 変換失敗時 = 0
public func LCStringToU16( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLUInt16 {
    guard let v = LLUInt16( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "uint16に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLUInt32へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 32ビット符号無し整数型, 変換失敗時 = 0
public func LCStringToU32( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLUInt32 {
    guard let v = LLUInt32( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "uint32に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// LLUInt64へ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 64ビット符号無し整数型, 変換失敗時 = 0
public func LCStringToU64( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLUInt64 {
    guard let v = LLUInt64( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "uint64に変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// UIntへ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: 符号無し整数型, 変換失敗時 = 0
public func LCStringToU( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> UInt {
    guard let v = UInt( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "uintに変換できませんでした." ) }
        return 0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// Floatへ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: Float型, 変換失敗時 = 0.0
public func LCStringToF( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLFloat {
    guard let v = LLFloat( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "floatに変換できませんでした." ) }
        return 0.0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// Doubleへ変換
/// - Parameter cstr: 対象LilyCore文字列
/// - Returns: Double型, 変換失敗時 = 0
public func LCStringToD( _ cstr:LCStringSmPtr, _ err:LLErrorSmPtr? ) -> LLDouble {
    guard let v = LLDouble( cstr.s ) else {
        if err != nil { LLErrorSet( err!, 1, "doubleに変換できませんでした." ) }
        return 0.0
    }
    if err != nil { LLErrorNone( err! ) }
    return v
}

/// 文字列を検索する
/// - Parameters:
///   - cstr: 対象LilyCore文字列
///   - pos: 検索開始位置(バイト数)
///   - key: 検索するキーワード文字列
/// - Returns: はじめに発見位置のバイト数, 見つからない時 = -1
public func LCStringFind( _ cstr:LCStringSmPtr, _ pos:Int, _ key:LCStringSmPtr ) -> Int {
    if pos >= LCStringByteLength( cstr ) { return -1 }
    if LCStringByteLength( key ) < 1 { return -1 }
    
    let str = LCStringSubString( cstr, pos, LCStringByteLength( cstr ) )
    let str_key = String( key )
    // String.Indexのrangeを受け取り、nilならば-1を返す. そうでない場合はlowerBound.utf16Offsetで位置を返す
    guard let index = str.s.range( of: str_key ) else { return -1 }
    return index.lowerBound.utf16Offset( in: "" ) + pos
}

/// 文字列を後方から検索する
/// - Parameters:
///   - cstr: 対象LilyCore文字列
///   - key: 検索するキーワード文字列
/// - Returns: 発見位置の(先頭からの)バイト数, 見つからない時 = -1
public func LCStringFindReverse( _ cstr:LCStringSmPtr, _ key:LCStringSmPtr ) -> Int {
    var fpos:Int = 0
    var pos:Int = 0
    var last_pos:Int = -1
    let key_len = LCStringByteLength( key )
    
    if key_len < 1 { return -1 }
    
    while true {
        fpos = LCStringFind( cstr, pos, key )
        if fpos == -1 { break }
        
        last_pos = fpos
        pos = fpos + key_len
    }
    return last_pos
}

/// 文字列を後方から検索する
/// - Parameters:
///   - cstr: 対象LilyCore文字列
///   - key: 検索したいキーワードC文字列
/// - Returns: 発見位置の(先頭からの)バイト数, 見つからない時 = -1
public func LCStringFindReverseWithCChars( _ cstr:LCStringSmPtr, _ key:LLConstCCharsPtr ) -> Int {
    return LCStringFindReverse( cstr, LCStringMakeWithCChars( key ) )
}

/// 文字列の上書き
/// - Parameters:
///   - dst: 上書きを受ける文字列
///   - src: 元にする文字列
public func LCStringRewrite( _ dst:LCStringSmPtr, _ src:LCStringSmPtr ) {
    dst.s = src.s
}

/// 文字列の追加
/// - Parameters:
///   - dst: 追加を受ける文字列
///   - src: 追加する文字列
public func LCStringAppend( _ dst:LCStringSmPtr, _ src:LCStringSmPtr ) {
    dst.s.append( src.s )
}

/// 文字列の挿入
/// - Parameters:
///   - dst: 挿入を受ける文字列
///   - src: 挿入する文字列
///   - pos: 挿入位置
public func LCStringInsert( _ dst:LCStringSmPtr, _ src:LCStringSmPtr, _ pos:Int ) {
    dst.s.insert( contentsOf: src.s, at: dst.s.index(dst.s.startIndex, offsetBy: pos) )
}

/// 文字列を空にする
/// - Parameter dst: 対象文字列
public func LCStringClear( _ dst:LCStringSmPtr ) {
    dst.s.removeAll()
}

/// 文字列を連結する
/// - Parameters:
///   - s1: 文字列1
///   - s2: 文字列2
/// - Returns: s1 + s2の結果文字列
public func LCStringJoin( _ s1:LCStringSmPtr, _ s2:LCStringSmPtr ) -> LCStringSmPtr {
    let s = s1.s + s2.s
    return LCStringMakeWithCChars( s.cChar )
}

/// 文字列を切り出した部分文字列を返す
/// - Parameters:
///   - src: 切り出し対象の文字列
///   - start_pos: 切り出し開始位置
///   - length: 切り出し長さ
/// - Returns: 切り出された文字列
public func LCStringSubString( _ src:LCStringSmPtr, _ start_pos:Int, _ length:Int ) -> LCStringSmPtr {
    let start_pos = LLMax( 0, start_pos )
    let src_length = LCStringByteLength( src )
    let leng = LLMin( src_length - start_pos, length )
    if start_pos > src_length { return LCStringZero() }
    if leng < 1 { return LCStringZero() }
    
    let chars = LCStringToCChars( src )
    var sub_chars = [CChar]()
    let s = start_pos
    let e = min( src_length, s + leng )
    
    // CChar配列で1バイトずつ必要部分をコピー
    for i in s ..< e { sub_chars.append( chars[i] ) }
    // ヌル文字=0を挿入
    sub_chars.append( 0 )
    
    return LCStringMakeWithCChars( sub_chars )
}

/// 文字列内の特定文字列を新しい文字列に置き換えた文字列を返す
/// - Parameters:
///   - src: 対象の文字列
///   - old_word: 置き換え前のワード
///   - new_word: 置き換え後のワード
/// - Returns: 置き換えた文字列
public func LCStringReplace( _ src:LCStringSmPtr, _ old_word:LCStringSmPtr, _ new_word:LCStringSmPtr ) 
-> LCStringSmPtr {
    let tmp = LCStringMake( src )
    let len_old = LCStringByteLength( old_word )
    let len_new = LCStringByteLength( new_word )
    var n:Int = 0
    
    while true {
        let tmp_str = LCStringMake( tmp )
        
        n = LCStringFind( tmp_str, n, old_word )
        if n == -1 { break }
        
        let s1 = LCStringSubString( tmp_str, 0, n )
        let s2 = LCStringSubString( tmp_str, n+len_old, LCStringByteLength( tmp_str ) )
        
        tmp.s = s1.s + new_word.s + s2.s
        n += len_new
    }
    
    return tmp
}

/// 文字列を特定の文字を区切りに分割する
/// - Parameters:
///   - src_: 対象の文字列
///   - separator_: 区切り文字
/// - Returns: 分割した文字列配列
/// - Description: ex: "a,bb,ccc,dddd"について","をセパレータにすると,["a", "bb", "ccc", "dddd"]が得られる
public func LCStringSplit( _ src_:LCStringSmPtr, _ separator_:LCStringSmPtr ) -> LCStringArraySmPtr {
    let cstr_array = LCStringArrayMake()

    var start:Int = 0
    let end:Int = src_.s.count
    var pos:Int = 0
    let seplen = separator_.s.count

    while true {
        pos = LCStringFind( src_, start, separator_ )
        if pos == -1 { break }
        
        let s = LCStringSubString( src_, start, pos-start )
        LCStringArrayAppend( cstr_array, s )
        
        start = pos + seplen
    }
    
    let s = LCStringSubString( src_, start, end )
    LCStringArrayAppend( cstr_array, s )
    
    return cstr_array
}

/// src文字列を小文字に変換して返す
/// - Parameters:
///   - src_: 対象の文字列
/// - Returns: 小文字変換した文字列
public func LCStringLowercased( _ src_:LCStringSmPtr ) -> LCStringSmPtr {
    let dst = LCStringZero()
    dst.s = src_.s.lowercased()
    return dst
}

/// src文字列を大文字に変換して返す
/// - Parameters:
///   - src_: 対象の文字列
/// - Returns: 大文字変換した文字列
public func LCStringUppercased( _ src_:LCStringSmPtr ) -> LCStringSmPtr {
    let dst = LCStringZero()
    dst.s = src_.s.uppercased()
    return dst
}

/// src文字列を大文字に変換して返す
/// - Parameters:
///   - src_: 対象の文字列
/// - Returns: 大文字変換した文字列
public func LCStringPixelSize( _ src_:LCStringSmPtr, _ attr_:LCTextAttributeSmPtr ) -> LLSize {
    let family = String( LCTextAttributeFace( attr_ ) )
    let str = LLString( src_ )

    #if os(iOS) 
    let f = UIFont(name: family, size: LCTextAttributeSize( attr_ ).cgf )
    #else
    let f = NSFont(name: family, size: LCTextAttributeSize( attr_ ).cgf )
    #endif
    let attributes:[NSAttributedString.Key: Any] = [.font: f as Any] 

    // MEMO: Swift.StringのsizeではNSString.boundingRectと縦幅が変わるためNSStringを用いる
    //let sz = str.size( withAttributes: attributes )
    let ns_str = NSString( string: str )
    let sz = ns_str.boundingRect(with: CGSize( 99999999, 99999999 ), 
                                 options: [.usesLineFragmentOrigin ,.usesFontLeading],
                                 attributes: attributes, 
                                 context: nil )
    
    let scale = LCSystemGetRetinaScale()
    
    return LLSize( ceil( sz.width ) * scale.cgf, ceil( sz.height ) * scale.cgf )
}

/// LilyCore文字列配列へのアクセサ
/// - Parameters:
///   - cstra: LilyCore文字列配列
///   - index: アクセス番号
/// - Returns: LilyCore文字列
public func LCStringArrayAt( _ cstra:LCStringArraySmPtr, _ index:Int ) -> LCStringSmPtr {
    return cstra.strings[index]
}

/// LilyCore文字列配列の要素数を返す
/// - Parameter cstra: LilyCore文字列配列
/// - Returns: 要素数
public func LCStringArrayCount( _ cstra:LCStringArraySmPtr ) -> Int {
    return cstra.strings.count
}

/// LilyCore文字列配列に要素を追加する
/// - Parameters:
///   - cstra: LilyCore文字列配列
///   - cstr: 追加するLilyCore文字列
public func LCStringArrayAppend( _ cstra:LCStringArraySmPtr, _ cstr:LCStringSmPtr ) {
    cstra.strings.append( LCStringMake( cstr ) )
}

/// LilyCore文字列配列に要素を追加する
/// - Parameters:
///   - cstra: LilyCore文字列配列
///   - cstr: 追加するC文字列(追加後はLilyCore文字列として格納される)
public func LCStringArrayAppendChars( _ cstra:LCStringArraySmPtr, _ cstr:LLConstCharPtr ) {
    guard let nonnull_cstr = cstr else { return }
    cstra.strings.append( LCStringMakeWithCChars( nonnull_cstr ) )
}

/// LilyCore文字列配列の要素を削除する
/// - Parameters:
///   - cstra: LilyCore文字列配列
///   - index: 削除するインデクス番号
public func LCStringArrayRemove( _ cstra:LCStringArraySmPtr, _ index:Int ) {
    if index >= LCStringArrayCount( cstra ) { return }
    cstra.strings.remove( at: index )
}
