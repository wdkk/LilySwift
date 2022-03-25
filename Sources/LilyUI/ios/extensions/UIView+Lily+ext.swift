//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

extension UIView : LLUIRectControllable, LLUIPixelControllable
{
    public var ourCenter: CGPoint {
        get { return self.center }
        set { self.center = newValue }
    }
    
    public var ourBounds: CGRect {
        get { return self.bounds }
        set { self.bounds = newValue }
    }
    
    public var ourFrame: CGRect {
        get { return self.frame }
        set { self.frame = newValue }
    }
                
    public static func findFirstResponder( _ view:UIView ) -> UIView? {
        if view.isFirstResponder { return view }
        
        for subview in view.subviews {
            if subview.isFirstResponder { return subview }
            // 再帰処理
            guard let responder = UIView.findFirstResponder( subview ) else { continue }
            return responder
        }
        
        return nil
    }

    public func rebuildChildren() {
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }

    public func teardownChildren() {
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    public func removeChildren() {
        for v in self.subviews { v.removeFromSuperview() }
        
        guard let sublayers = self.layer.sublayers else { return }
        for l in sublayers { l.removeFromSuperlayer() }
        self.layer.sublayers = nil
    }
    
    public func addSubview<TView:UIView>( _ chainview:LLChain<TView> ) {
        let view = chainview.unchain
        self.addSubview( view )
    }
}

#endif
