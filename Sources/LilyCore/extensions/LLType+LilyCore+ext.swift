//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import CoreGraphics

// SwiftのFixedWidthIntegerの拡張
public extension FixedWidthInteger
{
    /// 数値型のオーバーフローチェック
    static func overflow<T:BinaryInteger>( _ v:T ) -> Bool { return ( v < Self.min || Self.max < v ) }
    /// Float型のオーバーフローチェック
    static func overflow( _ v:Float ) -> Bool { return ( v < Float( Self.min ) || Float( Self.max ) < v ) }
    /// Double型のオーバーフローチェック
    static func overflow( _ v:Double ) -> Bool { return ( v < Double( Self.min ) || Double( Self.max ) < v ) }
    /// CGFloat型のオーバーフローチェック
    static func overflow( _ v:CGFloat ) -> Bool { return ( v < CGFloat( Self.min ) || CGFloat( Self.max ) < v ) }
    /// 数値型のオプショナルキャスト(オーバーフローした場合nilを返す)
    static func optionalCast<T:BinaryInteger>( _ v:T ) -> Self? { return overflow( v ) ? nil : Self( v ) }
    /// Float型のオプショナルキャスト(オーバーフローした場合nilを返す)
    static func optionalCast( _ v:Float ) -> Self? { return overflow( v ) ? nil : Self( v ) }
    /// Double型のオプショナルキャスト(オーバーフローした場合nilを返す)
    static func optionalCast( _ v:Double ) -> Self? { return overflow( v ) ? nil : Self( v ) }
    /// CGFloat型のオプショナルキャスト(オーバーフローした場合nilを返す)
    static func optionalCast( _ v:CGFloat ) -> Self? { return overflow( v ) ? nil : Self( v ) }
}

public protocol LLFloatConvertable
{
    init( _ f:Float )
    init( _ d:Double )
    var f:Float { get }
    var d:Double { get }
    
    static var colorRangeMinValue:Self { get }
    static var colorRangeMaxValue:Self { get }
}

/// Int拡張
extension Int : LLFloatConvertable
{
    public static var colorRangeMinValue:Int { return .min }
    public static var colorRangeMaxValue:Int { return .max }
    
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomi( self ).i }
}

/// Int8拡張
extension Int8 : LLFloatConvertable
{
    public static var colorRangeMinValue:Int8 { return .min }
    public static var colorRangeMaxValue:Int8 { return .max }
    
    /// Intへの変換
    public var i:Int { return Int( self ) }
    /// Int16への変換
    public var i16:Int16 { return Int16( self ) }
    /// Int32への変換
    public var i32:Int32 { return Int32( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomi( self ).i8 ?? 0 }
}

/// Int16拡張
extension Int16 : LLFloatConvertable
{
    public static var colorRangeMinValue:Int16 { return .min }
    public static var colorRangeMaxValue:Int16 { return .max }
    
    /// Intへの変換
    public var i:Int { return Int( self ) }
    /// Int8への変換
    public var i8:Int8? { return Int8.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32 { return Int32( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomi( self ).i16 ?? 0 }
}

/// Int32拡張
extension Int32 : LLFloatConvertable
{
    public static var colorRangeMinValue:Int32 { return .min }
    public static var colorRangeMaxValue:Int32 { return .max }
    
    /// Intへの変換
    public var i:Int { return Int( self ) }
    /// Int8への変換
    public var i8:Int8? { return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomi( self ) }
}

/// Int64拡張
extension Int64 : LLFloatConvertable
{
    public static var colorRangeMinValue:Int64 { return .min }
    public static var colorRangeMaxValue:Int64 { return .max }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }

    // ランダム値
    public var randomize:Self { return LLRandomi( self ).i64 }
}

/// UInt拡張
extension UInt : LLFloatConvertable
{
    public static var colorRangeMinValue:UInt { return .min }
    public static var colorRangeMaxValue:UInt { return .max }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64? { return Int64.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64 { return UInt64( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
}

/// UInt8拡張
extension UInt8 : LLFloatConvertable
{
    public static var colorRangeMinValue:UInt8 { return .min }
    public static var colorRangeMaxValue:UInt8 { return .max }
    
    /// Intへの変換
    public var i:Int { return Int( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16 { return Int16( self ) }
    /// Int32への変換
    public var i32:Int32 { return Int32( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt { return UInt( self ) }
    /// UInt16への変換
    public var u16:UInt16 { return UInt16( self ) }
    /// UInt32への変換
    public var u32:UInt32 { return UInt32( self ) }
    /// UInt64への変換
    public var u64:UInt64 { return UInt64( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
}

/// UInt16拡張
extension UInt16 : LLFloatConvertable
{
    public static var colorRangeMinValue:UInt16 { return .min }
    public static var colorRangeMaxValue:UInt16 { return .max }
    
    /// Intへの変換
    public var i:Int { return Int( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32 { return Int32( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt { return UInt( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32 { return UInt32( self ) }
    /// UInt64への変換
    public var u64:UInt64 { return UInt64( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
}

/// UInt32拡張
extension UInt32 : LLFloatConvertable 
{
    public static var colorRangeMinValue:UInt32 { return .min }
    public static var colorRangeMaxValue:UInt32 { return .max }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64 { return Int64( self ) }
    /// UIntへの変換
    public var u:UInt { return UInt( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64 { return UInt64( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
}

/// UInt64拡張
extension UInt64 : LLFloatConvertable
{ 
    public static var colorRangeMinValue:UInt64 { return .min }
    public static var colorRangeMaxValue:UInt64 { return .max }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64? { return Int64.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
}

/// Float拡張
extension Float : LLFloatConvertable
{    
    public static var colorRangeMinValue:Float { return 0.0 }
    public static var colorRangeMaxValue:Float { return 1.0 }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64? { return Int64.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return self }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomf( self ) }
    
    // 0.0 ~ 1.0のランダム値
    public static var random:Self { return LLRandomf( 1.0 ) }
}

/// Double拡張
extension Double : LLFloatConvertable
{
    public static var colorRangeMinValue:Double { return 0.0 }
    public static var colorRangeMaxValue:Double { return 1.0 }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64? { return Int64.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return self }
    /// CGFloatへの変換
    public var cgf:CGFloat { return CGFloat( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomd( self ) }
    
    // 0.0 ~ 1.0のランダム値
    public static var random:Self { return LLRandomd( 1.0 ) }
}

/// CGFloat拡張
extension CGFloat : LLFloatConvertable 
{
    public static var colorRangeMinValue:CGFloat { return 0.0 }
    public static var colorRangeMaxValue:CGFloat { return 1.0 }
    
    /// Intへの変換
    public var i:Int? { return Int.optionalCast( self ) } 
    /// Int8への変換
    public var i8:Int8? {return Int8.optionalCast( self ) }
    /// Int16への変換
    public var i16:Int16? { return Int16.optionalCast( self ) }
    /// Int32への変換
    public var i32:Int32? { return Int32.optionalCast( self ) }
    /// Int64への変換
    public var i64:Int64? { return Int64.optionalCast( self ) }
    /// UIntへの変換
    public var u:UInt? { return UInt.optionalCast( self ) }
    /// UInt8への変換    
    public var u8:UInt8? { return UInt8.optionalCast( self ) }
    /// UInt16への変換
    public var u16:UInt16? { return UInt16.optionalCast( self ) }
    /// UInt32への変換
    public var u32:UInt32? { return UInt32.optionalCast( self ) }
    /// UInt64への変換
    public var u64:UInt64? { return UInt64.optionalCast( self ) }
    /// Floatへの変換
    public var f:Float { return Float( self ) }
    /// Doubleへの変換
    public var d:Double { return Double( self ) }
    
    // ランダム値
    public var randomize:Self { return LLRandomd( self ).cgf }
    
    // 0.0 ~ 1.0のランダム値
    public static var random:Self { return LLRandomd( 1.0 ).cgf }
}
