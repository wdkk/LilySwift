//
//  LLType.graphics.color.swift
//  LilySwift
//
//  Created by Kengo on 2020/01/04.
//  Copyright © 2020 Watanabe-DENKI.Inc. All rights reserved.
//

import Foundation

// LLColor向け //

/// 透明
public let LLColor_Clear = LLColorMake(   0,   0,   0,   0 ) 
/// 白
public let LLColor_White = LLColorMake( 1.0, 1.0, 1.0, 1.0 ) 
/// 黒
public let LLColor_Black = LLColorMake(   0,   0,   0, 1.0 ) 
/// 赤
public let LLColor_Red = LLColorMake( 1.0,   0,   0, 1.0 ) 
/// 緑
public let LLColor_Green = LLColorMake(   0, 1.0,   0, 1.0 ) 
/// 青
public let LLColor_Blue = LLColorMake(   0,   0, 1.0, 1.0 ) 
/// 黄色
public let LLColor_Yellow = LLColorMake( 1.0, 1.0,   0, 1.0 ) 
/// シアン
public let LLColor_Cyan = LLColorMake(   0, 1.0, 1.0, 1.0 ) 
/// マゼンタ
public let LLColor_Magenta = LLColorMake( 1.0,   0, 1.0, 1.0 ) 
/// 濃い灰色
public let LLColor_DarkGrey = LLColorMake( 0.25, 0.25, 0.25, 1.0 ) 
/// 灰色
public let LLColor_Grey = LLColorMake( 0.5, 0.5, 0.5, 1.0 ) 
/// 明るい灰色
public let LLColor_LightGrey = LLColorMake( 0.75, 0.75, 0.75, 1.0 ) 

// LLColor16向け //

/// 透明
public let LLColor16_Clear = LLColorfto16( LLColor_Clear ) 
/// 白
public let LLColor16_White = LLColorfto16( LLColor_White ) 
/// 黒
public let LLColor16_Black = LLColorfto16( LLColor_Black ) 
/// 赤
public let LLColor16_Red = LLColorfto16( LLColor_Red ) 
/// 緑
public let LLColor16_Green = LLColorfto16( LLColor_Green ) 
/// 青
public let LLColor16_Blue = LLColorfto16( LLColor_Blue ) 
/// 黄色
public let LLColor16_Yellow = LLColorfto16( LLColor_Yellow ) 
/// シアン
public let LLColor16_Cyan = LLColorfto16( LLColor_Cyan ) 
/// マゼンタ
public let LLColor16_Magenta = LLColorfto16( LLColor_Magenta ) 
/// 濃い灰色
public let LLColor16_DarkGrey = LLColorfto16( LLColor_DarkGrey ) 
/// 灰色
public let LLColor16_Grey = LLColorfto16( LLColor_Grey ) 
/// 明るい灰色
public let LLColor16_LightGrey = LLColorfto16( LLColor_LightGrey ) 

// LLColor8向け //

/// 透明
public let LLColor8_Clear = LLColorfto8( LLColor_Clear ) 
/// 白
public let LLColor8_White = LLColorfto8( LLColor_White ) 
/// 黒
public let LLColor8_Black = LLColorfto8( LLColor_Black ) 
/// 赤
public let LLColor8_Red = LLColorfto8( LLColor_Red ) 
/// 緑
public let LLColor8_Green = LLColorfto8( LLColor_Green ) 
/// 青
public let LLColor8_Blue = LLColorfto8( LLColor_Blue ) 
/// 黄色
public let LLColor8_Yellow = LLColorfto8( LLColor_Yellow ) 
/// シアン
public let LLColor8_Cyan = LLColorfto8( LLColor_Cyan ) 
/// マゼンタ
public let LLColor8_Magenta = LLColorfto8( LLColor_Magenta ) 
/// 濃い灰色
public let LLColor8_DarkGrey = LLColorfto8( LLColor_DarkGrey ) 
/// 灰色
public let LLColor8_Grey = LLColorfto8( LLColor_Grey ) 
/// 明るい灰色
public let LLColor8_LightGrey = LLColorfto8( LLColor_LightGrey ) 
