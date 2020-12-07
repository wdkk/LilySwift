//
// LLWindow.swift
// Lily Library
//
// Copyright (c) 2017- Watanabe-Denki Inc.
//   https://wdkk.co.jp/
//

import Foundation
import Cocoa

open class LLWindow : NSWindow, NSWindowDelegate
{
    public convenience init( f:(LLWindow)->Void ) { self.init(); f( self ) }
    
	fileprivate var parent_window:LLWindow?

	public init( parent:LLWindow? = nil ) {
		self.parent_window = parent
				
		let frame = NSRect( 0, 0, 300, 200 )
        
		super.init(contentRect: frame,
			styleMask: NSWindow.StyleMask( [.resizable, .miniaturizable, .closable, .titled] ),
			backing: NSWindow.BackingStoreType.buffered, defer: false)
        
		// resize event
		NotificationCenter.default.addObserver(self, 
                                               selector:#selector(LLWindow.windowDidResize(_:)),
                                               name:NSWindow.didResizeNotification,
                                               object: nil )
        // exit full screen event
        NotificationCenter.default.addObserver(self, 
                                               selector:#selector(LLWindow.windowWillExitFullScreen(_:)),
                                               name:NSWindow.willExitFullScreenNotification,
                                               object:nil )
        // close event
		NotificationCenter.default.addObserver(self, 
                                               selector:#selector(LLWindow.windowWillClose(_:)),
                                               name:NSWindow.willCloseNotification,
                                               object:nil )

        self.acceptsMouseMovedEvents = true
		self.orderFront(nil)
    }
	
	deinit {
		NotificationCenter.default.removeObserver(self, name:NSWindow.didResizeNotification, object:nil)
		NotificationCenter.default.removeObserver(self, name:NSWindow.willCloseNotification, object:nil)
    }

    public func windowDidResize( _ notification:Notification ) {
		//igWindow.resize.ignite( LLArg2() )
	}
    
    private var _exit_full_screen:Bool = false
    public func windowWillExitFullScreen( _ notification: Notification ) {
        _exit_full_screen = true
    }
	
    public func windowWillClose( _ notification:Notification ) {
        // 最大化からの戻りでも閉じるが動くのでフラグで処理を防止
        if _exit_full_screen {
            _exit_full_screen = false
            return
        }
		//igWindow.close.ignite( LLArg2() )
	}
}
