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

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension LLColor8
{
    static var clear:Self { return LLColor8_Clear }
    
    static var black:Self { return LLColor8_Black }
    
    static var white:Self { return LLColor8_White }
    
    static var red:Self { return LLColor8_Red }
    
    static var green:Self { return LLColor8_Green }
    
    static var blue:Self  { return LLColor8_Blue }
    
    static var yellow:Self { return LLColor8_Yellow }
    
    static var cyan:Self { return LLColor8_Cyan }
    
    static var magenta:Self { return LLColor8_Magenta }
    
    static var darkGrey:Self { return LLColor8_DarkGrey }
    
    static var grey:Self { return LLColor8_Grey }
    
    static var lightGrey:Self { return LLColor8_LightGrey }
    
    //static var black:Self { return LLColor8_Black }
    static var aliceBlue:Self { return LLColor8_Aliceblue }
    static var darkCyan:Self { return LLColor8_Darkcyan }
    static var lightYellow:Self { return LLColor8_Lightyellow }
    static var coral:Self { return LLColor8_Coral }
    static var dimgray:Self { return LLColor8_Dimgray }
    static var lavender:Self { return LLColor8_Lavender }
    static var teal:Self { return LLColor8_Teal }
    static var lightGoldenrodYellow:Self { return LLColor8_Lightgoldenrodyellow }
    static var tomato:Self { return LLColor8_Tomato }
    static var gray:Self { return LLColor8_Gray }
    static var lightSteelBlue:Self { return LLColor8_Lightsteelblue }
    static var darkSlateGray:Self { return LLColor8_Darkslategray }
    static var lemonChiffon:Self { return LLColor8_Lemonchiffon }
    static var orangered:Self { return LLColor8_Orangered }
    static var darkGray:Self { return LLColor8_Darkgray }
    static var lightSlateGray:Self { return LLColor8_Lightslategray }
    static var darkGreen:Self { return LLColor8_Darkgreen }
    static var wheat:Self { return LLColor8_Wheat }
    //static var red:Self { return LLColor8_Red }
    static var silver:Self { return LLColor8_Silver }
    static var slateGray:Self { return LLColor8_Slategray }
    //static var green:Self { return LLColor8_Green }
    static var burlyWood:Self { return LLColor8_Burlywood }
    static var crimson:Self { return LLColor8_Crimson }
    static var lightGray:Self { return LLColor8_Lightgray }
    static var steelBlue:Self { return LLColor8_Steelblue }
    static var forestGreen:Self { return LLColor8_Forestgreen }
    static var tan:Self { return LLColor8_Tan }
    static var mediumVioletred:Self { return LLColor8_Mediumvioletred }
    static var gainsboro:Self { return LLColor8_Gainsboro }
    static var royalBlue:Self { return LLColor8_Royalblue }
    static var seaGreen:Self { return LLColor8_Seagreen }
    static var khaki:Self { return LLColor8_Khaki }
    static var deepPink:Self { return LLColor8_Deeppink }
    static var whiteSmoke:Self { return LLColor8_Whitesmoke }
    static var midnightBlue:Self { return LLColor8_Midnightblue }
    static var mediumSeaGreen:Self { return LLColor8_Mediumseagreen }
    //static var yellow:Self { return LLColor8_Yellow }
    static var hotPink:Self { return LLColor8_Hotpink }
    //static var white:Self { return LLColor8_White }
    static var navy:Self { return LLColor8_Navy }
    static var mediumAquamarine:Self { return LLColor8_Mediumaquamarine }
    static var gold:Self { return LLColor8_Gold }
    static var paleVioletred:Self { return LLColor8_Palevioletred }
    static var snow:Self { return LLColor8_Snow }
    static var darkBlue:Self { return LLColor8_Darkblue }
    static var darkSeaGreen:Self { return LLColor8_Darkseagreen }
    static var orange:Self { return LLColor8_Orange }
    static var pink:Self { return LLColor8_Pink }
    static var ghostWhite:Self { return LLColor8_Ghostwhite }
    static var mediumBlue:Self { return LLColor8_Mediumblue }
    static var aquamarine:Self { return LLColor8_Aquamarine }
    static var sandyBrown:Self { return LLColor8_Sandybrown }
    static var lightPink:Self { return LLColor8_Lightpink }
    static var floralWhite:Self { return LLColor8_Floralwhite }
    //static var blue:Self { return LLColor8_Blue }
    static var paleGreen:Self { return LLColor8_Palegreen }
    static var darkOrange:Self { return LLColor8_Darkorange }
    static var thistle:Self { return LLColor8_Thistle }
    static var linen:Self { return LLColor8_Linen }
    static var dodgerBlue:Self { return LLColor8_Dodgerblue }
    static var lightGreen:Self { return LLColor8_Lightgreen }
    static var goldenrod:Self { return LLColor8_Goldenrod }
    //static var magenta:Self { return LLColor8_Magenta }
    static var antiqueWhite:Self { return LLColor8_Antiquewhite }
    static var cornflowerBlue:Self { return LLColor8_Cornflowerblue }
    static var springGreen:Self { return LLColor8_Springgreen }
    static var peru:Self { return LLColor8_Peru }
    static var fuchsia:Self { return LLColor8_Fuchsia }
    static var papayawhip:Self { return LLColor8_Papayawhip }
    static var deepSkyBlue:Self { return LLColor8_Deepskyblue }
    static var mediumSpringGreen:Self { return LLColor8_Mediumspringgreen }
    static var darkGoldenrod:Self { return LLColor8_Darkgoldenrod }
    static var violet:Self { return LLColor8_Violet }
    static var blanchedAlmond:Self { return LLColor8_Blanchedalmond }
    static var lightSkyBlue:Self { return LLColor8_Lightskyblue }
    static var lawnGreen:Self { return LLColor8_Lawngreen }
    static var chocolate:Self { return LLColor8_Chocolate }
    static var plum:Self { return LLColor8_Plum }
    static var bisque:Self { return LLColor8_Bisque }
    static var skyBlue:Self { return LLColor8_Skyblue }
    static var chartreuse:Self { return LLColor8_Chartreuse }
    static var sienna:Self { return LLColor8_Sienna }
    static var orchid:Self { return LLColor8_Orchid }
    static var moccasin:Self { return LLColor8_Moccasin }
    static var lightBlue:Self { return LLColor8_Lightblue }
    static var greenYellow:Self { return LLColor8_Greenyellow }
    static var saddleBrown:Self { return LLColor8_Saddlebrown }
    static var mediumOrchid:Self { return LLColor8_Mediumorchid }
    static var navajoWhite:Self { return LLColor8_Navajowhite }
    static var powderBlue:Self { return LLColor8_Powderblue }
    static var lime:Self { return LLColor8_Lime }
    static var maroon:Self { return LLColor8_Maroon }
    static var darkOrchid:Self { return LLColor8_Darkorchid }
    static var peachPuff:Self { return LLColor8_Peachpuff }
    static var paleturquoise:Self { return LLColor8_Paleturquoise }
    static var limeGreen:Self { return LLColor8_Limegreen }
    static var darkred:Self { return LLColor8_Darkred }
    static var darkViolet:Self { return LLColor8_Darkviolet }
    static var mistyRose:Self { return LLColor8_Mistyrose }
    static var lightCyan:Self { return LLColor8_Lightcyan }
    static var yellowGreen:Self { return LLColor8_Yellowgreen }
    static var brown:Self { return LLColor8_Brown }
    static var darkMagenta:Self { return LLColor8_Darkmagenta }
    static var lavenderBlush:Self { return LLColor8_Lavenderblush }
    //static var cyan:Self { return LLColor8_Cyan }
    static var darkOliveGreen:Self { return LLColor8_Darkolivegreen }
    static var firebrick:Self { return LLColor8_Firebrick }
    static var purple:Self { return LLColor8_Purple }
    static var seashell:Self { return LLColor8_Seashell }
    static var aqua:Self { return LLColor8_Aqua }
    static var olivedrab:Self { return LLColor8_Olivedrab }
    static var indianred:Self { return LLColor8_Indianred }
    static var indigo:Self { return LLColor8_Indigo }
    static var oldlace:Self { return LLColor8_Oldlace }
    static var turquoise:Self { return LLColor8_Turquoise }
    static var olive:Self { return LLColor8_Olive }
    static var rosyBrown:Self { return LLColor8_Rosybrown }
    static var darkSlateBlue:Self { return LLColor8_Darkslateblue }
    static var ivory:Self { return LLColor8_Ivory }
    static var mediumTurquoise:Self { return LLColor8_Mediumturquoise }
    static var darkKhaki:Self { return LLColor8_Darkkhaki }
    static var darkSalmon:Self { return LLColor8_Darksalmon }
    static var blueViolet:Self { return LLColor8_Blueviolet }
    static var honeydew:Self { return LLColor8_Honeydew }
    static var darkTurquoise:Self { return LLColor8_Darkturquoise }
    static var paleGoldenrod:Self { return LLColor8_Palegoldenrod }
    static var lightCoral:Self { return LLColor8_Lightcoral }
    static var mediumPurple:Self { return LLColor8_Mediumpurple }
    static var mintCream:Self { return LLColor8_Mintcream }
    static var lightSeaGreen:Self { return LLColor8_Lightseagreen }
    static var cornSilk:Self { return LLColor8_Cornsilk }
    static var salmon:Self { return LLColor8_Salmon }
    static var slateBlue:Self { return LLColor8_Slateblue }
    static var azure:Self { return LLColor8_Azure }
    static var cadetBlue:Self { return LLColor8_Cadetblue }
    static var beige:Self { return LLColor8_Beige }
    static var lightSalmon:Self { return LLColor8_Lightsalmon }
    static var mediumSlateBlue:Self { return LLColor8_Mediumslateblue }
}

public extension LLColor16
{
    static var clear:Self { return LLColor16_Clear }
    
    static var black:Self { return LLColor16_Black }
    
    static var white:Self { return LLColor16_White }
    
    static var red:Self { return LLColor16_Red }
    
    static var green:Self { return LLColor16_Green }
    
    static var blue:Self  { return LLColor16_Blue }
    
    static var yellow:Self { return LLColor16_Yellow }
    
    static var cyan:Self { return LLColor16_Cyan }
    
    static var magenta:Self { return LLColor16_Magenta }
    
    static var darkGrey:Self { return LLColor16_DarkGrey }
    
    static var grey:Self { return LLColor16_Grey }
    
    static var lightGrey:Self { return LLColor16_LightGrey }
    
    //static var black:Self { return LLColor16_Black }
    static var aliceBlue:Self { return LLColor16_Aliceblue }
    static var darkCyan:Self { return LLColor16_Darkcyan }
    static var lightYellow:Self { return LLColor16_Lightyellow }
    static var coral:Self { return LLColor16_Coral }
    static var dimgray:Self { return LLColor16_Dimgray }
    static var lavender:Self { return LLColor16_Lavender }
    static var teal:Self { return LLColor16_Teal }
    static var lightGoldenrodYellow:Self { return LLColor16_Lightgoldenrodyellow }
    static var tomato:Self { return LLColor16_Tomato }
    static var gray:Self { return LLColor16_Gray }
    static var lightSteelBlue:Self { return LLColor16_Lightsteelblue }
    static var darkSlateGray:Self { return LLColor16_Darkslategray }
    static var lemonChiffon:Self { return LLColor16_Lemonchiffon }
    static var orangered:Self { return LLColor16_Orangered }
    static var darkGray:Self { return LLColor16_Darkgray }
    static var lightSlateGray:Self { return LLColor16_Lightslategray }
    static var darkGreen:Self { return LLColor16_Darkgreen }
    static var wheat:Self { return LLColor16_Wheat }
    //static var red:Self { return LLColor16_Red }
    static var silver:Self { return LLColor16_Silver }
    static var slateGray:Self { return LLColor16_Slategray }
    //static var green:Self { return LLColor16_Green }
    static var burlyWood:Self { return LLColor16_Burlywood }
    static var crimson:Self { return LLColor16_Crimson }
    static var lightGray:Self { return LLColor16_Lightgray }
    static var steelBlue:Self { return LLColor16_Steelblue }
    static var forestGreen:Self { return LLColor16_Forestgreen }
    static var tan:Self { return LLColor16_Tan }
    static var mediumVioletred:Self { return LLColor16_Mediumvioletred }
    static var gainsboro:Self { return LLColor16_Gainsboro }
    static var royalBlue:Self { return LLColor16_Royalblue }
    static var seaGreen:Self { return LLColor16_Seagreen }
    static var khaki:Self { return LLColor16_Khaki }
    static var deepPink:Self { return LLColor16_Deeppink }
    static var whiteSmoke:Self { return LLColor16_Whitesmoke }
    static var midnightBlue:Self { return LLColor16_Midnightblue }
    static var mediumSeaGreen:Self { return LLColor16_Mediumseagreen }
    //static var yellow:Self { return LLColor16_Yellow }
    static var hotPink:Self { return LLColor16_Hotpink }
    //static var white:Self { return LLColor16_White }
    static var navy:Self { return LLColor16_Navy }
    static var mediumAquamarine:Self { return LLColor16_Mediumaquamarine }
    static var gold:Self { return LLColor16_Gold }
    static var paleVioletred:Self { return LLColor16_Palevioletred }
    static var snow:Self { return LLColor16_Snow }
    static var darkBlue:Self { return LLColor16_Darkblue }
    static var darkSeaGreen:Self { return LLColor16_Darkseagreen }
    static var orange:Self { return LLColor16_Orange }
    static var pink:Self { return LLColor16_Pink }
    static var ghostWhite:Self { return LLColor16_Ghostwhite }
    static var mediumBlue:Self { return LLColor16_Mediumblue }
    static var aquamarine:Self { return LLColor16_Aquamarine }
    static var sandyBrown:Self { return LLColor16_Sandybrown }
    static var lightPink:Self { return LLColor16_Lightpink }
    static var floralWhite:Self { return LLColor16_Floralwhite }
    //static var blue:Self { return LLColor16_Blue }
    static var paleGreen:Self { return LLColor16_Palegreen }
    static var darkOrange:Self { return LLColor16_Darkorange }
    static var thistle:Self { return LLColor16_Thistle }
    static var linen:Self { return LLColor16_Linen }
    static var dodgerBlue:Self { return LLColor16_Dodgerblue }
    static var lightGreen:Self { return LLColor16_Lightgreen }
    static var goldenrod:Self { return LLColor16_Goldenrod }
    //static var magenta:Self { return LLColor16_Magenta }
    static var antiqueWhite:Self { return LLColor16_Antiquewhite }
    static var cornflowerBlue:Self { return LLColor16_Cornflowerblue }
    static var springGreen:Self { return LLColor16_Springgreen }
    static var peru:Self { return LLColor16_Peru }
    static var fuchsia:Self { return LLColor16_Fuchsia }
    static var papayawhip:Self { return LLColor16_Papayawhip }
    static var deepSkyBlue:Self { return LLColor16_Deepskyblue }
    static var mediumSpringGreen:Self { return LLColor16_Mediumspringgreen }
    static var darkGoldenrod:Self { return LLColor16_Darkgoldenrod }
    static var violet:Self { return LLColor16_Violet }
    static var blanchedAlmond:Self { return LLColor16_Blanchedalmond }
    static var lightSkyBlue:Self { return LLColor16_Lightskyblue }
    static var lawnGreen:Self { return LLColor16_Lawngreen }
    static var chocolate:Self { return LLColor16_Chocolate }
    static var plum:Self { return LLColor16_Plum }
    static var bisque:Self { return LLColor16_Bisque }
    static var skyBlue:Self { return LLColor16_Skyblue }
    static var chartreuse:Self { return LLColor16_Chartreuse }
    static var sienna:Self { return LLColor16_Sienna }
    static var orchid:Self { return LLColor16_Orchid }
    static var moccasin:Self { return LLColor16_Moccasin }
    static var lightBlue:Self { return LLColor16_Lightblue }
    static var greenYellow:Self { return LLColor16_Greenyellow }
    static var saddleBrown:Self { return LLColor16_Saddlebrown }
    static var mediumOrchid:Self { return LLColor16_Mediumorchid }
    static var navajoWhite:Self { return LLColor16_Navajowhite }
    static var powderBlue:Self { return LLColor16_Powderblue }
    static var lime:Self { return LLColor16_Lime }
    static var maroon:Self { return LLColor16_Maroon }
    static var darkOrchid:Self { return LLColor16_Darkorchid }
    static var peachPuff:Self { return LLColor16_Peachpuff }
    static var paleturquoise:Self { return LLColor16_Paleturquoise }
    static var limeGreen:Self { return LLColor16_Limegreen }
    static var darkred:Self { return LLColor16_Darkred }
    static var darkViolet:Self { return LLColor16_Darkviolet }
    static var mistyRose:Self { return LLColor16_Mistyrose }
    static var lightCyan:Self { return LLColor16_Lightcyan }
    static var yellowGreen:Self { return LLColor16_Yellowgreen }
    static var brown:Self { return LLColor16_Brown }
    static var darkMagenta:Self { return LLColor16_Darkmagenta }
    static var lavenderBlush:Self { return LLColor16_Lavenderblush }
    //static var cyan:Self { return LLColor16_Cyan }
    static var darkOliveGreen:Self { return LLColor16_Darkolivegreen }
    static var firebrick:Self { return LLColor16_Firebrick }
    static var purple:Self { return LLColor16_Purple }
    static var seashell:Self { return LLColor16_Seashell }
    static var aqua:Self { return LLColor16_Aqua }
    static var olivedrab:Self { return LLColor16_Olivedrab }
    static var indianred:Self { return LLColor16_Indianred }
    static var indigo:Self { return LLColor16_Indigo }
    static var oldlace:Self { return LLColor16_Oldlace }
    static var turquoise:Self { return LLColor16_Turquoise }
    static var olive:Self { return LLColor16_Olive }
    static var rosyBrown:Self { return LLColor16_Rosybrown }
    static var darkSlateBlue:Self { return LLColor16_Darkslateblue }
    static var ivory:Self { return LLColor16_Ivory }
    static var mediumTurquoise:Self { return LLColor16_Mediumturquoise }
    static var darkKhaki:Self { return LLColor16_Darkkhaki }
    static var darkSalmon:Self { return LLColor16_Darksalmon }
    static var blueViolet:Self { return LLColor16_Blueviolet }
    static var honeydew:Self { return LLColor16_Honeydew }
    static var darkTurquoise:Self { return LLColor16_Darkturquoise }
    static var paleGoldenrod:Self { return LLColor16_Palegoldenrod }
    static var lightCoral:Self { return LLColor16_Lightcoral }
    static var mediumPurple:Self { return LLColor16_Mediumpurple }
    static var mintCream:Self { return LLColor16_Mintcream }
    static var lightSeaGreen:Self { return LLColor16_Lightseagreen }
    static var cornSilk:Self { return LLColor16_Cornsilk }
    static var salmon:Self { return LLColor16_Salmon }
    static var slateBlue:Self { return LLColor16_Slateblue }
    static var azure:Self { return LLColor16_Azure }
    static var cadetBlue:Self { return LLColor16_Cadetblue }
    static var beige:Self { return LLColor16_Beige }
    static var lightSalmon:Self { return LLColor16_Lightsalmon }
    static var mediumSlateBlue:Self { return LLColor16_Mediumslateblue }
}

public extension LLColor
{        
    static var clear:Self { return LLColor_Clear }
    
    static var black:Self { return LLColor_Black }
    
    static var white:Self { return LLColor_White }
    
    static var red:Self   { return LLColor_Red }
    
    static var green:Self { return LLColor_Green }
    
    static var blue:Self  { return LLColor_Blue }
    
    static var yellow:Self { return LLColor_Yellow }
    
    static var cyan:Self { return LLColor_Cyan }
    
    static var magenta:Self { return LLColor_Magenta }
    
    static var darkGrey:Self { return LLColor_DarkGrey }
    
    static var grey:Self { return LLColor_Grey }
    
    static var lightGrey:Self { return LLColor_LightGrey }
    
    // TOOD: webカラー定義
    //static var black:Self { return LLColor_Black }
    static var aliceBlue:Self { return LLColor_Aliceblue }
    static var darkCyan:Self { return LLColor_Darkcyan }
    static var lightYellow:Self { return LLColor_Lightyellow }
    static var coral:Self { return LLColor_Coral }
    static var dimgray:Self { return LLColor_Dimgray }
    static var lavender:Self { return LLColor_Lavender }
    static var teal:Self { return LLColor_Teal }
    static var lightGoldenrodYellow:Self { return LLColor_Lightgoldenrodyellow }
    static var tomato:Self { return LLColor_Tomato }
    static var gray:Self { return LLColor_Gray }
    static var lightSteelBlue:Self { return LLColor_Lightsteelblue }
    static var darkSlateGray:Self { return LLColor_Darkslategray }
    static var lemonChiffon:Self { return LLColor_Lemonchiffon }
    static var orangered:Self { return LLColor_Orangered }
    static var darkGray:Self { return LLColor_Darkgray }
    static var lightSlateGray:Self { return LLColor_Lightslategray }
    static var darkGreen:Self { return LLColor_Darkgreen }
    static var wheat:Self { return LLColor_Wheat }
    //static var red:Self { return LLColor_Red }
    static var silver:Self { return LLColor_Silver }
    static var slateGray:Self { return LLColor_Slategray }
    //static var green:Self { return LLColor_Green }
    static var burlyWood:Self { return LLColor_Burlywood }
    static var crimson:Self { return LLColor_Crimson }
    static var lightGray:Self { return LLColor_Lightgray }
    static var steelBlue:Self { return LLColor_Steelblue }
    static var forestGreen:Self { return LLColor_Forestgreen }
    static var tan:Self { return LLColor_Tan }
    static var mediumVioletred:Self { return LLColor_Mediumvioletred }
    static var gainsboro:Self { return LLColor_Gainsboro }
    static var royalBlue:Self { return LLColor_Royalblue }
    static var seaGreen:Self { return LLColor_Seagreen }
    static var khaki:Self { return LLColor_Khaki }
    static var deepPink:Self { return LLColor_Deeppink }
    static var whiteSmoke:Self { return LLColor_Whitesmoke }
    static var midnightBlue:Self { return LLColor_Midnightblue }
    static var mediumSeaGreen:Self { return LLColor_Mediumseagreen }
    //static var yellow:Self { return LLColor_Yellow }
    static var hotPink:Self { return LLColor_Hotpink }
    //static var white:Self { return LLColor_White }
    static var navy:Self { return LLColor_Navy }
    static var mediumAquamarine:Self { return LLColor_Mediumaquamarine }
    static var gold:Self { return LLColor_Gold }
    static var paleVioletred:Self { return LLColor_Palevioletred }
    static var snow:Self { return LLColor_Snow }
    static var darkBlue:Self { return LLColor_Darkblue }
    static var darkSeaGreen:Self { return LLColor_Darkseagreen }
    static var orange:Self { return LLColor_Orange }
    static var pink:Self { return LLColor_Pink }
    static var ghostWhite:Self { return LLColor_Ghostwhite }
    static var mediumBlue:Self { return LLColor_Mediumblue }
    static var aquamarine:Self { return LLColor_Aquamarine }
    static var sandyBrown:Self { return LLColor_Sandybrown }
    static var lightPink:Self { return LLColor_Lightpink }
    static var floralWhite:Self { return LLColor_Floralwhite }
    //static var blue:Self { return LLColor_Blue }
    static var paleGreen:Self { return LLColor_Palegreen }
    static var darkOrange:Self { return LLColor_Darkorange }
    static var thistle:Self { return LLColor_Thistle }
    static var linen:Self { return LLColor_Linen }
    static var dodgerBlue:Self { return LLColor_Dodgerblue }
    static var lightGreen:Self { return LLColor_Lightgreen }
    static var goldenrod:Self { return LLColor_Goldenrod }
    //static var magenta:Self { return LLColor_Magenta }
    static var antiqueWhite:Self { return LLColor_Antiquewhite }
    static var cornflowerBlue:Self { return LLColor_Cornflowerblue }
    static var springGreen:Self { return LLColor_Springgreen }
    static var peru:Self { return LLColor_Peru }
    static var fuchsia:Self { return LLColor_Fuchsia }
    static var papayawhip:Self { return LLColor_Papayawhip }
    static var deepSkyBlue:Self { return LLColor_Deepskyblue }
    static var mediumSpringGreen:Self { return LLColor_Mediumspringgreen }
    static var darkGoldenrod:Self { return LLColor_Darkgoldenrod }
    static var violet:Self { return LLColor_Violet }
    static var blanchedAlmond:Self { return LLColor_Blanchedalmond }
    static var lightSkyBlue:Self { return LLColor_Lightskyblue }
    static var lawnGreen:Self { return LLColor_Lawngreen }
    static var chocolate:Self { return LLColor_Chocolate }
    static var plum:Self { return LLColor_Plum }
    static var bisque:Self { return LLColor_Bisque }
    static var skyBlue:Self { return LLColor_Skyblue }
    static var chartreuse:Self { return LLColor_Chartreuse }
    static var sienna:Self { return LLColor_Sienna }
    static var orchid:Self { return LLColor_Orchid }
    static var moccasin:Self { return LLColor_Moccasin }
    static var lightBlue:Self { return LLColor_Lightblue }
    static var greenYellow:Self { return LLColor_Greenyellow }
    static var saddleBrown:Self { return LLColor_Saddlebrown }
    static var mediumOrchid:Self { return LLColor_Mediumorchid }
    static var navajoWhite:Self { return LLColor_Navajowhite }
    static var powderBlue:Self { return LLColor_Powderblue }
    static var lime:Self { return LLColor_Lime }
    static var maroon:Self { return LLColor_Maroon }
    static var darkOrchid:Self { return LLColor_Darkorchid }
    static var peachPuff:Self { return LLColor_Peachpuff }
    static var paleturquoise:Self { return LLColor_Paleturquoise }
    static var limeGreen:Self { return LLColor_Limegreen }
    static var darkred:Self { return LLColor_Darkred }
    static var darkViolet:Self { return LLColor_Darkviolet }
    static var mistyRose:Self { return LLColor_Mistyrose }
    static var lightCyan:Self { return LLColor_Lightcyan }
    static var yellowGreen:Self { return LLColor_Yellowgreen }
    static var brown:Self { return LLColor_Brown }
    static var darkMagenta:Self { return LLColor_Darkmagenta }
    static var lavenderBlush:Self { return LLColor_Lavenderblush }
    //static var cyan:Self { return LLColor_Cyan }
    static var darkOliveGreen:Self { return LLColor_Darkolivegreen }
    static var firebrick:Self { return LLColor_Firebrick }
    static var purple:Self { return LLColor_Purple }
    static var seashell:Self { return LLColor_Seashell }
    static var aqua:Self { return LLColor_Aqua }
    static var olivedrab:Self { return LLColor_Olivedrab }
    static var indianred:Self { return LLColor_Indianred }
    static var indigo:Self { return LLColor_Indigo }
    static var oldlace:Self { return LLColor_Oldlace }
    static var turquoise:Self { return LLColor_Turquoise }
    static var olive:Self { return LLColor_Olive }
    static var rosyBrown:Self { return LLColor_Rosybrown }
    static var darkSlateBlue:Self { return LLColor_Darkslateblue }
    static var ivory:Self { return LLColor_Ivory }
    static var mediumTurquoise:Self { return LLColor_Mediumturquoise }
    static var darkKhaki:Self { return LLColor_Darkkhaki }
    static var darkSalmon:Self { return LLColor_Darksalmon }
    static var blueViolet:Self { return LLColor_Blueviolet }
    static var honeydew:Self { return LLColor_Honeydew }
    static var darkTurquoise:Self { return LLColor_Darkturquoise }
    static var paleGoldenrod:Self { return LLColor_Palegoldenrod }
    static var lightCoral:Self { return LLColor_Lightcoral }
    static var mediumPurple:Self { return LLColor_Mediumpurple }
    static var mintCream:Self { return LLColor_Mintcream }
    static var lightSeaGreen:Self { return LLColor_Lightseagreen }
    static var cornSilk:Self { return LLColor_Cornsilk }
    static var salmon:Self { return LLColor_Salmon }
    static var slateBlue:Self { return LLColor_Slateblue }
    static var azure:Self { return LLColor_Azure }
    static var cadetBlue:Self { return LLColor_Cadetblue }
    static var beige:Self { return LLColor_Beige }
    static var lightSalmon:Self { return LLColor_Lightsalmon }
    static var mediumSlateBlue:Self { return LLColor_Mediumslateblue }
}
