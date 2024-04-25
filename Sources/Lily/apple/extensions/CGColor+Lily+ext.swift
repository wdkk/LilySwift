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
#else
import UIKit
#endif

import CoreGraphics

public extension CGColor
{
    var llColor:LLColor {
        var R:CGFloat = 0.0
        var G:CGFloat = 0.0
        var B:CGFloat = 0.0
        var A:CGFloat = 0.0
        
        #if os(macOS)
        NSColor( cgColor:self )?.getRed( &R, green:&G, blue:&B, alpha: &A )
        #else
        UIColor( cgColor:self ).getRed( &R, green:&G, blue:&B, alpha: &A )        
        #endif
        return LLColor( R: R.f, G: G.f, B: B.f, A: A.f )
    }
}
