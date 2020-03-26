//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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
}
