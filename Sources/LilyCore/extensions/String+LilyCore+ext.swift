//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation

#if os(macOS)
import AppKit
#else
import UIKit
#endif

public extension String 
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
        
    /// URLに変換し取得する(ファイルパス形式)
    var fileUrl:URL { 
        return URL( fileURLWithPath: self )
    }
    
    /// URLに変換し取得する(https://...) 
    var url:URL? { 
        return URL( string:self )
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
    
    
    func pixelSize( attr textAttr:LCTextAttributeSmPtr ) -> LLSize { 
        return LCStringPixelSize( self.lcStr, textAttr )
    }
}
