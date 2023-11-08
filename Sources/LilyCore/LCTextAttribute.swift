//
//  LCTextAttribute.swift
//  LilySwift
//
//  Created by Kengo on 2020/01/17.
//  Copyright © 2020 Watanabe-DENKI, Inc.. All rights reserved.
//

import Foundation

/// フォントの太さ列挙子
public enum LLFontWeight : Int
{
    case thin   = 100  /// 細い
    case normal = 300  /// 標準
    case bold   = 600  /// 太い
    case heavy  = 900  /// 極太
}

fileprivate struct LCTextAttributeInternal
{
    var face:LCStringSmPtr = LCStringZero() /// フォント名(フォントファミリー)
    var size:LLInt32 = 0                    /// フォントサイズ
    var color:LLColor = LLColor_Black       /// テキスト色
    var weight:LLFontWeight = .normal       /// フォントの太さ
}

/// テキスト属性モジュール
public class LCTextAttributeSmPtr
{
    /// 内部オブジェクト
    fileprivate var attr:LCTextAttributeInternal
    
    /// ファイルパスで初期化
    /// - Parameter path: 対象のファイルパス
    fileprivate init() {
        attr = LCTextAttributeInternal()
    }
}


public func LCTextAttributeMake( _ face_:LCStringSmPtr, _ size_:LLInt32, _ color_:LLColor, _ weight_:LLFontWeight )
-> LCTextAttributeSmPtr {
    let a = LCTextAttributeSmPtr()
    a.attr.face = LCStringMake( face_ )
    a.attr.size = size_
    a.attr.color = color_
    a.attr.weight = weight_
    return a
}

public func LCTextAttributeMakeDefault() -> LCTextAttributeSmPtr {
    return LCTextAttributeMake(
        LCStringMakeWithCChars( "HiraKakuProN-W3" ), 
        13, 
        LLColorMake( 0.0, 0.0, 0.0, 1.0 ),
        .normal )
}

public func LCTextAttributeMakeWithFont( _ src_attr_:LCTextAttributeSmPtr ) -> LCTextAttributeSmPtr {
    let a = LCTextAttributeSmPtr()
    a.attr.face = LCStringMake( src_attr_.attr.face )
    a.attr.size = src_attr_.attr.size
    a.attr.color = src_attr_.attr.color
    a.attr.weight = src_attr_.attr.weight
    return a
}

public func LCTextAttributeFace( _ attr_:LCTextAttributeSmPtr ) -> LCStringSmPtr {
    return LCStringMake( attr_.attr.face )
}

public func LCTextAttributeSize( _ attr_:LCTextAttributeSmPtr ) -> LLInt32 {
    return attr_.attr.size
}

public func LCTextAttributeColor( _ attr_:LCTextAttributeSmPtr ) -> LLColor {
    return attr_.attr.color
}

public func LCTextAttributeWeight( _ attr_:LCTextAttributeSmPtr ) -> LLFontWeight {
    return attr_.attr.weight
}
