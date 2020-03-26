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

/// 8bit整数
public typealias LLInt8 = Int8
/// 16bit整数
public typealias LLInt16 = Int16
/// 32bit整数
public typealias LLInt32 = Int32
/// 64bit整数
public typealias LLInt64 = Int64
/// 8bit符号無し整数
public typealias LLUInt8 = UInt8
/// 16bit符号無し整数
public typealias LLUInt16 = UInt16
/// 32bit符号無し整数
public typealias LLUInt32 = UInt32
/// 64bit符号無し整数
public typealias LLUInt64 = UInt64
/// 単精度浮動小数点
public typealias LLFloat = Float
/// 倍精度浮動小数点
public typealias LLDouble = Double

// ポインタ型

/// voidポインタ型
public typealias LLVoidPtr = UnsafeMutableRawPointer?
/// Nullなしvoidポインタ型
public typealias LLNonNullVoidPtr = UnsafeMutableRawPointer
/// Nullなしvoidダブルポインタ型
public typealias LLVoidMatrix = UnsafeMutablePointer<LLNonNullVoidPtr>

/// charポインタ型
public typealias LLCharPtr = UnsafeMutablePointer<Int8>?
/// Nullなしcharポインタ型
public typealias LLNonNullCharPtr = UnsafeMutablePointer<Int8>
/// const charポインタ型
public typealias LLConstCharPtr = UnsafePointer<Int8>?
/// Nullなし const charポインタ型
public typealias LLNonNullConstCharPtr = UnsafePointer<Int8>
/// CChar配列
public typealias LLCChars = [CChar]
/// CChar配列
public typealias LLConstCCharsPtr = UnsafePointer<CChar>
/// プレーンなバイト列を扱うポインタ型(主にキャストして用いる)
public typealias LLBytePtr = UnsafeMutablePointer<UInt8>

/// 8bit符号無し整数ポインタ型
public typealias LLUInt8Ptr = UnsafeMutablePointer<UInt8>?
/// 16bit符号無し整数ポインタ型
public typealias LLUInt16Ptr = UnsafeMutablePointer<UInt16>?
/// 32bit符号無し整数ポインタ型
public typealias LLUInt32Ptr = UnsafeMutablePointer<UInt32>?
/// 64bit符号無し整数ポインタ型
public typealias LLUInt64Ptr = UnsafeMutablePointer<UInt64>?
/// 8bitNull無し符号無し整数ポインタ型
public typealias LLNonNullUInt8Ptr = UnsafeMutablePointer<UInt8>
/// 16bitNull無し符号無し整数ポインタ型
public typealias LLNonNullUInt16Ptr = UnsafeMutablePointer<UInt16>
/// 32bitNull無し符号無し整数ポインタ型
public typealias LLNonNullUInt32Ptr = UnsafeMutablePointer<UInt32>
/// 64bitNull無し符号無し整数ポインタ型
public typealias LLNonNullUInt64Ptr = UnsafeMutablePointer<UInt64>
/// 8bitNull無し符号無し整数ダブルポインタ型
public typealias LLUInt8Matrix = UnsafeMutablePointer<LLNonNullUInt8Ptr>

/// 16bitNull無し符号無し整数ダブルポインタ型
public typealias LLUInt16Matrix = UnsafeMutablePointer<LLNonNullUInt16Ptr>
/// 32bitNull無し符号無し整数ダブルポインタ型
public typealias LLUInt32Matrix = UnsafeMutablePointer<LLNonNullUInt32Ptr>
/// 64bitNull無し符号無し整数ダブルポインタ型
public typealias LLUInt64Matrix = UnsafeMutablePointer<LLNonNullUInt64Ptr>

/// 8bit整数ポインタ型
public typealias LLInt8Ptr = UnsafeMutablePointer<Int8>?
/// 16bit整数ポインタ型
public typealias LLInt16Ptr = UnsafeMutablePointer<Int16>?
/// 32bit整数ポインタ型
public typealias LLInt32Ptr = UnsafeMutablePointer<Int32>?
/// 64bit整数ポインタ型
public typealias LLInt64Ptr = UnsafeMutablePointer<Int64>?
/// 8bitNullなし整数ポインタ型
public typealias LLNonNullInt8Ptr = UnsafeMutablePointer<Int8>
/// 16bitNullなし整数ポインタ型
public typealias LLNonNullInt16Ptr = UnsafeMutablePointer<Int16>
/// 32bitNullなし整数ポインタ型
public typealias LLNonNullInt32Ptr = UnsafeMutablePointer<Int32>
/// 64bitNullなし整数ポインタ型
public typealias LLNonNullInt64Ptr = UnsafeMutablePointer<Int64>
/// 8bitNullなし整数ダブルポインタ型
public typealias LLInt8Matrix = UnsafeMutablePointer<LLNonNullInt8Ptr>
/// 16bitNullなし整数ダブルポインタ型
public typealias LLInt16Matrix = UnsafeMutablePointer<LLNonNullInt16Ptr>
/// 32bitNullなし整数ダブルポインタ型
public typealias LLInt32Matrix = UnsafeMutablePointer<LLNonNullInt32Ptr>
/// 64bitNullなし整数ダブルポインタ型
public typealias LLInt64Matrix = UnsafeMutablePointer<LLNonNullInt64Ptr>

/// 単精度浮動小数ポインタ型
public typealias LLFloatPtr = UnsafeMutablePointer<Float>?
/// 倍精度浮動小数ポインタ型
public typealias LLDoublePtr = UnsafeMutablePointer<Double>?
/// Nullなし単精度浮動小数ポインタ型
public typealias LLNonNullFloatPtr = UnsafeMutablePointer<Float>
/// Nullなし倍精度浮動小数ポインタ型
public typealias LLNonNullDoublePtr = UnsafeMutablePointer<Double>
/// Nullなし単精度浮動小数ダブルポインタ型
public typealias LLFloatMatrix = UnsafeMutablePointer<LLNonNullFloatPtr>
/// Nullなし倍精度浮動小数ダブルポインタ型
public typealias LLDoubleMatrix = UnsafeMutablePointer<LLNonNullDoublePtr>

/// 2次座標構造体( x, y )
public struct LLPoint {
    public var x:Double
    public var y:Double
}

/// 2次整数座標構造体( x, y )
public struct LLPointInt { 
    public var x:Int
    public var y:Int
}

/// 2次座標構造体( x, y )
public struct LLPointFloat {
    public var x:Float
    public var y:Float
}

/// 3次座標構造体( x, y, z )
public struct LLCoord {
    public var x:Double
    public var y:Double
    public var z:Double
}

/// 2次サイズ構造体( width, height )
public struct LLSize {
    public var width:Double
    public var height:Double
}

/// 2次整数サイズ構造体( width, height )
public struct LLSizeInt {
    public var width:Int
    public var height:Int
}

/// 2次サイズ構造体( width, height )
public struct LLSizeFloat {
    public var width:Float
    public var height:Float
}

/// 矩形構造体( x, y, width, height )
public struct LLRect { 
    public var x:Double
    public var y:Double
    public var width:Double
    public var height:Double
}

/// 2次アフィン係数構造体( a, b, c, d, e, f )
public struct LL2DAffine { 
    public var a:Double
    public var b:Double
    public var c:Double
    public var d:Double
    public var e:Double
    public var f:Double
}

/// 2次アフィン整数係数構造体( a, b, c, d, e, f )
public struct LL2DAffineInt { 
    public var a:Int
    public var b:Int
    public var c:Int
    public var d:Int
    public var e:Int
    public var f:Int
}

/// 範囲構造体( s ~ e )
public struct LLRange {
    public var s:Int
    public var e:Int
}

/// 領域構造体( left, top, right, bottom )
public struct LLRegion { 
    public var left:Double
    public var top:Double
    public var right:Double
    public var bottom:Double
}
