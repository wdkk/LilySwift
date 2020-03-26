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

/// LLPointを(0,0)で作成
public func LLPointZero() -> LLPoint {
    return LLPoint( x:0.0, y:0.0 )
}

/// LLPointを(x,y)座標で作成
/// - Parameters:
///   - x: x座標
///   - y: y座標
/// - Returns: 座標情報
public func LLPointMake( _ x:Double, _ y:Double ) -> LLPoint {
    return LLPoint( x:x, y:y )
}

/// LLPointIntを(0,0)で作成
public func LLPointIntZero() -> LLPointInt {
    return LLPointInt( x:0, y:0 )
}

/// LLPointIntを(x,y)座標で作成
/// - Parameters:
///   - x: x座標
///   - y: y座標
/// - Returns: 整数座標情報
public func LLPointIntMake( _ x:Int, _ y:Int ) -> LLPointInt {
    return LLPointInt( x:x, y:y )
}

/// LLPointFloatを(0,0)で作成
public func LLPointFloatZero() -> LLPointFloat {
    return LLPointFloat( x:0.0, y:0.0 )
}

/// LLPointFloatを(x,y)座標で作成
/// - Parameters:
///   - x: x座標
///   - y: y座標
/// - Returns: 座標情報
public func LLPointFloatMake( _ x:Float, _ y:Float ) -> LLPointFloat {
    return LLPointFloat( x:x, y:y )
}


/// LLCoord(3次元座標構造体)を(0,0,0)で作成
public func LLCoordZero() -> LLCoord {
    return LLCoord( x: 0.0, y: 0.0, z: 0.0 )
}

/// LLCoord(3次元座標構造体)を(x,y,)座標で作成
/// - Parameters:
///   - x: x座標
///   - y: y座標
///   - z: z座標
/// - Returns: 3次座標情報
public func LLCoordMake( _ x:Double, _ y:Double, _ z:Double ) -> LLCoord {
    return LLCoord( x:x, y:y, z:z )
}

/// LLSize(サイズ構造体)をサイズゼロで作成
public func LLSizeZero() -> LLSize {
    return LLSize( width: 0.0, height: 0.0 )
}

/// LLSize(サイズ構造体)を(width, height)で作成
/// - Parameters:
///   - width: 横幅
///   - height: 高さ
/// - Returns: サイズ情報
public func LLSizeMake( _ width:Double, _ height:Double ) -> LLSize {
    return LLSize( width: width, height: height )
}

/// LLSizeInt(サイズ構造体)をサイズゼロで作成
public func LLSizeIntZero() -> LLSizeInt {
    return LLSizeInt( width: 0, height: 0 )
}

/// LLSizeInt(サイズ構造体)を(width, height)で作成
/// - Parameters:
///   - width: 横幅
///   - height: 高さ
/// - Returns: サイズ情報
public func LLSizeIntMake( _ width:Int, _ height:Int ) -> LLSizeInt {
    return LLSizeInt( width: width, height: height )
}


/// LLSizeFloat(サイズ構造体)をサイズゼロで作成
public func LLSizeFloatZero() -> LLSizeFloat {
    return LLSizeFloat( width: 0.0, height: 0.0 )
}

/// LLSizeFloat(サイズ構造体)を(width, height)で作成
/// - Parameters:
///   - width: 横幅
///   - height: 高さ
/// - Returns: サイズ情報
public func LLSizeFloatMake( _ width:Float, _ height:Float ) -> LLSizeFloat {
    return LLSizeFloat( width: width, height: height )
}


/// LLRect(矩形構造体)を(0,0,0,0)で作成
public func LLRectZero() -> LLRect {
    return LLRect( x:0, y:0, width:0, height:0 )
}

/// LLRect(矩形構造体)を(x,y,width,height)で作成
/// - Parameters:
///   - x: x座標
///   - y: y座標
///   - width: 横幅
///   - height: 高さ
/// - Returns: 矩形情報
public func LLRectMake( _ x:Double, _ y:Double, _ width:Double, _ height:Double ) -> LLRect {
    return LLRect( x:x, y:y, width:width, height:height )
}

/// LLRect(矩形構造体)を拡張/収縮
/// - Parameters:
///   - rc: 元となる矩形情報
///   - val: 上下左右に拡張する値
/// - Returns: 拡張/収縮後の矩形情報
public func LLRectInset( _ rc:LLRect, _ val:Double ) -> LLRect {
    return LLRect( x: rc.x + val, 
                   y: rc.y + val,
                   width: rc.width - val * 2.0,
                   height: rc.height - val * 2.0 )
}

/// LLRegion(領域構造体)を(0,0,0,0)で作成
public func LLRegionZero() -> LLRegion {
    return LLRegion( left: 0.0, top: 0.0, right: 0.0, bottom: 0.0 )
}

/// LLRegion(領域構造体)を(left, top, right, bottom)で作成
/// - Parameters:
///   - left: 左端座標
///   - top: 上端座標
///   - right: 右端座標
///   - bottom: 下端座標
/// - Returns: 指定した領域構造体
public func LLRegionMake( _ left:Double, _ top:Double, _ right:Double, _ bottom:Double ) -> LLRegion {
    return LLRegion( left: left, top: top, right: right, bottom: bottom )    
}

/// reg1とreg2の領域の論理積
/// - Parameters:
///   - reg1: 対象領域1
///   - reg2: 対象領域2
/// - Returns: 二つの領域のAND領域
public func LLRegionAnd( _ reg1:LLRegion, _ reg2:LLRegion ) -> LLRegion {
    return LLRegion( left: LLMax( reg1.left, reg2.left ),
                     top: LLMax( reg1.top, reg2.top ),
                     right: LLMin( reg1.right, reg2.right ),
                     bottom: LLMin( reg1.bottom, reg2.bottom ) )
}

/// reg1とreg2の領域の論理和
/// - Parameters:
///   - reg1: 対象領域1
///   - reg2: 対象領域2
/// - Returns: 二つの領域のOR領域
public func LLRegionOr( _ reg1:LLRegion, _ reg2:LLRegion ) -> LLRegion {
    return LLRegion( left: LLMin( reg1.left, reg2.left ),
                     top: LLMin( reg1.top, reg2.top ),
                     right: LLMax( reg1.right, reg2.right ),
                     bottom: LLMax( reg1.bottom, reg2.bottom ) )
}

/// 領域を拡張
/// - Parameters:
///   - reg: 元領域情報
///   - ex_val: 上下左右に拡張する大きさ
public func LLRegionExpand( _ reg:LLRegion, _ ex_val:LLDouble ) -> LLRegion {
    return LLRegion( left: reg.left - ex_val,
                     top: reg.top - ex_val,
                     right: reg.right + ex_val,
                     bottom: reg.bottom + ex_val )
}

/// UTF8としての文字数を返す
/// - Parameter str: 対象文字列
/// - Returns: 文字数
public func LLCharUTF8Count( _ str:LLConstCCharsPtr ) -> Int {
    let s = String( cString: str )
    return s.count
}

/// 文字列のバイト数を返す
/// - Parameter str: 対象文字列
/// - Returns: バイト数
public func LLCharByteLength( _ str:LLConstCCharsPtr ) -> Int {
    var cnt:Int = 0
    let null_character:Int8 = 0
    while (str + cnt).pointee != null_character {
        cnt += 1
    }
    return cnt
}
