//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import AppKit

private var __toolbaritem_callback = [NSToolbarItem:NSToolbarItem.Callback]()

public extension NSToolbarItem
{
    typealias Callback = (() -> Void)
    
    var callback:Callback? {
        get { return __toolbaritem_callback[self] }
        set {
            target = self
            action = #selector(objcActionHandler(_:))
            __toolbaritem_callback[self] = newValue
        }
    }
        
    @objc private func objcActionHandler( _ sender: NSControl ) {
        guard sender == self else { return }
        self.callback?()
    }
}

#endif
