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

private var __menuitem_callback = [NSMenuItem:NSMenuItem.Callback]()

public extension NSMenuItem
{
    typealias Callback = (() -> Void)
    
    var callback:Callback? {
        get {
            return __menuitem_callback[self]
        }
        set {
            target = self
            action = #selector( objcActionHandler(_:) )
            __menuitem_callback[self] = newValue
        }
    }
    
    convenience init(_ title:String, keyEquivalent: String, callback f: Callback? ) {
        self.init( title: title, action: nil, keyEquivalent: keyEquivalent )
        self.callback = f
    }
    
    @objc private func objcActionHandler( _ sender: NSControl ) {
        guard sender == self else { return }
        self.callback?()
    }
}

public typealias LLMenuItem = NSMenuItem

#endif
