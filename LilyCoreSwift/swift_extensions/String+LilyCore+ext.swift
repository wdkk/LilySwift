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

#if LILY_FULL

import Foundation

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

public extension String 
{
    func pixelSize( attr textAttr:LCTextAttributeSmPtr ) -> LLSize { 
        return LCStringPixelSize( self.lcStr, textAttr )
    }
}

#endif
