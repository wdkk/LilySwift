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

extension NSView : LLUIRectControllable, LLUIPixelControllable
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
            self.setFrameSize( newValue.size )
        }
    }
    
    public var ourFrame: CGRect {
        get { 
            return self.frame
        }
        set { 
            self.setFrameOrigin( newValue.origin )
            self.setFrameSize( newValue.size )
        }
    }
                
    public func removeChildren() {
        for v in self.subviews {
            v.removeFromSuperview()
        }
        
        guard let sublayers = self.layer?.sublayers else { return }
        for l in sublayers {
            l.removeFromSuperlayer()
        }
        self.layer?.sublayers = nil
    }
    
    public func addSubview( _ llView:LLView ) {
        self.layer!.addSublayer( llView )
    }
    
    // NSView用
    public func addSubview(_ viewChain:LLChain<NSView> ) {
        self.addSubview( viewChain.unchain )
    }

    // CALayerベースLLView用
    public func addSubview(_ llViewChain:LLChain<LLView> ) {
        self.addSubview( llViewChain.unchain )
    }
}

#endif
