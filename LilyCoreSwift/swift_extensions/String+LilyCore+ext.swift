//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

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
