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

#if os(macOS)

import AppKit

public extension LLColor8
{
    init( _ nsColor:NSColor ) {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        nsColor.getRed( &r, green: &g, blue: &b, alpha: &a )
        self.init(R: (r * 255.0).u8!, G: (g * 255.0).u8!, B: (b * 255.0).u8!, A: (a * 255.0).u8! )
    }
    
    var nsColor:NSColor { NSColor( self ) }
}

public extension LLColor16
{
    init( _ nsColor:NSColor ) {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        nsColor.getRed( &r, green: &g, blue: &b, alpha: &a )
        self.init(R: (r * 65535.0).u16!, G: (g * 65535.0).u16!, B: (b * 65535.0).u16!, A: (a * 65535.0).u16! )
    }
    
    var nsColor:NSColor { NSColor( self ) }
}

public extension LLColor
{
    init( _ nsColor:NSColor ) {
        var r:CGFloat = 0.0
        var g:CGFloat = 0.0
        var b:CGFloat = 0.0
        var a:CGFloat = 0.0
        nsColor.getRed( &r, green: &g, blue: &b, alpha: &a )
        self.init(R: r.f, G: g.f, B: b.f, A: a.f)
    }
    
    var nsColor:NSColor { NSColor( self ) }
}

#endif
