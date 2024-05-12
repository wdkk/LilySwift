//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(tvOS) || os(visionOS)

import UIKit

extension UIView 
{
    public func rebuildChildren() {
        self.subviews.forEach { ($0 as? LLUILifeEvent)?.rebuild() }
    }

    public func teardownChildren() {
        self.subviews.forEach { ($0 as? LLUILifeEvent)?.callTeardownPhase() }
    }
    
    public func removeChildren() {
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        self.layer.sublayers = nil
    }
}

extension UIView 
: LLUIRectControllable
{
    static func findFirstResponder( _ view:UIView ) -> UIView? {
        if view.isFirstResponder { return view }
        
        for subview in view.subviews {
            if subview.isFirstResponder { return subview }
            // 再帰処理
            guard let responder = UIView.findFirstResponder( subview ) else { continue }
            return responder
        }
        
        return nil
    }
    
    public var ownFrame: CGRect {
        get { return self.bounds }
        set { self.bounds = newValue }
    }
    
    public var bgColor:LLColor? { self.backgroundColor?.llColor }
    
    @discardableResult
    public func bgColor( _ c:LLColor ) -> Self {
        self.backgroundColor = c.uiColor
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
        self.ownFrame = rc.cgRect
        return self
    }
    
    @discardableResult
    public func bounds( _ cgrc:CGRect ) -> Self { 
        self.ownFrame = cgrc
        return self
    }
        
    @discardableResult
    public func alpha( _ k:CGFloat ) -> Self { 
        self.alpha = k
        return self
    }
    
    public var position:LLPoint { LLPoint( rect.x, rect.y ) }
    
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
    
    public var borderColor:LLColor? { layer.borderColor?.llColor }
    
    @discardableResult
    public func borderColor( _ c:LLColor ) -> Self {
        layer.borderColor = c.cgColor
        return self
    }  
    
    public var borderWidth:LLFloat { layer.borderWidth.f }
    
    @discardableResult
    public func borderWidth( _ w:LLFloat ) -> Self {
        layer.borderWidth = w.cgf
        return self
    }
    
    public var cornerRadius:LLFloat { layer.cornerRadius.f }
    
    @discardableResult
    public func cornerRadius( _ r:LLFloat ) -> Self {
        layer.cornerRadius = r.cgf
        return self
    }
             
    public var maskToBounds:Bool { layer.masksToBounds }
    
    @discardableResult
    public func maskToBounds( _ torf:Bool ) -> Self {
        layer.masksToBounds = torf
        return self
    }
}

#endif
