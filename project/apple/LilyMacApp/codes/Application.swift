//
//  LLApplication.swift
//  LilyApp
//
//  Created by Kengo on 2018/08/16.
//  Copyright © 2018年 Watanabe-DENKI Inc. All rights reserved.
//

import Foundation
import AppKit
import LilySwift

class Application: NSApplication, NSApplicationDelegate
{
    private lazy var _myvc = MyViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        let window = LLWindow { me in
            me.rect = LLRect( 100, 100, 800, 800 )
        }
                
        let wc = LLWindowController( window:window )
        _myvc.vcview.rect = window.contentBounds.llRect
        window.contentViewController = _myvc
        
        wc.showWindow( nil )
    }
}

