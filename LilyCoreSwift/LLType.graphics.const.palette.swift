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

//public let LLColor_Black = LLHexColor( LCStringMakeWithCChars( "#000000" ) )
public let LLColor_Aliceblue = LLHexColor( LCStringMakeWithCChars( "#f0f8ff" ) )
public let LLColor_Darkcyan = LLHexColor( LCStringMakeWithCChars( "#008b8b" ) )
public let LLColor_Lightyellow = LLHexColor( LCStringMakeWithCChars( "#ffffe0" ) )
public let LLColor_Coral = LLHexColor( LCStringMakeWithCChars( "#ff7f50" ) )
public let LLColor_Dimgray = LLHexColor( LCStringMakeWithCChars( "#696969" ) )
public let LLColor_Lavender = LLHexColor( LCStringMakeWithCChars( "#e6e6fa" ) )
public let LLColor_Teal = LLHexColor( LCStringMakeWithCChars( "#008080" ) )
public let LLColor_Lightgoldenrodyellow = LLHexColor( LCStringMakeWithCChars( "#fafad2" ) )
public let LLColor_Tomato = LLHexColor( LCStringMakeWithCChars( "#ff6347" ) )
public let LLColor_Gray = LLColor_Grey
public let LLColor_Lightsteelblue = LLHexColor( LCStringMakeWithCChars( "#b0c4de" ) )
public let LLColor_Darkslategray = LLHexColor( LCStringMakeWithCChars( "#2f4f4f" ) )
public let LLColor_Lemonchiffon = LLHexColor( LCStringMakeWithCChars( "#fffacd" ) )
public let LLColor_Orangered = LLHexColor( LCStringMakeWithCChars( "#ff4500" ) )
public let LLColor_Darkgray = LLColor_DarkGrey
public let LLColor_Lightslategray = LLHexColor( LCStringMakeWithCChars( "#778899" ) )
public let LLColor_Darkgreen = LLHexColor( LCStringMakeWithCChars( "#006400" ) )
public let LLColor_Wheat = LLHexColor( LCStringMakeWithCChars( "#f5deb3" ) )
//public let LLColor_Red = LLHexColor( LCStringMakeWithCChars( "#ff0000" ) )
public let LLColor_Silver = LLHexColor( LCStringMakeWithCChars( "#c0c0c0" ) )
public let LLColor_Slategray = LLHexColor( LCStringMakeWithCChars( "#708090" ) )
//public let LLColor_Green = LLHexColor( LCStringMakeWithCChars( "#008000" ) )
public let LLColor_Burlywood = LLHexColor( LCStringMakeWithCChars( "#deb887" ) )
public let LLColor_Crimson = LLHexColor( LCStringMakeWithCChars( "#dc143c" ) )
public let LLColor_Lightgray = LLColor_LightGrey
public let LLColor_Steelblue = LLHexColor( LCStringMakeWithCChars( "#4682b4" ) )
public let LLColor_Forestgreen = LLHexColor( LCStringMakeWithCChars( "#228b22" ) )
public let LLColor_Tan = LLHexColor( LCStringMakeWithCChars( "#d2b48c" ) )
public let LLColor_Mediumvioletred = LLHexColor( LCStringMakeWithCChars( "#c71585" ) )
public let LLColor_Gainsboro = LLHexColor( LCStringMakeWithCChars( "#dcdcdc" ) )
public let LLColor_Royalblue = LLHexColor( LCStringMakeWithCChars( "#4169e1" ) )
public let LLColor_Seagreen = LLHexColor( LCStringMakeWithCChars( "#2e8b57" ) )
public let LLColor_Khaki = LLHexColor( LCStringMakeWithCChars( "#f0e68c" ) )
public let LLColor_Deeppink = LLHexColor( LCStringMakeWithCChars( "#ff1493" ) )
public let LLColor_Whitesmoke = LLHexColor( LCStringMakeWithCChars( "#f5f5f5" ) )
public let LLColor_Midnightblue = LLHexColor( LCStringMakeWithCChars( "#191970" ) )
public let LLColor_Mediumseagreen = LLHexColor( LCStringMakeWithCChars( "#3cb371" ) )
//public let LLColor_Yellow = LLHexColor( LCStringMakeWithCChars( "#ffff00" ) )
public let LLColor_Hotpink = LLHexColor( LCStringMakeWithCChars( "#ff69b4" ) )
//public let LLColor_White = LLHexColor( LCStringMakeWithCChars( "#ffffff" ) )
public let LLColor_Navy = LLHexColor( LCStringMakeWithCChars( "#000080" ) )
public let LLColor_Mediumaquamarine = LLHexColor( LCStringMakeWithCChars( "#66cdaa" ) )
public let LLColor_Gold = LLHexColor( LCStringMakeWithCChars( "#ffd700" ) )
public let LLColor_Palevioletred = LLHexColor( LCStringMakeWithCChars( "#db7093" ) )
public let LLColor_Snow = LLHexColor( LCStringMakeWithCChars( "#fffafa" ) )
public let LLColor_Darkblue = LLHexColor( LCStringMakeWithCChars( "#00008b" ) )
public let LLColor_Darkseagreen = LLHexColor( LCStringMakeWithCChars( "#8fbc8f" ) )
public let LLColor_Orange = LLHexColor( LCStringMakeWithCChars( "#ffa500" ) )
public let LLColor_Pink = LLHexColor( LCStringMakeWithCChars( "#ffc0cb" ) )
public let LLColor_Ghostwhite = LLHexColor( LCStringMakeWithCChars( "#f8f8ff" ) )
public let LLColor_Mediumblue = LLHexColor( LCStringMakeWithCChars( "#0000cd" ) )
public let LLColor_Aquamarine = LLHexColor( LCStringMakeWithCChars( "#7fffd4" ) )
public let LLColor_Sandybrown = LLHexColor( LCStringMakeWithCChars( "#f4a460" ) )
public let LLColor_Lightpink = LLHexColor( LCStringMakeWithCChars( "#ffb6c1" ) )
public let LLColor_Floralwhite = LLHexColor( LCStringMakeWithCChars( "#fffaf0" ) )
//public let LLColor_Blue = LLHexColor( LCStringMakeWithCChars( "#0000ff" ) )
public let LLColor_Palegreen = LLHexColor( LCStringMakeWithCChars( "#98fb98" ) )
public let LLColor_Darkorange = LLHexColor( LCStringMakeWithCChars( "#ff8c00" ) )
public let LLColor_Thistle = LLHexColor( LCStringMakeWithCChars( "#d8bfd8" ) )
public let LLColor_Linen = LLHexColor( LCStringMakeWithCChars( "#faf0e6" ) )
public let LLColor_Dodgerblue = LLHexColor( LCStringMakeWithCChars( "#1e90ff" ) )
public let LLColor_Lightgreen = LLHexColor( LCStringMakeWithCChars( "#90ee90" ) )
public let LLColor_Goldenrod = LLHexColor( LCStringMakeWithCChars( "#daa520" ) )
//public let LLColor_Magenta = LLHexColor( LCStringMakeWithCChars( "#ff00ff" ) )
public let LLColor_Antiquewhite = LLHexColor( LCStringMakeWithCChars( "#faebd7" ) )
public let LLColor_Cornflowerblue = LLHexColor( LCStringMakeWithCChars( "#6495ed" ) )
public let LLColor_Springgreen = LLHexColor( LCStringMakeWithCChars( "#00ff7f" ) )
public let LLColor_Peru = LLHexColor( LCStringMakeWithCChars( "#cd853f" ) )
public let LLColor_Fuchsia = LLHexColor( LCStringMakeWithCChars( "#ff00ff" ) )
public let LLColor_Papayawhip = LLHexColor( LCStringMakeWithCChars( "#ffefd5" ) )
public let LLColor_Deepskyblue = LLHexColor( LCStringMakeWithCChars( "#00bfff" ) )
public let LLColor_Mediumspringgreen = LLHexColor( LCStringMakeWithCChars( "#00fa9a" ) )
public let LLColor_Darkgoldenrod = LLHexColor( LCStringMakeWithCChars( "#b8860b" ) )
public let LLColor_Violet = LLHexColor( LCStringMakeWithCChars( "#ee82ee" ) )
public let LLColor_Blanchedalmond = LLHexColor( LCStringMakeWithCChars( "#ffebcd" ) )
public let LLColor_Lightskyblue = LLHexColor( LCStringMakeWithCChars( "#87cefa" ) )
public let LLColor_Lawngreen = LLHexColor( LCStringMakeWithCChars( "#7cfc00" ) )
public let LLColor_Chocolate = LLHexColor( LCStringMakeWithCChars( "#d2691e" ) )
public let LLColor_Plum = LLHexColor( LCStringMakeWithCChars( "#dda0dd" ) )
public let LLColor_Bisque = LLHexColor( LCStringMakeWithCChars( "#ffe4c4" ) )
public let LLColor_Skyblue = LLHexColor( LCStringMakeWithCChars( "#87ceeb" ) )
public let LLColor_Chartreuse = LLHexColor( LCStringMakeWithCChars( "#7fff00" ) )
public let LLColor_Sienna = LLHexColor( LCStringMakeWithCChars( "#a0522d" ) )
public let LLColor_Orchid = LLHexColor( LCStringMakeWithCChars( "#da70d6" ) )
public let LLColor_Moccasin = LLHexColor( LCStringMakeWithCChars( "#ffe4b5" ) )
public let LLColor_Lightblue = LLHexColor( LCStringMakeWithCChars( "#add8e6" ) )
public let LLColor_Greenyellow = LLHexColor( LCStringMakeWithCChars( "#adff2f" ) )
public let LLColor_Saddlebrown = LLHexColor( LCStringMakeWithCChars( "#8b4513" ) )
public let LLColor_Mediumorchid = LLHexColor( LCStringMakeWithCChars( "#ba55d3" ) )
public let LLColor_Navajowhite = LLHexColor( LCStringMakeWithCChars( "#ffdead" ) )
public let LLColor_Powderblue = LLHexColor( LCStringMakeWithCChars( "#b0e0e6" ) )
public let LLColor_Lime = LLHexColor( LCStringMakeWithCChars( "#00ff00" ) )
public let LLColor_Maroon = LLHexColor( LCStringMakeWithCChars( "#800000" ) )
public let LLColor_Darkorchid = LLHexColor( LCStringMakeWithCChars( "#9932cc" ) )
public let LLColor_Peachpuff = LLHexColor( LCStringMakeWithCChars( "#ffdab9" ) )
public let LLColor_Paleturquoise = LLHexColor( LCStringMakeWithCChars( "#afeeee" ) )
public let LLColor_Limegreen = LLHexColor( LCStringMakeWithCChars( "#32cd32" ) )
public let LLColor_Darkred = LLHexColor( LCStringMakeWithCChars( "#8b0000" ) )
public let LLColor_Darkviolet = LLHexColor( LCStringMakeWithCChars( "#9400d3" ) )
public let LLColor_Mistyrose = LLHexColor( LCStringMakeWithCChars( "#ffe4e1" ) )
public let LLColor_Lightcyan = LLHexColor( LCStringMakeWithCChars( "#e0ffff" ) )
public let LLColor_Yellowgreen = LLHexColor( LCStringMakeWithCChars( "#9acd32" ) )
public let LLColor_Brown = LLHexColor( LCStringMakeWithCChars( "#a52a2a" ) )
public let LLColor_Darkmagenta = LLHexColor( LCStringMakeWithCChars( "#8b008b" ) )
public let LLColor_Lavenderblush = LLHexColor( LCStringMakeWithCChars( "#fff0f5" ) )
//public let LLColor_Cyan = LLHexColor( LCStringMakeWithCChars( "#00ffff" ) )
public let LLColor_Darkolivegreen = LLHexColor( LCStringMakeWithCChars( "#556b2f" ) )
public let LLColor_Firebrick = LLHexColor( LCStringMakeWithCChars( "#b22222" ) )
public let LLColor_Purple = LLHexColor( LCStringMakeWithCChars( "#800080" ) )
public let LLColor_Seashell = LLHexColor( LCStringMakeWithCChars( "#fff5ee" ) )
public let LLColor_Aqua = LLHexColor( LCStringMakeWithCChars( "#00ffff" ) )
public let LLColor_Olivedrab = LLHexColor( LCStringMakeWithCChars( "#6b8e23" ) )
public let LLColor_Indianred = LLHexColor( LCStringMakeWithCChars( "#cd5c5c" ) )
public let LLColor_Indigo = LLHexColor( LCStringMakeWithCChars( "#4b0082" ) )
public let LLColor_Oldlace = LLHexColor( LCStringMakeWithCChars( "#fdf5e6" ) )
public let LLColor_Turquoise = LLHexColor( LCStringMakeWithCChars( "#40e0d0" ) )
public let LLColor_Olive = LLHexColor( LCStringMakeWithCChars( "#808000" ) )
public let LLColor_Rosybrown = LLHexColor( LCStringMakeWithCChars( "#bc8f8f" ) )
public let LLColor_Darkslateblue = LLHexColor( LCStringMakeWithCChars( "#483d8b" ) )
public let LLColor_Ivory = LLHexColor( LCStringMakeWithCChars( "#fffff0" ) )
public let LLColor_Mediumturquoise = LLHexColor( LCStringMakeWithCChars( "#48d1cc" ) )
public let LLColor_Darkkhaki = LLHexColor( LCStringMakeWithCChars( "#bdb76b" ) )
public let LLColor_Darksalmon = LLHexColor( LCStringMakeWithCChars( "#e9967a" ) )
public let LLColor_Blueviolet = LLHexColor( LCStringMakeWithCChars( "#8a2be2" ) )
public let LLColor_Honeydew = LLHexColor( LCStringMakeWithCChars( "#f0fff0" ) )
public let LLColor_Darkturquoise = LLHexColor( LCStringMakeWithCChars( "#00ced1" ) )
public let LLColor_Palegoldenrod = LLHexColor( LCStringMakeWithCChars( "#eee8aa" ) )
public let LLColor_Lightcoral = LLHexColor( LCStringMakeWithCChars( "#f08080" ) )
public let LLColor_Mediumpurple = LLHexColor( LCStringMakeWithCChars( "#9370db" ) )
public let LLColor_Mintcream = LLHexColor( LCStringMakeWithCChars( "#f5fffa" ) )
public let LLColor_Lightseagreen = LLHexColor( LCStringMakeWithCChars( "#20b2aa" ) )
public let LLColor_Cornsilk = LLHexColor( LCStringMakeWithCChars( "#fff8dc" ) )
public let LLColor_Salmon = LLHexColor( LCStringMakeWithCChars( "#fa8072" ) )
public let LLColor_Slateblue = LLHexColor( LCStringMakeWithCChars( "#6a5acd" ) )
public let LLColor_Azure = LLHexColor( LCStringMakeWithCChars( "#f0ffff" ) )
public let LLColor_Cadetblue = LLHexColor( LCStringMakeWithCChars( "#5f9ea0" ) )
public let LLColor_Beige = LLHexColor( LCStringMakeWithCChars( "#f5f5dc" ) )
public let LLColor_Lightsalmon = LLHexColor( LCStringMakeWithCChars( "#ffa07a" ) )
public let LLColor_Mediumslateblue = LLHexColor( LCStringMakeWithCChars( "#7b68ee" ) )



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

public let LLColor16_Black = LLColorfto16( LLColor_Black ) 
public let LLColor16_Aliceblue = LLColorfto16( LLColor_Aliceblue ) 
public let LLColor16_Darkcyan = LLColorfto16( LLColor_Darkcyan ) 
public let LLColor16_Lightyellow = LLColorfto16( LLColor_Lightyellow ) 
public let LLColor16_Coral = LLColorfto16( LLColor_Coral ) 
public let LLColor16_Dimgray = LLColorfto16( LLColor_Dimgray ) 
public let LLColor16_Lavender = LLColorfto16( LLColor_Lavender ) 
public let LLColor16_Teal = LLColorfto16( LLColor_Teal ) 
public let LLColor16_Lightgoldenrodyellow = LLColorfto16( LLColor_Lightgoldenrodyellow ) 
public let LLColor16_Tomato = LLColorfto16( LLColor_Tomato ) 
public let LLColor16_Gray = LLColorfto16( LLColor_Gray ) 
public let LLColor16_Lightsteelblue = LLColorfto16( LLColor_Lightsteelblue ) 
public let LLColor16_Darkslategray = LLColorfto16( LLColor_Darkslategray ) 
public let LLColor16_Lemonchiffon = LLColorfto16( LLColor_Lemonchiffon ) 
public let LLColor16_Orangered = LLColorfto16( LLColor_Orangered ) 
public let LLColor16_Darkgray = LLColorfto16( LLColor_Darkgray ) 
public let LLColor16_Lightslategray = LLColorfto16( LLColor_Lightslategray ) 
public let LLColor16_Darkgreen = LLColorfto16( LLColor_Darkgreen ) 
public let LLColor16_Wheat = LLColorfto16( LLColor_Wheat ) 
public let LLColor16_Red = LLColorfto16( LLColor_Red ) 
public let LLColor16_Silver = LLColorfto16( LLColor_Silver ) 
public let LLColor16_Slategray = LLColorfto16( LLColor_Slategray ) 
public let LLColor16_Green = LLColorfto16( LLColor_Green ) 
public let LLColor16_Burlywood = LLColorfto16( LLColor_Burlywood ) 
public let LLColor16_Crimson = LLColorfto16( LLColor_Crimson ) 
public let LLColor16_Lightgray = LLColorfto16( LLColor_Lightgray ) 
public let LLColor16_Steelblue = LLColorfto16( LLColor_Steelblue ) 
public let LLColor16_Forestgreen = LLColorfto16( LLColor_Forestgreen ) 
public let LLColor16_Tan = LLColorfto16( LLColor_Tan ) 
public let LLColor16_Mediumvioletred = LLColorfto16( LLColor_Mediumvioletred ) 
public let LLColor16_Gainsboro = LLColorfto16( LLColor_Gainsboro ) 
public let LLColor16_Royalblue = LLColorfto16( LLColor_Royalblue ) 
public let LLColor16_Seagreen = LLColorfto16( LLColor_Seagreen ) 
public let LLColor16_Khaki = LLColorfto16( LLColor_Khaki ) 
public let LLColor16_Deeppink = LLColorfto16( LLColor_Deeppink ) 
public let LLColor16_Whitesmoke = LLColorfto16( LLColor_Whitesmoke ) 
public let LLColor16_Midnightblue = LLColorfto16( LLColor_Midnightblue ) 
public let LLColor16_Mediumseagreen = LLColorfto16( LLColor_Mediumseagreen ) 
public let LLColor16_Yellow = LLColorfto16( LLColor_Yellow ) 
public let LLColor16_Hotpink = LLColorfto16( LLColor_Hotpink ) 
public let LLColor16_White = LLColorfto16( LLColor_White ) 
public let LLColor16_Navy = LLColorfto16( LLColor_Navy ) 
public let LLColor16_Mediumaquamarine = LLColorfto16( LLColor_Mediumaquamarine ) 
public let LLColor16_Gold = LLColorfto16( LLColor_Gold ) 
public let LLColor16_Palevioletred = LLColorfto16( LLColor_Palevioletred ) 
public let LLColor16_Snow = LLColorfto16( LLColor_Snow ) 
public let LLColor16_Darkblue = LLColorfto16( LLColor_Darkblue ) 
public let LLColor16_Darkseagreen = LLColorfto16( LLColor_Darkseagreen ) 
public let LLColor16_Orange = LLColorfto16( LLColor_Orange ) 
public let LLColor16_Pink = LLColorfto16( LLColor_Pink ) 
public let LLColor16_Ghostwhite = LLColorfto16( LLColor_Ghostwhite ) 
public let LLColor16_Mediumblue = LLColorfto16( LLColor_Mediumblue ) 
public let LLColor16_Aquamarine = LLColorfto16( LLColor_Aquamarine ) 
public let LLColor16_Sandybrown = LLColorfto16( LLColor_Sandybrown ) 
public let LLColor16_Lightpink = LLColorfto16( LLColor_Lightpink ) 
public let LLColor16_Floralwhite = LLColorfto16( LLColor_Floralwhite ) 
public let LLColor16_Blue = LLColorfto16( LLColor_Blue ) 
public let LLColor16_Palegreen = LLColorfto16( LLColor_Palegreen ) 
public let LLColor16_Darkorange = LLColorfto16( LLColor_Darkorange ) 
public let LLColor16_Thistle = LLColorfto16( LLColor_Thistle ) 
public let LLColor16_Linen = LLColorfto16( LLColor_Linen ) 
public let LLColor16_Dodgerblue = LLColorfto16( LLColor_Dodgerblue ) 
public let LLColor16_Lightgreen = LLColorfto16( LLColor_Lightgreen ) 
public let LLColor16_Goldenrod = LLColorfto16( LLColor_Goldenrod ) 
public let LLColor16_Magenta = LLColorfto16( LLColor_Magenta ) 
public let LLColor16_Antiquewhite = LLColorfto16( LLColor_Antiquewhite ) 
public let LLColor16_Cornflowerblue = LLColorfto16( LLColor_Cornflowerblue ) 
public let LLColor16_Springgreen = LLColorfto16( LLColor_Springgreen ) 
public let LLColor16_Peru = LLColorfto16( LLColor_Peru ) 
public let LLColor16_Fuchsia = LLColorfto16( LLColor_Fuchsia ) 
public let LLColor16_Papayawhip = LLColorfto16( LLColor_Papayawhip ) 
public let LLColor16_Deepskyblue = LLColorfto16( LLColor_Deepskyblue ) 
public let LLColor16_Mediumspringgreen = LLColorfto16( LLColor_Mediumspringgreen ) 
public let LLColor16_Darkgoldenrod = LLColorfto16( LLColor_Darkgoldenrod ) 
public let LLColor16_Violet = LLColorfto16( LLColor_Violet ) 
public let LLColor16_Blanchedalmond = LLColorfto16( LLColor_Blanchedalmond ) 
public let LLColor16_Lightskyblue = LLColorfto16( LLColor_Lightskyblue ) 
public let LLColor16_Lawngreen = LLColorfto16( LLColor_Lawngreen ) 
public let LLColor16_Chocolate = LLColorfto16( LLColor_Chocolate ) 
public let LLColor16_Plum = LLColorfto16( LLColor_Plum ) 
public let LLColor16_Bisque = LLColorfto16( LLColor_Bisque ) 
public let LLColor16_Skyblue = LLColorfto16( LLColor_Skyblue ) 
public let LLColor16_Chartreuse = LLColorfto16( LLColor_Chartreuse ) 
public let LLColor16_Sienna = LLColorfto16( LLColor_Sienna ) 
public let LLColor16_Orchid = LLColorfto16( LLColor_Orchid ) 
public let LLColor16_Moccasin = LLColorfto16( LLColor_Moccasin ) 
public let LLColor16_Lightblue = LLColorfto16( LLColor_Lightblue ) 
public let LLColor16_Greenyellow = LLColorfto16( LLColor_Greenyellow ) 
public let LLColor16_Saddlebrown = LLColorfto16( LLColor_Saddlebrown ) 
public let LLColor16_Mediumorchid = LLColorfto16( LLColor_Mediumorchid ) 
public let LLColor16_Navajowhite = LLColorfto16( LLColor_Navajowhite ) 
public let LLColor16_Powderblue = LLColorfto16( LLColor_Powderblue ) 
public let LLColor16_Lime = LLColorfto16( LLColor_Lime ) 
public let LLColor16_Maroon = LLColorfto16( LLColor_Maroon ) 
public let LLColor16_Darkorchid = LLColorfto16( LLColor_Darkorchid ) 
public let LLColor16_Peachpuff = LLColorfto16( LLColor_Peachpuff ) 
public let LLColor16_Paleturquoise = LLColorfto16( LLColor_Paleturquoise ) 
public let LLColor16_Limegreen = LLColorfto16( LLColor_Limegreen ) 
public let LLColor16_Darkred = LLColorfto16( LLColor_Darkred ) 
public let LLColor16_Darkviolet = LLColorfto16( LLColor_Darkviolet ) 
public let LLColor16_Mistyrose = LLColorfto16( LLColor_Mistyrose ) 
public let LLColor16_Lightcyan = LLColorfto16( LLColor_Lightcyan ) 
public let LLColor16_Yellowgreen = LLColorfto16( LLColor_Yellowgreen ) 
public let LLColor16_Brown = LLColorfto16( LLColor_Brown ) 
public let LLColor16_Darkmagenta = LLColorfto16( LLColor_Darkmagenta ) 
public let LLColor16_Lavenderblush = LLColorfto16( LLColor_Lavenderblush ) 
public let LLColor16_Cyan = LLColorfto16( LLColor_Cyan ) 
public let LLColor16_Darkolivegreen = LLColorfto16( LLColor_Darkolivegreen ) 
public let LLColor16_Firebrick = LLColorfto16( LLColor_Firebrick ) 
public let LLColor16_Purple = LLColorfto16( LLColor_Purple ) 
public let LLColor16_Seashell = LLColorfto16( LLColor_Seashell ) 
public let LLColor16_Aqua = LLColorfto16( LLColor_Aqua ) 
public let LLColor16_Olivedrab = LLColorfto16( LLColor_Olivedrab ) 
public let LLColor16_Indianred = LLColorfto16( LLColor_Indianred ) 
public let LLColor16_Indigo = LLColorfto16( LLColor_Indigo ) 
public let LLColor16_Oldlace = LLColorfto16( LLColor_Oldlace ) 
public let LLColor16_Turquoise = LLColorfto16( LLColor_Turquoise ) 
public let LLColor16_Olive = LLColorfto16( LLColor_Olive ) 
public let LLColor16_Rosybrown = LLColorfto16( LLColor_Rosybrown ) 
public let LLColor16_Darkslateblue = LLColorfto16( LLColor_Darkslateblue ) 
public let LLColor16_Ivory = LLColorfto16( LLColor_Ivory ) 
public let LLColor16_Mediumturquoise = LLColorfto16( LLColor_Mediumturquoise ) 
public let LLColor16_Darkkhaki = LLColorfto16( LLColor_Darkkhaki ) 
public let LLColor16_Darksalmon = LLColorfto16( LLColor_Darksalmon ) 
public let LLColor16_Blueviolet = LLColorfto16( LLColor_Blueviolet ) 
public let LLColor16_Honeydew = LLColorfto16( LLColor_Honeydew ) 
public let LLColor16_Darkturquoise = LLColorfto16( LLColor_Darkturquoise ) 
public let LLColor16_Palegoldenrod = LLColorfto16( LLColor_Palegoldenrod ) 
public let LLColor16_Lightcoral = LLColorfto16( LLColor_Lightcoral ) 
public let LLColor16_Mediumpurple = LLColorfto16( LLColor_Mediumpurple ) 
public let LLColor16_Mintcream = LLColorfto16( LLColor_Mintcream ) 
public let LLColor16_Lightseagreen = LLColorfto16( LLColor_Lightseagreen ) 
public let LLColor16_Cornsilk = LLColorfto16( LLColor_Cornsilk ) 
public let LLColor16_Salmon = LLColorfto16( LLColor_Salmon ) 
public let LLColor16_Slateblue = LLColorfto16( LLColor_Slateblue ) 
public let LLColor16_Azure = LLColorfto16( LLColor_Azure ) 
public let LLColor16_Cadetblue = LLColorfto16( LLColor_Cadetblue ) 
public let LLColor16_Beige = LLColorfto16( LLColor_Beige ) 
public let LLColor16_Lightsalmon = LLColorfto16( LLColor_Lightsalmon ) 
public let LLColor16_Mediumslateblue = LLColorfto16( LLColor_Mediumslateblue )


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

public let LLColor8_Black = LLColorfto8( LLColor_Black ) 
public let LLColor8_Aliceblue = LLColorfto8( LLColor_Aliceblue ) 
public let LLColor8_Darkcyan = LLColorfto8( LLColor_Darkcyan ) 
public let LLColor8_Lightyellow = LLColorfto8( LLColor_Lightyellow ) 
public let LLColor8_Coral = LLColorfto8( LLColor_Coral ) 
public let LLColor8_Dimgray = LLColorfto8( LLColor_Dimgray ) 
public let LLColor8_Lavender = LLColorfto8( LLColor_Lavender ) 
public let LLColor8_Teal = LLColorfto8( LLColor_Teal ) 
public let LLColor8_Lightgoldenrodyellow = LLColorfto8( LLColor_Lightgoldenrodyellow ) 
public let LLColor8_Tomato = LLColorfto8( LLColor_Tomato ) 
public let LLColor8_Gray = LLColorfto8( LLColor_Gray ) 
public let LLColor8_Lightsteelblue = LLColorfto8( LLColor_Lightsteelblue ) 
public let LLColor8_Darkslategray = LLColorfto8( LLColor_Darkslategray ) 
public let LLColor8_Lemonchiffon = LLColorfto8( LLColor_Lemonchiffon ) 
public let LLColor8_Orangered = LLColorfto8( LLColor_Orangered ) 
public let LLColor8_Darkgray = LLColorfto8( LLColor_Darkgray ) 
public let LLColor8_Lightslategray = LLColorfto8( LLColor_Lightslategray ) 
public let LLColor8_Darkgreen = LLColorfto8( LLColor_Darkgreen ) 
public let LLColor8_Wheat = LLColorfto8( LLColor_Wheat ) 
public let LLColor8_Red = LLColorfto8( LLColor_Red ) 
public let LLColor8_Silver = LLColorfto8( LLColor_Silver ) 
public let LLColor8_Slategray = LLColorfto8( LLColor_Slategray ) 
public let LLColor8_Green = LLColorfto8( LLColor_Green ) 
public let LLColor8_Burlywood = LLColorfto8( LLColor_Burlywood ) 
public let LLColor8_Crimson = LLColorfto8( LLColor_Crimson ) 
public let LLColor8_Lightgray = LLColorfto8( LLColor_Lightgray ) 
public let LLColor8_Steelblue = LLColorfto8( LLColor_Steelblue ) 
public let LLColor8_Forestgreen = LLColorfto8( LLColor_Forestgreen ) 
public let LLColor8_Tan = LLColorfto8( LLColor_Tan ) 
public let LLColor8_Mediumvioletred = LLColorfto8( LLColor_Mediumvioletred ) 
public let LLColor8_Gainsboro = LLColorfto8( LLColor_Gainsboro ) 
public let LLColor8_Royalblue = LLColorfto8( LLColor_Royalblue ) 
public let LLColor8_Seagreen = LLColorfto8( LLColor_Seagreen ) 
public let LLColor8_Khaki = LLColorfto8( LLColor_Khaki ) 
public let LLColor8_Deeppink = LLColorfto8( LLColor_Deeppink ) 
public let LLColor8_Whitesmoke = LLColorfto8( LLColor_Whitesmoke ) 
public let LLColor8_Midnightblue = LLColorfto8( LLColor_Midnightblue ) 
public let LLColor8_Mediumseagreen = LLColorfto8( LLColor_Mediumseagreen ) 
public let LLColor8_Yellow = LLColorfto8( LLColor_Yellow ) 
public let LLColor8_Hotpink = LLColorfto8( LLColor_Hotpink ) 
public let LLColor8_White = LLColorfto8( LLColor_White ) 
public let LLColor8_Navy = LLColorfto8( LLColor_Navy ) 
public let LLColor8_Mediumaquamarine = LLColorfto8( LLColor_Mediumaquamarine ) 
public let LLColor8_Gold = LLColorfto8( LLColor_Gold ) 
public let LLColor8_Palevioletred = LLColorfto8( LLColor_Palevioletred ) 
public let LLColor8_Snow = LLColorfto8( LLColor_Snow ) 
public let LLColor8_Darkblue = LLColorfto8( LLColor_Darkblue ) 
public let LLColor8_Darkseagreen = LLColorfto8( LLColor_Darkseagreen ) 
public let LLColor8_Orange = LLColorfto8( LLColor_Orange ) 
public let LLColor8_Pink = LLColorfto8( LLColor_Pink ) 
public let LLColor8_Ghostwhite = LLColorfto8( LLColor_Ghostwhite ) 
public let LLColor8_Mediumblue = LLColorfto8( LLColor_Mediumblue ) 
public let LLColor8_Aquamarine = LLColorfto8( LLColor_Aquamarine ) 
public let LLColor8_Sandybrown = LLColorfto8( LLColor_Sandybrown ) 
public let LLColor8_Lightpink = LLColorfto8( LLColor_Lightpink ) 
public let LLColor8_Floralwhite = LLColorfto8( LLColor_Floralwhite ) 
public let LLColor8_Blue = LLColorfto8( LLColor_Blue ) 
public let LLColor8_Palegreen = LLColorfto8( LLColor_Palegreen ) 
public let LLColor8_Darkorange = LLColorfto8( LLColor_Darkorange ) 
public let LLColor8_Thistle = LLColorfto8( LLColor_Thistle ) 
public let LLColor8_Linen = LLColorfto8( LLColor_Linen ) 
public let LLColor8_Dodgerblue = LLColorfto8( LLColor_Dodgerblue ) 
public let LLColor8_Lightgreen = LLColorfto8( LLColor_Lightgreen ) 
public let LLColor8_Goldenrod = LLColorfto8( LLColor_Goldenrod ) 
public let LLColor8_Magenta = LLColorfto8( LLColor_Magenta ) 
public let LLColor8_Antiquewhite = LLColorfto8( LLColor_Antiquewhite ) 
public let LLColor8_Cornflowerblue = LLColorfto8( LLColor_Cornflowerblue ) 
public let LLColor8_Springgreen = LLColorfto8( LLColor_Springgreen ) 
public let LLColor8_Peru = LLColorfto8( LLColor_Peru ) 
public let LLColor8_Fuchsia = LLColorfto8( LLColor_Fuchsia ) 
public let LLColor8_Papayawhip = LLColorfto8( LLColor_Papayawhip ) 
public let LLColor8_Deepskyblue = LLColorfto8( LLColor_Deepskyblue ) 
public let LLColor8_Mediumspringgreen = LLColorfto8( LLColor_Mediumspringgreen ) 
public let LLColor8_Darkgoldenrod = LLColorfto8( LLColor_Darkgoldenrod ) 
public let LLColor8_Violet = LLColorfto8( LLColor_Violet ) 
public let LLColor8_Blanchedalmond = LLColorfto8( LLColor_Blanchedalmond ) 
public let LLColor8_Lightskyblue = LLColorfto8( LLColor_Lightskyblue ) 
public let LLColor8_Lawngreen = LLColorfto8( LLColor_Lawngreen ) 
public let LLColor8_Chocolate = LLColorfto8( LLColor_Chocolate ) 
public let LLColor8_Plum = LLColorfto8( LLColor_Plum ) 
public let LLColor8_Bisque = LLColorfto8( LLColor_Bisque ) 
public let LLColor8_Skyblue = LLColorfto8( LLColor_Skyblue ) 
public let LLColor8_Chartreuse = LLColorfto8( LLColor_Chartreuse ) 
public let LLColor8_Sienna = LLColorfto8( LLColor_Sienna ) 
public let LLColor8_Orchid = LLColorfto8( LLColor_Orchid ) 
public let LLColor8_Moccasin = LLColorfto8( LLColor_Moccasin ) 
public let LLColor8_Lightblue = LLColorfto8( LLColor_Lightblue ) 
public let LLColor8_Greenyellow = LLColorfto8( LLColor_Greenyellow ) 
public let LLColor8_Saddlebrown = LLColorfto8( LLColor_Saddlebrown ) 
public let LLColor8_Mediumorchid = LLColorfto8( LLColor_Mediumorchid ) 
public let LLColor8_Navajowhite = LLColorfto8( LLColor_Navajowhite ) 
public let LLColor8_Powderblue = LLColorfto8( LLColor_Powderblue ) 
public let LLColor8_Lime = LLColorfto8( LLColor_Lime ) 
public let LLColor8_Maroon = LLColorfto8( LLColor_Maroon ) 
public let LLColor8_Darkorchid = LLColorfto8( LLColor_Darkorchid ) 
public let LLColor8_Peachpuff = LLColorfto8( LLColor_Peachpuff ) 
public let LLColor8_Paleturquoise = LLColorfto8( LLColor_Paleturquoise ) 
public let LLColor8_Limegreen = LLColorfto8( LLColor_Limegreen ) 
public let LLColor8_Darkred = LLColorfto8( LLColor_Darkred ) 
public let LLColor8_Darkviolet = LLColorfto8( LLColor_Darkviolet ) 
public let LLColor8_Mistyrose = LLColorfto8( LLColor_Mistyrose ) 
public let LLColor8_Lightcyan = LLColorfto8( LLColor_Lightcyan ) 
public let LLColor8_Yellowgreen = LLColorfto8( LLColor_Yellowgreen ) 
public let LLColor8_Brown = LLColorfto8( LLColor_Brown ) 
public let LLColor8_Darkmagenta = LLColorfto8( LLColor_Darkmagenta ) 
public let LLColor8_Lavenderblush = LLColorfto8( LLColor_Lavenderblush ) 
public let LLColor8_Cyan = LLColorfto8( LLColor_Cyan ) 
public let LLColor8_Darkolivegreen = LLColorfto8( LLColor_Darkolivegreen ) 
public let LLColor8_Firebrick = LLColorfto8( LLColor_Firebrick ) 
public let LLColor8_Purple = LLColorfto8( LLColor_Purple ) 
public let LLColor8_Seashell = LLColorfto8( LLColor_Seashell ) 
public let LLColor8_Aqua = LLColorfto8( LLColor_Aqua ) 
public let LLColor8_Olivedrab = LLColorfto8( LLColor_Olivedrab ) 
public let LLColor8_Indianred = LLColorfto8( LLColor_Indianred ) 
public let LLColor8_Indigo = LLColorfto8( LLColor_Indigo ) 
public let LLColor8_Oldlace = LLColorfto8( LLColor_Oldlace ) 
public let LLColor8_Turquoise = LLColorfto8( LLColor_Turquoise ) 
public let LLColor8_Olive = LLColorfto8( LLColor_Olive ) 
public let LLColor8_Rosybrown = LLColorfto8( LLColor_Rosybrown ) 
public let LLColor8_Darkslateblue = LLColorfto8( LLColor_Darkslateblue ) 
public let LLColor8_Ivory = LLColorfto8( LLColor_Ivory ) 
public let LLColor8_Mediumturquoise = LLColorfto8( LLColor_Mediumturquoise ) 
public let LLColor8_Darkkhaki = LLColorfto8( LLColor_Darkkhaki ) 
public let LLColor8_Darksalmon = LLColorfto8( LLColor_Darksalmon ) 
public let LLColor8_Blueviolet = LLColorfto8( LLColor_Blueviolet ) 
public let LLColor8_Honeydew = LLColorfto8( LLColor_Honeydew ) 
public let LLColor8_Darkturquoise = LLColorfto8( LLColor_Darkturquoise ) 
public let LLColor8_Palegoldenrod = LLColorfto8( LLColor_Palegoldenrod ) 
public let LLColor8_Lightcoral = LLColorfto8( LLColor_Lightcoral ) 
public let LLColor8_Mediumpurple = LLColorfto8( LLColor_Mediumpurple ) 
public let LLColor8_Mintcream = LLColorfto8( LLColor_Mintcream ) 
public let LLColor8_Lightseagreen = LLColorfto8( LLColor_Lightseagreen ) 
public let LLColor8_Cornsilk = LLColorfto8( LLColor_Cornsilk ) 
public let LLColor8_Salmon = LLColorfto8( LLColor_Salmon ) 
public let LLColor8_Slateblue = LLColorfto8( LLColor_Slateblue ) 
public let LLColor8_Azure = LLColorfto8( LLColor_Azure ) 
public let LLColor8_Cadetblue = LLColorfto8( LLColor_Cadetblue ) 
public let LLColor8_Beige = LLColorfto8( LLColor_Beige ) 
public let LLColor8_Lightsalmon = LLColorfto8( LLColor_Lightsalmon ) 
public let LLColor8_Mediumslateblue = LLColorfto8( LLColor_Mediumslateblue ) 
