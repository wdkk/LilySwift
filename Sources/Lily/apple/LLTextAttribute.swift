//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation

/// テキスト属性モジュール
public class LLTextAttribute
{
    /// LilyCoreオブジェクト
    private(set) var lcAttr:LCTextAttributeSmPtr
    
    /// テキスト属性オブジェクトを作成
    /// - Parameters:
    ///   - face: フォント名
    ///   - size: フォントサイズ
    ///   - color: 文字の色
    ///   - weight: フォント太さ
    /// - Returns: テキスト属性オブジェクト
    public init( face:LLString, size:Int, color:LLColor, weight:LLFontWeight ) {
        lcAttr = LCTextAttributeMake( face.lcStr, size.i32!, color, weight )
    }
    
    /// テキスト属性オブジェクトを作成
    /// - Parameters:
    ///   - lcAttr: LilyCoreテキスト属性オブジェクト
    /// - Returns: テキスト属性オブジェクト
    public convenience init( lcAttr attr:LCTextAttributeSmPtr ) {
        self.init( face:LLString( LCTextAttributeFace( attr ) ), 
                   size:LCTextAttributeSize( attr ).i,
                   color:LCTextAttributeColor( attr ),
                   weight:LCTextAttributeWeight( attr ) )
    }
    
    /// テキスト属性のデフォルトオブジェクトを返す
    /// - Returns: 標準のテキスト属性オブジェクト
    public static var `default`:LLTextAttribute { return LLTextAttribute( lcAttr: LCTextAttributeMakeDefault() ) }
    
    public var face:LLString { 
        return LLString( LCTextAttributeFace( lcAttr ) )
    }
    
    public var size:Int { 
        return LCTextAttributeSize( lcAttr ).i
    }
    
    public var color:LLColor { 
        return LCTextAttributeColor( lcAttr )
    }
    
    public var weight:LLFontWeight { 
        return LCTextAttributeWeight( lcAttr )
    }
}

