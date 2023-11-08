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

extension NSView
: LLUIRectControllable
{    
    public var center: CGPoint {
        get {
            return CGPoint( (frame.x + frame.width / 2.0).f, (frame.y + frame.height / 2.0).f )
        }
        set {
            let x = newValue.x - frame.width / 2.0
            let y = newValue.y - frame.height / 2.0
            self.setFrameOrigin( CGPoint( x, y ) )
        }
    }
    
    public var ownFrame:CGRect {
        get { 
            return CGRect( 0, 0, self.frame.width, self.frame.height )
        }
        set {
            self.setFrameSize( newValue.size )
        }
    }

    /*
    public var frame: CGRect {
        get { 
            return CGRect( self.x, self.y, self.width, self.height )
        }
        set { 
            self.setFrameOrigin( newValue.origin )
            self.setFrameSize( newValue.size )
        }
    }
    */
    
    public func rebuildChildren() {
        // NSView側
        self.subviews.forEach { ($0 as? LLUILifeEvent)?.rebuild() }
        // CALayer側
        self.layer?.sublayers?.forEach { ($0 as? LLUILifeEvent)?.rebuild() }
    }

    public func teardownChildren() {
        // NSView側
        self.subviews.forEach { ($0 as? LLUILifeEvent)?.callTeardownPhase() }
        // CALayer側
        self.layer?.sublayers?.forEach { ($0 as? LLUILifeEvent)?.callTeardownPhase() }
    }
    
    public func removeChildren() {
        for v in self.subviews { v.removeFromSuperview() }
        
        guard let sublayers = self.layer?.sublayers else { return }
        for l in sublayers {
            l.removeFromSuperlayer()
        }
        self.layer?.sublayers = nil
    }
    
    // CALayerベースLLView用
    public func addSubview<TLayer:CALayer>( _ lilyView:TLayer ) {
        if let llui = lilyView as? LLUILifeEvent {
            llui.setup()
        }
        self.layer?.addSublayer( lilyView )
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

extension NSView 
{            
    public var bgColor:LLColor? { self.backgroundColor }
    
    @discardableResult
    public func bgColor( _ c:LLColor ) -> Self {
        self.backgroundColor = c
        return self
    }
    
    @discardableResult
    public func rect( _ rc:LLRect ) -> Self { 
        self.rect = rc
        return self
    }
    
    @discardableResult
    public func rect( _ cgrc:CGRect ) -> Self { 
        self.rect = cgrc.llRect
        return self
    }
    
    @discardableResult
    public func rect( _ x:LLDouble, _ y:LLDouble, _ width:LLDouble, _ height:LLDouble ) -> Self {
        return rect( LLRect( x, y, width, height ) )
    }
    
    
    @discardableResult
    public func bounds( _ rc:LLRect ) -> Self { 
        self.bounds = rc.cgRect
        return self
    }
    
    @discardableResult
    public func bounds( _ cgrc:CGRect ) -> Self { 
        self.bounds = cgrc
        return self
    }
        
    @discardableResult
    public func alpha( _ k:CGFloat ) -> Self { 
        // 効果なし
        return self
    }
    
    @discardableResult
    public func position( _ pos:LLPoint ) -> Self {
        rect.x = pos.x
        rect.y = pos.y
        return self
    }
    
    @discardableResult
    public func position( _ x:LLDouble, _ y:LLDouble ) -> Self {
        return position( LLPoint( x, y ) )
    }
    
    public var size:LLSize { LLSize( rect.width, rect.height ) }
        
    @discardableResult
    public func size( _ sz:LLSize ) -> Self {
        rect.width = sz.width
        rect.height = sz.height
        return self
    }
    
    @discardableResult
    public func size( _ width:LLDouble, _ height:LLDouble ) -> Self {
        return size( LLSize( width, height ) )
    }
    
    //public var borderColor:LLColor? { layer.borderColor?.llColor }
    
    @discardableResult
    public func borderColor( _ c:LLColor ) -> Self {
        borderColor = c
        return self
    }  
    
    //public var borderWidth:LLFloat { borderWidth.f }
    
    @discardableResult
    public func borderWidth( _ w:LLFloat ) -> Self {
        borderWidth = w
        return self
    }
}

#endif
