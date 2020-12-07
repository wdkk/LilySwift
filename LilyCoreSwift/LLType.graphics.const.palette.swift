//
//  LLType.graphics.color.swift
//  LilySwift
//
//  Created by Kengo on 2020/01/04.
//  Copyright © 2020 Watanabe-Denki.Inc. All rights reserved.
//

import Foundation

// LLColor向け //

/// 透明
public let LLColor_Clear:LLColor = LLColorMake(   0,   0,   0,   0 ) 
/// 白
public let LLColor_White:LLColor = LLColorMake( 1.0, 1.0, 1.0, 1.0 ) 
/// 黒
public let LLColor_Black:LLColor = LLColorMake(   0,   0,   0, 1.0 ) 
/// 赤
public let LLColor_Red:LLColor = LLColorMake( 1.0,   0,   0, 1.0 ) 
/// 緑
public let LLColor_Green:LLColor = LLColorMake(   0, 1.0,   0, 1.0 ) 
/// 青
public let LLColor_Blue:LLColor = LLColorMake(   0,   0, 1.0, 1.0 ) 
/// 黄色
public let LLColor_Yellow:LLColor = LLColorMake( 1.0, 1.0,   0, 1.0 ) 
/// シアン
public let LLColor_Cyan:LLColor = LLColorMake(   0, 1.0, 1.0, 1.0 ) 
/// マゼンタ
public let LLColor_Magenta:LLColor = LLColorMake( 1.0,   0, 1.0, 1.0 ) 
/// 濃い灰色
public let LLColor_DarkGrey:LLColor = LLColorMake( 0.25, 0.25, 0.25, 1.0 ) 
/// 灰色
public let LLColor_Grey:LLColor = LLColorMake( 0.5, 0.5, 0.5, 1.0 ) 
/// 明るい灰色
public let LLColor_LightGrey:LLColor = LLColorMake( 0.75, 0.75, 0.75, 1.0 ) 

// LLColor16向け //

/// 透明
public let LLColor16_Clear:LLColor16 = LLColorfto16( LLColor_Clear ) 
/// 白
public let LLColor16_White:LLColor16 = LLColorfto16( LLColor_White ) 
/// 黒
public let LLColor16_Black:LLColor16 = LLColorfto16( LLColor_Black ) 
/// 赤
public let LLColor16_Red:LLColor16 = LLColorfto16( LLColor_Red ) 
/// 緑
public let LLColor16_Green:LLColor16 = LLColorfto16( LLColor_Green ) 
/// 青
public let LLColor16_Blue:LLColor16 = LLColorfto16( LLColor_Blue ) 
/// 黄色
public let LLColor16_Yellow:LLColor16 = LLColorfto16( LLColor_Yellow ) 
/// シアン
public let LLColor16_Cyan:LLColor16 = LLColorfto16( LLColor_Cyan ) 
/// マゼンタ
public let LLColor16_Magenta:LLColor16 = LLColorfto16( LLColor_Magenta ) 
/// 濃い灰色
public let LLColor16_DarkGrey:LLColor16 = LLColorfto16( LLColor_DarkGrey ) 
/// 灰色
public let LLColor16_Grey:LLColor16 = LLColorfto16( LLColor_Grey ) 
/// 明るい灰色
public let LLColor16_LightGrey:LLColor16 = LLColorfto16( LLColor_LightGrey ) 

// LLColor8向け //

/// 透明
public let LLColor8_Clear:LLColor8 = LLColorfto8( LLColor_Clear ) 
/// 白
public let LLColor8_White:LLColor8 = LLColorfto8( LLColor_White ) 
/// 黒
public let LLColor8_Black:LLColor8 = LLColorfto8( LLColor_Black ) 
/// 赤
public let LLColor8_Red:LLColor8 = LLColorfto8( LLColor_Red ) 
/// 緑
public let LLColor8_Green:LLColor8 = LLColorfto8( LLColor_Green ) 
/// 青
public let LLColor8_Blue:LLColor8 = LLColorfto8( LLColor_Blue ) 
/// 黄色
public let LLColor8_Yellow:LLColor8 = LLColorfto8( LLColor_Yellow ) 
/// シアン
public let LLColor8_Cyan:LLColor8 = LLColorfto8( LLColor_Cyan ) 
/// マゼンタ
public let LLColor8_Magenta:LLColor8 = LLColorfto8( LLColor_Magenta ) 
/// 濃い灰色
public let LLColor8_DarkGrey:LLColor8 = LLColorfto8( LLColor_DarkGrey ) 
/// 灰色
public let LLColor8_Grey:LLColor8 = LLColorfto8( LLColor_Grey ) 
/// 明るい灰色
public let LLColor8_LightGrey:LLColor8 = LLColorfto8( LLColor_LightGrey ) 
