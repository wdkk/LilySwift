//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import CoreGraphics

/// Lily文字列オブジェクト(= Swift文字列)
public typealias LLString = String

/// Lily文字列オブジェクト拡張
public extension LLString
{    
    /// LilyCore文字列から生成する
    /// - Parameter lcStr: 元文字列
    init( _ lcStr:LCStringSmPtr ) {
        self.init( cString: LCStringToCChars( lcStr ) )
    }
    
    /// Cポインタを返す(UTF8)
    var cChar:[CChar] {
        return self.cString( using: String.Encoding.utf8 )!
    }
    
    /// LilyCore文字列に変換し取得する
    var lcStr:LCStringSmPtr { 
        return LCStringMakeWithCChars( self.cChar )
    }
        
    /// URLに変換し取得する 
    var url:URL { 
        return URL( fileURLWithPath: self )
    }
    
    /// Intへ変換
    var i:Int? { return Int( self ) }   
    /// Int8へ変換
    var i8:Int8? { return Int8( self ) }
    /// Int16へ変換
    var i16:Int16? { return Int16( self ) }
    /// Int32へ変換
    var i32:Int32? { return Int32( self ) }
    /// Int64へ変換
    var i64:Int64? { return Int64( self ) }
    /// UIntへ変換
    var u:UInt? { return UInt( self ) }
    /// UInt8へ変換
    var u8:UInt8? { return UInt8( self ) }
    /// UInt16へ変換
    var u16:UInt16? { return UInt16( self ) }
    /// UInt32へ変換
    var u32:UInt32? { return UInt32( self ) }
    /// UInt64へ変換
    var u64:UInt64? { return UInt64( self ) }
    /// Floatへ変換
    var f:Float? { return Float( self ) }
    /// Doubleへ変換
    var d:Double? { return Double( self ) }
    /// CGFloatへ変換
    var cgf:CGFloat? { return self.d != nil ? CGFloat( self.d! ) : nil }
    
    /// 文字列を前方から検索する
    /// - Parameters:
    ///   - pos: 検索開始位置(バイト)
    ///   - key: 検索する文字列
    /// - Returns: 発見位置(バイト), 見つからなかった場合 = -1
    /// - Description: UTF8のバイト数(ex.アルファベット = 1バイト, 日本語かな,漢字など = 3バイト)
    func find( _ pos:Int, key:LLString ) -> Int {
        return LCStringFind( lcStr, pos, key.lcStr )
    }
    
    /// 文字列を後方から検索する
    /// - Parameters:
    ///   - key: 検索する文字列
    /// - Returns: 発見位置(バイト), 見つからなかった場合 = -1
    /// - Description: UTF8のバイト数(ex.アルファベット = 1バイト, 日本語かな,漢字など = 3バイト)
    func findReverse( _ key:LLString ) -> Int {
        return LCStringFindReverse( lcStr, key.lcStr )
    }
    
    /// 文字列中のold文字列をnew文字列へ置き換える
    /// - Parameters:
    ///   - old: 置き換え前文字列
    ///   - new: 置き換え後文字列
    /// - Returns: 処理後文字列
    func replace( old:LLString, new:LLString ) -> LLString {
        return LLString( LCStringReplace( lcStr, old.lcStr, new.lcStr ) )
    }
    
    /// 文字列を切り出す
    /// - Parameters:
    ///   - start_pos: 切り出し開始位置(バイト)
    ///   - length: 切り出す長さ
    /// - Returns: 切り出した文字列
    /// - Description: 注意: バイト数はUTF8に準ずる.
    func subString( from start_pos:Int, length:Int ) -> LLString {
        return LLString( LCStringSubString( lcStr, start_pos, length ) )
    }
    
    /// 文字列を指定したセパレータで分割する
    /// - Parameter separator: 分割の記号(セパレータ)
    /// - Returns: 分割文字列の配列(セパレータは含まれない)
    func split( _ separator:LLString ) -> [LLString] {
        let arr:LCStringArraySmPtr = LCStringSplit( lcStr, separator.lcStr )
        var strs:[LLString] = []
        for i:Int in 0 ..< LCStringArrayCount( arr ) {
            let s:LLString = LLString( LCStringArrayAt( arr, i ) )
            strs.append( s )
        }
        return strs
    }
}
