//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Cocoa

extension NSWindow : LLUIRectControllable, LLUIPixelControllable
{
    public var ourCenter: CGPoint {
        get {
            return CGPoint( (frame.x + frame.width / 2.0).f, (frame.y + frame.height / 2.0).f )
        }
        set {
            let x = newValue.x - frame.width / 2.0
            let y = newValue.y - frame.height / 2.0
            self.setFrameOrigin( CGPoint( x, y ) )
        }
    }
    
    public var ourBounds: CGRect {
        get { 
            return self.bounds
        }
        set { 
            setFrame( NSRect( self.frame.x, self.frame.y, newValue.width, newValue.height ),
                      display: true, animate: false )
        }
    }
    
    public var ourFrame: CGRect {
        get { 
            let nsrect = NSScreen.main!.visibleFrame
            let cy  = nsrect.height.f
            let wid = frame.width.f
            let hgt = frame.height.f
            let x   = frame.x.f
            let y   = cy - frame.y.f
            return CGRect( x, y, wid, hgt )
        }
        set { 
            let nsrect = NSScreen.main!.visibleFrame
            let cy  = nsrect.height
            let wid = newValue.width
            let hgt = newValue.height
            let x   = newValue.x
            let y   = cy - newValue.y
            
            setFrame( NSRect( x, y, wid, hgt ),
                      display: true, animate: false )
        }
    }
        
    public var bounds:CGRect {
        return CGRect( 0, 0, rect.width, rect.height )
    }

    public var contentRect:CGRect {
        return self.contentRect( forFrameRect: self.frame )
    }
    
    public var contentBounds:CGRect {
        let content_rect = self.contentRect(forFrameRect: self.frame)
        return CGRect( 0, 0, content_rect.size.width, content_rect.size.height )
    }
    
    public var contentWidth:LLDouble {
        return contentRect.width.d
    }
    
    public var contentHeight:LLDouble {
        return contentRect.height.d
    }
}

#endif
