//
//  LLApplication.swift
//  LilyApp
//
//  Created by Kengo on 2018/08/16.
//  Copyright © 2018年 Watanabe-Denki Inc. All rights reserved.
//

import Foundation
import AppKit
import LilySwift

class Application: NSApplication, NSApplicationDelegate
{
    //private lazy var _menu = LLMenu()
    var wc:LLWindowController?
    lazy var vc = MyViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification)
    {
        /*
        let app_menu_item = LLMenuItem()

        let app_menu = LLMenu()
        app_menu.addItem( "Quit \(ProcessInfo.processInfo.processName)", keyEquivalent: "q")
        { [unowned self] in
            self.terminate(nil)
        }
        app_menu_item.submenu = app_menu
        _menu.addItem( app_menu_item )
        mainMenu = _menu
        */
        
        let window = LLWindow { me in
            me.rect = LLRect( 100, 20, 800, 822 )
            /*
            me.igWindow.close.connect( with:self ) { (self, arg) in
                self.terminate( nil )
            }
            */
        }
                
        wc = LLWindowController( window:window )
        vc.vcview.rect = window.contentBounds.llRect
        window.contentViewController = vc
         
        wc?.showWindow( nil )
    }
}

// TODO: ViewControllerアニメータをちゃんとつくりたい
class Animator : NSObject, NSViewControllerPresentationAnimator
{
    func animatePresentation(of viewController: NSViewController, from fromViewController: NSViewController) {
        let bottomVC = fromViewController
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        topVC.view.alphaValue = 0
        bottomVC.view.addSubview(topVC.view)
        var frame : CGRect = NSRectToCGRect(bottomVC.view.frame)
        frame = frame.insetBy(dx: 40, dy: 40)
        topVC.view.frame = NSRectFromCGRect(frame)
        let color: CGColor = NSColor.gray.cgColor
        topVC.view.layer?.backgroundColor = color
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 0.8

        }, completionHandler: nil)
    }
    
    func animateDismissal(of viewController: NSViewController, from fromViewController: NSViewController) {
        let topVC = viewController
        topVC.view.wantsLayer = true
        topVC.view.layerContentsRedrawPolicy = .onSetNeedsDisplay
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.5
            topVC.view.animator().alphaValue = 0
            }, completionHandler: {
                topVC.view.removeFromSuperview()
        })
    }
}

