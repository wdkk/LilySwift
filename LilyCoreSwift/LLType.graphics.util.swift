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

//! @fn long LLImageTypeGetByte( LLImageType type )
//! @brief 画像タイプごとの１ピクセルあたりのバイト数を取得
//! @param type : 画像タイプ
//! @return ピクセルあたりのバイト数
public func LLImageTypeGetByte( _ type:LLImageType ) -> Int {
    switch type {
    case .none:   return 1
    case .grey8:  return MemoryLayout<LLUInt8>.stride
    case .grey16: return MemoryLayout<LLUInt16>.stride
    case .greyf:  return MemoryLayout<LLFloat>.stride
    case .rgba8:  return MemoryLayout<LLColor8>.stride
    case .rgba16: return MemoryLayout<LLColor16>.stride
    case .rgbaf:  return MemoryLayout<LLColor>.stride
    case .hsvi:   return MemoryLayout<LLHSVi>.stride
    case .hsvf:   return MemoryLayout<LLHSVf>.stride
    }
}

public func LLUInt8PtrtoLLColor8Ptr( _ ptr:LLUInt8Ptr ) -> LLColor8Ptr { 
    return unsafeBitCast( ptr, to: LLColor8Ptr.self )
}

public func LLUInt8PtrtoLLColor16Ptr( _ ptr:LLUInt8Ptr ) -> LLColor16Ptr { 
    return unsafeBitCast( ptr, to: LLColor16Ptr.self )
}

public func LLUInt8PtrToLLColorPtr( _ ptr:LLUInt8Ptr ) -> LLColorPtr { 
    return unsafeBitCast( ptr, to: LLColorPtr.self ) 
}

public func LLConv8to16( _ v:LLUInt8 ) -> LLUInt16 { return LLUInt16(v) << 8 }

public func LLConv8tof( _ v:LLUInt8 ) -> LLFloat { return LLFloat(v) / 255.0 }

public func LLConv16to8( _ v:LLUInt16 ) -> LLUInt8 { return LLUInt8(v >> 8) }

public func LLConv16tof( _ v:LLUInt16 ) -> LLFloat { return LLFloat(v) / 65535.0 }

public func LLConvfto8( _ v:LLFloat ) -> LLUInt8 { return LLUInt8( v * 255.0 ) }

public func LLConvfto16( _ v:LLFloat ) -> LLUInt16 { return LLUInt16( v * 65535.0 ) }

public func LLRGBA8toBGRA8( _ rgba:LLColor8 ) -> LLBGRA8 {
    return LLBGRA8( B:rgba.R, G:rgba.G, R:rgba.B, A:rgba.A )
}

public func LLRGBA16toBGRA16( _ rgba:LLColor16 ) -> LLBGRA16 {
    return LLBGRA16( B:rgba.R, G:rgba.G, R:rgba.B, A:rgba.A )
}

public func LLRGBAftoBGRAf( _ rgba:LLColor ) -> LLBGRAf {
    return LLBGRAf( B:rgba.R, G:rgba.G, R:rgba.B, A:rgba.A )
}

public func LLColor8Make( _ R:LLUInt8, _ G:LLUInt8, _ B:LLUInt8, _ A:LLUInt8 ) -> LLColor8 {
    return LLColor8( R:R, G:G, B:B, A:A )
}

public func LLColor16Make( _ R:LLUInt16, _ G:LLUInt16, _ B:LLUInt16, _ A:LLUInt16 ) -> LLColor16 {
    return LLColor16( R:R, G:G, B:B, A:A )
}

public func LLColor32Make( _ R:LLInt32, _ G:LLInt32, _ B:LLInt32, _ A:LLInt32 ) -> LLColor32 {
    return LLColor32( R:R, G:G, B:B, A:A )
}

public func LLColorMake( _ R:LLFloat, _ G:LLFloat, _ B:LLFloat, _ A:LLFloat ) -> LLColor {
    return LLColor( R:R, G:G, B:B, A:A )
}

public func LLColor8to16( _ color:LLColor8 ) -> LLColor16 {
    return LLColor16(
        R:LLConv8to16(color.R), G:LLConv8to16(color.G),
        B:LLConv8to16(color.B), A:LLConv8to16(color.A)
    )
}

public func LLColor8tof( _ color:LLColor8 ) -> LLColor {
    return LLColor(
        R:LLConv8tof(color.R), G:LLConv8tof(color.G),
        B:LLConv8tof(color.B), A:LLConv8tof(color.A)
    )
}

public func LLColor16to8( _ color:LLColor16 ) -> LLColor8 {
    return LLColor8(
        R:LLConv16to8(color.R), G:LLConv16to8(color.G),
        B:LLConv16to8(color.B), A:LLConv16to8(color.A)
    )
}

public func LLColor16tof( _ color:LLColor16 ) -> LLColor {
    return LLColor(
        R:LLConv16tof(color.R), G:LLConv16tof(color.G),
        B:LLConv16tof(color.B), A:LLConv16tof(color.A)
    )
}

public func LLColorfto8( _ color:LLColor ) -> LLColor8 {
    return LLColor8(
        R:LLConvfto8(color.R), G:LLConvfto8(color.G),
        B:LLConvfto8(color.B), A:LLConvfto8(color.A)
    )
}

public func LLColorfto16( _ color:LLColor ) -> LLColor16 {
    return LLColor16(
        R:LLConvfto16(color.R), G:LLConvfto16(color.G),
        B:LLConvfto16(color.B), A:LLConvfto16(color.A)
    )
}

public func LLColorftof( _ color:LLColor ) -> LLColor {
    return color   // スルーパス
}

public func LLColor8Equal( _ c1:LLColor8, _ c2:LLColor8 ) -> Bool {
    return (c1.R == c2.R && c1.G == c2.G && c1.B == c2.B)
}

public func LLColor16Equal( _ c1:LLColor16, _ c2:LLColor16 ) -> Bool {
    return (c1.R == c2.R && c1.G == c2.G && c1.B == c2.B)
}

public func LLColorEqual( _ c1:LLColor, _ c2:LLColor ) -> Bool {
    return (c1.R == c2.R && c1.G == c2.G && c1.B == c2.B)
}

// HSV(float) -> HSV(16,8,8)変換
public func LLHSVftoi( _ hsv:LLHSVf ) -> LLHSVi {
    return LLHSVi( H: LLUInt16( hsv.H ), S: LLUInt8( hsv.S * 255.0 ), V: LLUInt8( hsv.V * 255.0 ) )
}

// HSV(float) -> HSV(16,8,8)変換
public func LLHSVitof( _ hsvi:LLHSVi ) -> LLHSVf {
    return LLHSVf( H: LLFloat( hsvi.H ), S: LLFloat( hsvi.S ) / 255.0, V: LLFloat( hsvi.V ) / 255.0 )
}
// RGB(float) -> HSV(float)変換
public func LLColorftoHSVf( _ color:LLColor ) -> LLHSVf {
    var hsv:LLHSVf = LLHSVf()
    let maxv:Float = LLMax( color.R, LLMax( color.G, color.B ) )
    let minv:Float = LLMin( color.R, LLMin( color.G, color.B ) )
    hsv.V = maxv  // 明度(V)を計算
    hsv.S = 0.0   // 彩度(S)を計算
    // 小さすぎる値で割るとオーバーフローするので0.001とする
    if maxv > 0.001 { hsv.S = (maxv - minv) / maxv; }
    
    // 色相(H)を計算
    // 小さすぎる値で割るとオーバーフローするので0.001とする
    if hsv.S > 0.001 {
        if color.R == maxv { hsv.H = 60.0 * ( color.G - color.B ) / ( maxv - minv ) }
        else if color.G == maxv { hsv.H = 120.0 + 60.0 * ( color.B - color.R ) / ( maxv - minv ) }
        else if color.B == maxv { hsv.H = 240.0 + 60.0 * ( color.R - color.G ) / ( maxv - minv ) }
    }
    else {
        hsv.H = 0.0
    }
    
    if hsv.H > 360.0 { hsv.H -= 360.0 }
    if hsv.H < 0.0 { hsv.H += 360.0 }
    
    return hsv
}

// RGB(8bit) -> HSV(float)変換
public func LLColor8toHSVf( _ color:LLColor8 ) -> LLHSVf {
    return LLColorftoHSVf( LLColor8tof( color ) )
}

// RGB(16bit) -> HSV(float)変換
public func LLColor16toHSVf( _ color:LLColor16 ) -> LLHSVf {
    return LLColorftoHSVf( LLColor16tof( color ) )
}

// RGB(float) -> HSV(16,8,8)変換
public func LLColorftoHSVi( _ color:LLColor ) -> LLHSVi {
    return LLHSVftoi( LLColorftoHSVf( color ) )
}

// RGB(8bit) -> HSV(16,8,8)変換
public func LLColor8toHSVi( _ color:LLColor8 ) -> LLHSVi {
    return LLHSVftoi( LLColor8toHSVf( color ) )
}

// RGB(16bit) -> HSV(16,8,8)変換
public func LLColor16toHSVi( _ color:LLColor16 ) -> LLHSVi {
    return LLHSVftoi( LLColor16toHSVf( color ) )
}

// RGB(8bit) -> グレー(8bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColor8toGrey8( _ color:LLColor8 ) -> LLUInt8 {
    return LLUInt8( ( LLInt32( color.R ) * 299 + LLInt32( color.G ) * 587 + LLInt32( color.B ) * 114 ) / 1000 )
}

// RGB(8bit) -> グレー(16bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColor8toGrey16( _ color:LLColor8 ) -> LLUInt16 {
    return LLUInt16( ( LLInt32( color.R ) * 299 + LLInt32( color.G ) * 587 + LLInt32( color.B ) * 114 ) / 1000 * 256 )
}

// RGB(8bit) -> グレー(float)変換 (Y信号計算を施すので非可逆処理)
public func LLColor8toGreyf( _ color:LLColor8 ) -> LLFloat {
    return ( LLFloat( color.R ) * 0.299 + LLFloat( color.G ) * 0.587 + LLFloat( color.B ) * 0.114 ) / LLFloat( LLColor8_MaxValue )
}

// RGB(16bit) -> グレー(8bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColor16toGrey8( _ color:LLColor16 ) -> LLUInt8 {
    return LLUInt8( ( LLInt32( color.R ) * 299 + LLInt32( color.G ) * 587 + LLInt32( color.B ) * 114 ) / 1000 / 256 )
}

// RGB(16bit) -> グレー(16bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColor16toGrey16( _ color:LLColor16 ) -> LLUInt16 {
    return LLUInt16( ( LLInt32( color.R ) * 299 + LLInt32( color.G ) * 587 + LLInt32( color.B ) * 114 ) / 1000 )
}

// RGB(16bit) -> グレー(float)変換 (Y信号計算を施すので非可逆処理)
public func LLColor16toGreyf( _ color:LLColor16 ) -> LLFloat {
    return ( LLFloat( color.R ) * 0.299 + LLFloat( color.G ) * 0.587 + LLFloat( color.B ) * 0.114 ) / LLFloat( LLColor16_MaxValue )
}

// RGB(float) -> グレー(8bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColorftoGrey8( _ color:LLColor ) -> LLUInt8 {
    return LLUInt8( ( color.R * 0.299 + color.G * 0.587 + color.B * 0.114 ) * LLFloat( LLColor8_MaxValue ) )
}

// RGB(float) -> グレー(16bit)変換 (Y信号計算を施すので非可逆処理)
public func LLColorftoGrey16( _ color:LLColor ) -> LLUInt16 {
    return LLUInt16( ( color.R * 0.299 + color.G * 0.587 + color.B * 0.114 ) * LLFloat( LLColor16_MaxValue ) )
}

// RGB(float) -> グレー(float)変換 (Y信号計算を施すので非可逆処理)
public func LLColorftoGreyf( _ color:LLColor ) -> LLFloat {
    return color.R * 0.299 + color.G * 0.587 + color.B * 0.114
}

// HSV(float) -> RGB(float)変換
public func LLHSVftoColorf( _ hsv:LLHSVf ) -> LLColor {
    var Hv:Float = hsv.H
    let Sv:Float = LLWithin( min: 0.0, hsv.S, max: 1.0 )
    let Vv:Float = LLWithin( min: 0.0, hsv.V, max: 1.0 )
    
    while Hv < 0.0 || 360.0 <= Hv {
        if Hv < 0.0  { Hv += 360.0 }
        if Hv >= 360.0 { Hv -= 360.0 }
    }
    
    let c:Float = Vv * Sv
    let Hf:Float = Hv / 60.0
    let Hp:LLInt32 = LLInt32( Hf )
    let x:Float = c * ( 1.0 - LLFloat( abs( fmod( Hf, 2.0 ) - 1.0 ) ) )
    
    let m:Float = Vv - c

    switch Hp {
    case 0: return LLColorMake( c+m, x+m,   m, 1.0 )
    case 1: return LLColorMake( x+m, c+m,   m, 1.0 )
    case 2: return LLColorMake(   m, c+m, x+m, 1.0 )
    case 3: return LLColorMake(   m, x+m, c+m, 1.0 )
    case 4: return LLColorMake( x+m,   m, c+m, 1.0 )
    case 5: return LLColorMake( c+m,   m, x+m, 1.0 )
    default: return LLColorMake( 0, 0, 0, 0 )
    }
}

// HSV(float) -> RGB(8bit)変換
public func LLHSVftoColor8( _ hsv:LLHSVf ) -> LLColor8 {
    return LLColorfto8( LLHSVftoColorf( hsv ) )
}

// HSV(float) -> RGB(16bit)変換
public func LLHSVftoColor16( _ hsv:LLHSVf ) -> LLColor16 {
    return LLColorfto16( LLHSVftoColorf( hsv ) )
}

// HSV(float) -> Grey(8bit)変換
public func LLHSVftoGrey8( _ hsv:LLHSVf ) -> LLUInt8 {
    return LLColorftoGrey8( LLHSVftoColorf( hsv ) )
}

// HSV(float) -> Grey(16bit)変換
public func LLHSVftoGrey16( _ hsv:LLHSVf ) -> LLUInt16 {
    return LLColorftoGrey16( LLHSVftoColorf( hsv ) )
}

// HSV(float) -> Grey(float)変換
public func LLHSVftoGreyf( _ hsv:LLHSVf ) -> LLFloat {
    return LLColorftoGreyf( LLHSVftoColorf( hsv ) )
}

// HSV(16,8,8) -> RGB(float)変換
public func LLHSVitoColorf( _ hsvi:LLHSVi ) -> LLColor {
    return LLHSVftoColorf( LLHSVitof( hsvi ) )
}

// HSV(16,8,8) -> RGB(8bit)変換
public func LLHSVitoColor8( _ hsvi:LLHSVi ) -> LLColor8 {
    return LLHSVftoColor8( LLHSVitof( hsvi ) )
}

// HSV(16,8,8) -> RGB(16bit)変換
public func LLHSVitoColor16( _ hsvi:LLHSVi ) -> LLColor16 {
    return LLHSVftoColor16( LLHSVitof( hsvi ) )
}

// HSV(16,8,8) -> Grey(8bit)変換
public func LLHSVitoGrey8( _ hsvi:LLHSVi ) -> LLUInt8 {
    return LLColorftoGrey8( LLHSVitoColorf( hsvi ) )
}

// HSV(16,8,8) -> Grey(16bit)変換
public func LLHSVitoGrey16( _ hsvi:LLHSVi ) -> LLUInt16 {
    return LLColorftoGrey16( LLHSVitoColorf( hsvi ) )
}

// HSV(16,8,8) -> Grey(float)変換
public func LLHSVitoGreyf( _ hsvi:LLHSVi ) -> LLFloat {
    return LLColorftoGreyf( LLHSVitoColorf( hsvi ) )
}

// グレー(8bit)変換 -> グレー(16bit)
public func LLGrey8to16( _ grey:LLUInt8 ) -> LLUInt16 {
    return LLConv8to16( grey )
}

// グレー(8bit)変換 -> グレー(float)
public func LLGrey8to16( _ grey:LLUInt8 ) -> LLFloat {
    return LLConv8tof( grey )
}

// グレー(16bit)変換 -> グレー(8bit)
public func LLGrey16to8( _ grey:LLUInt16 ) -> LLUInt8 {
    return LLConv16to8( grey )
}

// グレー(16bit)変換 -> グレー(float)
public func LLGrey16tof( _ grey:LLUInt16 ) -> LLFloat {
    return LLConv16tof( grey )
}

// グレー(float)変換 -> グレー(8bit)
public func LLGreyfto8( _ grey:LLFloat ) -> LLUInt8 {
    return LLConvfto8( grey )
}

// グレー(float)変換 -> グレー(16bit)
public func LLGreyfto16( _ grey:LLFloat ) -> LLUInt16 {
    return LLConvfto16( grey )
}

// グレー(8bit)変換 -> RGB(8bit) (RGBに同じ値)
public func LLGrey8toColor8( _ grey:LLUInt8 ) -> LLColor8 {
    let g8:LLUInt8 = grey
    return LLColor8( R: g8, G: g8, B: g8, A: LLColor8_MaxValue )
}

// グレー(8bit)変換 -> RGB(16bit) (RGBに同じ値)
public func LLGrey8toColor16( _ grey:LLUInt8 ) -> LLColor16 {
    let g16:LLUInt16 = LLUInt16( grey ) >> 8
    return LLColor16( R: g16, G: g16, B: g16, A: LLColor16_MaxValue )
}

// グレー(8bit)変換 -> RGB(float) (RGBに同じ値)
public func LLGrey8toColorf( _ grey:LLUInt8 ) -> LLColor {
    let gf:LLFloat = LLFloat( grey ) / LLFloat( LLColor8_MaxValue )
    return LLColor( R: gf, G: gf, B: gf, A: LLColor_MaxValue )
}

// グレー(8bit)変換 -> HSV(float)
public func LLGrey8toHSVf( _ grey:LLUInt8 ) -> LLHSVf {
    return LLColorftoHSVf( LLGrey8toColorf( grey ) )
}

// グレー(8bit)変換 -> HSV(16,8,8)
public func LLGrey8toHSVi( _ grey:LLUInt8 ) -> LLHSVi {
    return LLColorftoHSVi( LLGrey8toColorf( grey ) )
}

// グレー(16bit)変換 -> RGB(8bit) (RGBに同じ値)
public func LLGrey16toColor8( _ grey:LLUInt16 ) -> LLColor8 {
    let g8:LLUInt8 = LLUInt8( grey >> 8 )
    return LLColor8( R: g8, G: g8, B: g8, A: LLColor8_MaxValue )
}

// グレー(16bit)変換 -> RGB(16bit) (RGBに同じ値)
public func LLGrey16toColor16( _ grey:LLUInt16 ) -> LLColor16 {
    let g16:LLUInt16 = grey
    return LLColor16( R: g16, G: g16, B: g16, A: LLColor16_MaxValue )
}

// グレー(16bit)変換 -> RGB(float) (RGBに同じ値)
public func LLGrey16toColorf( _ grey:LLUInt16 ) -> LLColor {
    let g:LLFloat = LLFloat( grey ) / LLFloat( LLColor16_MaxValue )
    return LLColor( R: g, G: g, B: g, A: LLColor_MaxValue )
}

// グレー(16bit)変換 -> HSV(float)
public func LLGrey16toHSVf( _ grey:LLUInt16 ) -> LLHSVf {
    return LLColorftoHSVf( LLGrey16toColorf( grey ) );
}

// グレー(16bit)変換 -> HSV(16,8,8)
public func LLGrey16toHSVi( _ grey:LLUInt16 ) -> LLHSVi {
    return LLColorftoHSVi( LLGrey16toColorf( grey ) );
}

// グレー(float)変換 -> RGB(8bit) (RGBに同じ値)
public func LLGreyftoColor8( _ grey:LLFloat ) -> LLColor8 {
    let g8:LLUInt8 = LLUInt8( grey * LLFloat( LLColor8_MaxValue ) )
    return LLColor8( R: g8, G: g8, B: g8, A: LLColor8_MaxValue )
}

// グレー(float)変換 -> RGB(16bit) (RGBに同じ値)
public func LLGreyftoColor16( _ grey:LLFloat ) -> LLColor16 {
    let g16:LLUInt16 = LLUInt16( grey * LLFloat( LLColor16_MaxValue ) )
    return LLColor16( R: g16, G: g16, B: g16, A: LLColor16_MaxValue )
}

// グレー(float)変換 -> RGB(float) (RGBに同じ値)
public func LLGreyftoColorf( _ grey:LLFloat ) -> LLColor {
    let g:LLFloat = grey
    return LLColor( R: g, G: g, B: g, A: LLColor_MaxValue )
}

// グレー(16bit)変換 -> HSV(float)
public func LLGreyftoHSVf( _ grey:LLFloat ) -> LLHSVf {
    return LLColorftoHSVf( LLGreyftoColorf( grey ) )
}

// グレー(16bit)変換 -> HSV(16,8,8)
public func LLGreyftoHSVi( _ grey:LLFloat ) -> LLHSVi {
    return LLColorftoHSVi( LLGreyftoColorf( grey ) )
}

// 画像ロードオプションの標準設定を返す関数
public func LLImageLoadOptionDefault() -> LLImageLoadOption {
    let option:LLImageLoadOption = LLImageLoadOption(
        type: .auto,
        depth: .uint8 )
    return option
}

// 画像セーブオプションの標準設定を返す関数
public func LLImageSaveOptionDefault() -> LLImageSaveOption {
    let option:LLImageSaveOption = LLImageSaveOption(
        type: .auto,
        jpeg_quality: 0.85,
        png_compress: 2.0,
        png_depth: .uint8,
        bitmap_info: .bit24,
        targa_info: .bit32,
        tiff_info: .lzw )
    return option
}

public func LLHextoColor8( _ hex_:LCStringSmPtr ) -> LLColor8 {
    var upper_hex:LCStringSmPtr = LCStringUppercased( hex_ )
    upper_hex = LCStringReplace( upper_hex, LCStringMakeWithCChars( "#" ),  LCStringZero() )
    upper_hex = LCStringReplace( upper_hex, LCStringMakeWithCChars( "0X" ), LCStringZero() )
    let length:Int = LCStringByteLength( upper_hex )
    
    var R:UInt8 = 0
    var G:UInt8 = 0
    var B:UInt8 = 0
    var A:UInt8 = 255
    
    let parts:LLCChars = LCStringToCChars( upper_hex )
    var parts_u8:[LLUInt8] = [LLUInt8]()
    for p:CChar in parts {
        guard let u:LLUInt8 = p.u8 else { LLLogWarning( "Hexの文字列が変換できません." ); return LLColor8_Black }
        parts_u8.append( u )
    }
    
    switch length {
        // #RGB
        case 3:
            guard let str_R:String = String( bytes: [ parts_u8[0], parts_u8[0] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_G:String = String( bytes: [ parts_u8[1], parts_u8[1] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_B:String = String( bytes: [ parts_u8[2], parts_u8[2] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            R = UInt8(str_R, radix: 16) ?? 0
            G = UInt8(str_G, radix: 16) ?? 0
            B = UInt8(str_B, radix: 16) ?? 0
            A = 255
            return LLColor8Make( R, G, B, A )
        // #RRGGBB
        case 6:
            guard let str_R:String = String( bytes: [ parts_u8[0], parts_u8[1] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_G:String = String( bytes: [ parts_u8[2], parts_u8[3] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_B:String = String( bytes: [ parts_u8[4], parts_u8[5] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            R = UInt8(str_R, radix: 16) ?? 0
            G = UInt8(str_G, radix: 16) ?? 0
            B = UInt8(str_B, radix: 16) ?? 0
            A = 255
            return LLColor8Make( R, G, B, A )
        // #RRGGBBAA
        case 8: 
            guard let str_R:String = String( bytes: [ parts_u8[0], parts_u8[1] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_G:String = String( bytes: [ parts_u8[2], parts_u8[3] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_B:String = String( bytes: [ parts_u8[4], parts_u8[5] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            guard let str_A:String = String( bytes: [ parts_u8[6], parts_u8[7] ], encoding: .utf8 ) else {
                LLLogWarning( "正しくないHex指定です" ); return LLColor8_Black
            }
            R = UInt8(str_R, radix: 16) ?? 0
            G = UInt8(str_G, radix: 16) ?? 0
            B = UInt8(str_B, radix: 16) ?? 0
            A = UInt8(str_A, radix: 16) ?? 255
            return LLColor8Make( R, G, B, A )
        default:
            LLLogWarning( "正しくないHex指定です" )
            return LLColor8_Black
    }
}
