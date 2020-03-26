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

import CoreGraphics

public extension CGColor
{
    var llColor:LLColor {
        var R:CGFloat = 0.0
        var G:CGFloat = 0.0
        var B:CGFloat = 0.0
        var A:CGFloat = 0.0
        
        #if os(iOS)
        UIColor( cgColor:self ).getRed( &R, green:&G, blue:&B, alpha: &A )
        return LLColor( R: R.f, G: G.f, B: B.f, A: A.f )    
        #elseif os(macOS)
        NSColor( cgColor:self )?.getRed( &R, green:&G, blue:&B, alpha: &A )
        return LLColor( R: R.f, G: G.f, B: B.f, A: A.f )
        #endif
    }
}
