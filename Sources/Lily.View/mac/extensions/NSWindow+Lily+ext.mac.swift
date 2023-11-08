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

extension NSWindow
: LLUIRectControllable
{
    public var center: CGPoint {
        get {
            return CGPoint( (frame.x + frame.width / 2.0).f, (frame.y + frame.height / 2.0).f )
        }
        set {
            let nsrect = NSScreen.main!.visibleFrame
            let cy  = nsrect.height
            let x = newValue.x - frame.width / 2.0
            let y = newValue.y - frame.height / 2.0
            self.setFrameOrigin( CGPoint( x, cy - y ) )
        }
    }
    
    public var ownFrame: CGRect {
        get { 
            return CGRect( 0, 0, frame.width, frame.height )
        }
        set { 
            setFrame( 
                NSRect( self.frame.x, self.frame.y, newValue.width, newValue.height ),
                display: true, 
                animate: false 
            )
        }
    }
   
    /*
    public var frame: CGRect {
        get {
            let nsrect = NSScreen.main!.visibleFrame
            let cy  = nsrect.height.f
            
            let wid = self.width.f
            let hgt = self.height.f
            let x   = self.x.f
            let y   = cy - self.y.f
            return CGRect( x, y, wid, hgt )
        }
        set { 
            let nsrect = NSScreen.main!.visibleFrame
            let cy  = nsrect.height
            let wid = newValue.width
            let hgt = newValue.height
            let x   = newValue.x
            let y   = cy - newValue.y
            
            setFrame( NSRect( x, y, wid, hgt ), display: true, animate: false )
        }
    }
    */
    
    public var contentRect:CGRect {
        return self.contentRect( forFrameRect:self.frame )
    }
    
    public var contentBounds:CGRect {
        let content_rect = self.contentRect( forFrameRect:self.frame )
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
