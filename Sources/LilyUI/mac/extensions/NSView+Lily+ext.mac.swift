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
                
    public func rebuildChildren() {
        // NSView側
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
        
        // CALayer側
        guard let sublayers = self.layer?.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }

    public func teardownChildren() {
        // NSView側
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
        
        // CALayer側
        guard let sublayers = self.layer?.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
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
    
    // NSView用
    public func addSubview<TView:NSView>(_ viewChain:LLChain<TView> ) {
        if let llui = viewChain.unchain as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        self.addSubview( viewChain.unchain )
    }

    // CALayerベースLLView用
    public func addSubview<TLayer:CALayer>( _ llView:TLayer ) {
        if let llui = llView as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        self.layer?.addSublayer( llView )
    }
    
    public func addSubview<TLayer:CALayer>(_ llViewChain:LLChain<TLayer> ) {
        self.addSubview( llViewChain.unchain )
    }
}

extension NSView
{
    var backgroundColor:LLColor? { 
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else { return nil }
            return backgroundColor.llColor
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    var borderColor:LLColor? { 
        get {
            guard let layer = layer, let borderColor = layer.borderColor else { return nil }
            return borderColor.llColor
        }
        set {
            wantsLayer = true
            layer?.borderColor = newValue?.cgColor
        }
    }
    
    var borderWidth:Float { 
        get {
            guard let layer = layer else { return 0.0 }
            return layer.borderWidth.f
        }
        set {
            wantsLayer = true
            layer?.borderWidth = newValue.cgf
        }
    }
    
    var cornerRadius:Float { 
        get {
            guard let layer = layer else { return 0.0 }
            return layer.cornerRadius.f
        }
        set {
            wantsLayer = true
            layer?.cornerRadius = newValue.cgf
        }
    }
    
}

#endif
