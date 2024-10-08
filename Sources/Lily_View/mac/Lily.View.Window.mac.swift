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

import Foundation
import AppKit

extension Lily.View
{
    open class Window 
    : NSWindow
    , NSWindowDelegate
    {
        public convenience init( f:(Window)->Void ) { self.init(); f( self ) }
        
        public var didChangeScreen:((Window) -> ())?
        
        fileprivate var parent_window:Window?
        
        public init( parent:Window? = nil ) {
            self.parent_window = parent
            
            let frame = NSRect( 0, 0, 300, 200 )
            
            super.init(
                contentRect: frame,
                styleMask: NSWindow.StyleMask( [.resizable, .miniaturizable, .closable, .titled] ),
                backing: NSWindow.BackingStoreType.buffered, defer: false 
            )
            
            LLSystem.currentWindow = self
            LLSystem.updateRetinaScale()
   
            self.acceptsMouseMovedEvents = true
            self.delegate = self
            self.orderFront( nil )
        }
        
        private var _changed_screen:Bool = false
        open func windowDidChangeScreen( _ notification:Notification ) {
            // retina scaleを取得するためにLLSystem.currentWindowにスクリーン変更後のWindowを保持する
            _changed_screen = true
            guard let w = notification.object as? Window else { return }
            LLSystem.currentWindow = w
            LLSystem.updateRetinaScale()
            didChangeScreen?( w )
        }
        
        private var _exit_full_screen:Bool = false
        open func windowWillExitFullScreen( _ notification:Notification ) {
            _exit_full_screen = true
        }
        
        open func windowWillClose( _ notification:Notification ) {
            // 最大化からの戻りでも閉じるが動くのでフラグで処理を防止
            if _exit_full_screen {
                _exit_full_screen = false
                return
            }
        }
    }
}

#endif
