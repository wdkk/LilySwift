//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//


import Foundation
import AppKit
import LilySwift

class Application
: NSApplication
, NSApplicationDelegate
{
    var wc:Lily.View.WindowController?
    lazy var vc = DevViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {        
        let window = Lily.View.Window { me in
            me.rect = LLRect( 0, 0, 800, 822 )
        }
        
        window.didChangeScreen = { [weak self] window in
            self?.vc.rebuild()
        }
        
        wc = Lily.View.WindowController( window:window )
        vc.rect = window.contentBounds.llRect
        window.contentViewController = vc
        
        wc?.showWindow( nil )
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { true }
}
