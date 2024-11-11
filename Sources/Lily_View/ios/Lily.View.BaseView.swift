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

extension Lily.View
{
    open class BaseView
    : UIView
    , LLUILifeEvent
    {    
        public struct TouchObj 
        {
            public var touches:Set<UITouch> 
            public var event:UIEvent?
        }
        
        public typealias Me = Lily.View.BaseView
        public typealias TouchField = Lily.Field.ViewEvent<Me, TouchObj>
        
        public var _mutex = RecursiveMutex()
        public var setupField:(any LLField)?
        public var buildupField:(any LLField)?
        public var teardownField:(any LLField)?
        open func setup() {}
        open func buildup() {}
        open func teardown() {}
        
        public var touchesBeganField:TouchField?
        public var touchesMovedField:TouchField?
        public var touchesEndedField:TouchField?
        public var touchesEndedInsideField:TouchField?
        public var touchesCancelledField:TouchField?
        
        public required init?(coder: NSCoder) { super.init(coder:coder) }
        public init() { super.init( frame:.zero ) }
        
        open override func addSubview( _ view:UIView ) {
            (view as? LLUILifeEvent)?.callSetupPhase()
            super.addSubview( view )
        }
        
        open override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesBegan( touches, with:event )
            touchesBeganField?.appear( .init( touches:touches, event:event ) )
        }
        
        open override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesMoved( touches, with:event )
            touchesMovedField?.appear( .init( touches:touches, event:event ) )
        }
        
        open override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesEnded( touches, with:event )
            touchesEndedField?.appear( .init( touches:touches, event:event ) )
            
            if (touches.filter { self.bounds.contains( $0.preciseLocation( in:self ) ) }).count > 0 {
                touchesEndedInsideField?.appear( .init( touches:touches, event:event ) )
            }
        }
        
        open override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesCancelled( touches, with:event )
            touchesCancelledField?.appear( .init( touches:touches, event:event ) )
        }
    }
}

extension Lily.View.BaseView
{    
    public func touchesBegan( _ action:@escaping (Me, TouchObj)->() ) 
    -> Self 
    {
        touchesBeganField = .init( me:self, action:action )
        return self
    }
    
    public func touchesBegan<TCaller:AnyObject>( caller:TCaller, _ action:@escaping (Me, TCaller, TouchObj)->() )
    -> Self 
    {
        touchesBeganField = .init( me:self, caller:caller, action:action )
        return self
    }
    
    public func touchesMoved( _ action:@escaping (Me, TouchObj)->() ) 
    -> Self 
    {
        touchesMovedField = .init( me:self, action:action )
        return self
    }
    
    public func touchesMoved<TCaller:AnyObject>( caller:TCaller, _ action:@escaping (Me, TCaller, TouchObj)->() )
    -> Self 
    {
        touchesMovedField = .init( me:self, caller:caller, action:action )
        return self
    }
    
    public func touchesEnded( _ action:@escaping (Me, TouchObj)->() ) 
    -> Self 
    {
        touchesEndedField = .init( me:self, action:action )
        return self
    }
    
    public func touchesEnded<TCaller:AnyObject>( caller:TCaller, _ action:@escaping (Me, TCaller, TouchObj)->() )
    -> Self 
    {
        touchesEndedField = .init( me:self, caller:caller, action:action )
        return self
    }
    
    public func touchesEndedInside( _ action:@escaping (Me, TouchObj)->() ) 
    -> Self 
    {
        touchesEndedInsideField = .init( me:self, action:action )
        return self
    }
    
    public func touchesEndedInside<TCaller:AnyObject>( caller:TCaller, _ action:@escaping (Me, TCaller, TouchObj)->() )
    -> Self 
    {
        touchesEndedInsideField = .init( me:self, caller:caller, action:action )
        return self
    }
    
    public func touchesCancelled( _ action:@escaping (Me, TouchObj)->() ) 
    -> Self 
    {
        touchesCancelledField = .init( me:self, action:action )
        return self
    }
    
    public func touchesCancelled<TCaller:AnyObject>( caller:TCaller, _ action:@escaping (Me, TCaller, TouchObj)->() )
    -> Self 
    {
        touchesCancelledField = .init( me:self, caller:caller, action:action )
        return self
    }
}
#endif
