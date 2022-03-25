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

public protocol LLTouchEvent : AnyObject
{
    var bounds:CGRect { get set }
    
    var actionBeganField:LLActionFieldMap { get set }
    var actionMovedField:LLActionFieldMap { get set }
    var actionEndedField:LLActionFieldMap { get set }
    var actionEndedInsideField:LLActionFieldMap { get set }
    
    var touchesBeganField:LLTouchFieldMap { get set }
    var touchesMovedField:LLTouchFieldMap { get set }
    var touchesEndedField:LLTouchFieldMap { get set }
    var touchesEndedInsideField:LLTouchFieldMap { get set }
    var touchesCancelledField:LLTouchFieldMap { get set }
    
    func touchEvent( began view:UIView, touches: Set<UITouch>, with event: UIEvent? )
    func touchEvent( moved view:UIView, touches: Set<UITouch>, with event: UIEvent? )
    func touchEvent( ended view:UIView, touches: Set<UITouch>, with event: UIEvent? )
    func touchEvent( cancelled view:UIView, touches: Set<UITouch>, with event: UIEvent? )
}

public extension LLTouchEvent where Self : LLUILifeEvent
{
    func touchEvent( began view:UIView, touches: Set<UITouch>, with event: UIEvent? ) {
        if self.isEnabled { self.styleField.action?.appear() }
        
        let points = touches.compactMap { $0.location( in:view ).llPoint }
        self.actionBeganField.appear( LLActionArg( points ) )
        self.touchesBeganField.appear( LLTouchArg( touches, event ) )
    }
    
    func touchEvent( moved view:UIView, touches: Set<UITouch>, with event: UIEvent? ) {
        let points = touches.compactMap { $0.location( in:view ).llPoint }
        self.actionMovedField.appear( LLActionArg( points ) )
        self.touchesMovedField.appear( LLTouchArg( touches, event ) )
    }
    
    func touchEvent( ended view:UIView, touches: Set<UITouch>, with event: UIEvent? ) {
        if self.isEnabled { self.styleField.default?.appear() }
        
        let points = touches.compactMap { $0.location( in:view ).llPoint }
        self.actionEndedField.appear( LLActionArg( points ) )
        self.touchesEndedField.appear( LLTouchArg( touches, event ) )
        
        for touch in touches {
            if self.bounds.contains( touch.preciseLocation( in:view ) ) {
                self.actionEndedInsideField.appear( LLActionArg( points ) )
                self.touchesEndedInsideField.appear( LLTouchArg( touches, event ) )
                break
            }
        }
    }
    
    func touchEvent( cancelled view:UIView, touches: Set<UITouch>, with event: UIEvent? ) {
        let points = touches.compactMap { $0.location( in: view ).llPoint }
        self.actionEndedField.appear( LLActionArg( points ) )
        self.touchesCancelledField.appear( LLTouchArg( touches, event ) )
    }
}

#endif
