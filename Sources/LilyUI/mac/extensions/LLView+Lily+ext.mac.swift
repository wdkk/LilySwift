//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Cocoa

public extension LLView 
{
    func rebuildChildren() {
        // CALayer側
        guard let sublayers = self.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }

    func teardownChildren() {
        // CALayer側
        guard let sublayers = self.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
}

#endif
