//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(macOS)

import AppKit

public extension NSColor
{
    convenience init( _ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat ) {
        self.init( red:r, green:g, blue:b, alpha:a )
    }
    
    convenience init( _ llColor8:LLColor8 ) {
        self.init( red:   llColor8.R.cgf / LLColor8_MaxValue.cgf,
                   green: llColor8.G.cgf / LLColor8_MaxValue.cgf,
                   blue:  llColor8.B.cgf / LLColor8_MaxValue.cgf,
                   alpha: llColor8.A.cgf / LLColor8_MaxValue.cgf )
    }
    
    convenience init( _ llColor16:LLColor16 ) {
        self.init( red:   llColor16.R.cgf / LLColor16_MaxValue.cgf,
                   green: llColor16.G.cgf / LLColor16_MaxValue.cgf,
                   blue:  llColor16.B.cgf / LLColor16_MaxValue.cgf,
                   alpha: llColor16.A.cgf / LLColor16_MaxValue.cgf )
    }
    
    convenience init( _ llColor:LLColor ) {
        self.init( red:   llColor.R.cgf / LLColor_MaxValue.cgf,
                   green: llColor.G.cgf / LLColor_MaxValue.cgf,
                   blue:  llColor.B.cgf / LLColor_MaxValue.cgf,
                   alpha: llColor.A.cgf / LLColor_MaxValue.cgf )
    }

    convenience init( _ hex:String ) {
        self.init( LLHexColor8( hex.lcStr ) )
    }

    var llColor8:LLColor8 { LLColor8( self ) }
    
    var llColor16:LLColor16 { LLColor16( self ) }
    
    var llColor:LLColor { LLColor( self ) }
}

#endif
