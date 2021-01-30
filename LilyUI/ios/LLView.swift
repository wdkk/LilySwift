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

open class LLView : UIView, LLUILifeEvent
{
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    
    public lazy var defaultBuildupField = LLViewFieldMap()
    public lazy var staticBuildupField = LLViewFieldMap()
    
    public lazy var touchesBeganField = LLTouchFieldMap()
    public lazy var touchesMovedField = LLTouchFieldMap()
    public lazy var touchesEndedField = LLTouchFieldMap()
    public lazy var touchesEndedInsideField = LLTouchFieldMap()
    public lazy var touchesCancelledField = LLTouchFieldMap()
    
    public lazy var drawLayerField = LLDrawFieldMap()
    
    public required init?(coder: NSCoder) { super.init(coder:coder) }
    public init() {
        super.init( frame:.zero )
    }
    
    public var _mutex = LLRecursiveMutex()
    public func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    public func preSetup() { 
        // TODO: 初期化(サイズがないとiOS11では動作しない模様)
        CATransaction.stop { self.rect = LLRect( -1, -1, 1, 1 ) }
    }
    
    public func setup() { }
    
    public func postSetup() {
        self.callSetupFields()
    }
    
    public func preBuildup() {
        self.callDefaultBuildupFields()
    }
    
    public func buildup() { }
    
    public func postBuildup() {
        self.callBuildupFields()
        self.callStaticBuildupFields()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }
    
    public func teardown() {
        self.callTeardownFields()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    public override func addSubview( _ view: UIView ) {
        if let llui = view as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        super.addSubview( view )
    }
    
    public override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesBegan( touches, with:event )
        self.touchesBeganField.appear( LLTouchArg( touches, event ) )
    }
    
    public override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesMoved( touches, with:event )
        self.touchesMovedField.appear( LLTouchArg( touches, event ) )
    }
    
    public override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesEnded( touches, with:event )
        self.touchesEndedField.appear( LLTouchArg( touches, event ) )
        
        for touch in touches {
            if self.bounds.contains( touch.preciseLocation( in: self ) ) {
                self.touchesEndedInsideField.appear( LLTouchArg( touches, event ) )
                break
            }
        }
    }
    
    public override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesCancelled( touches, with:event )
        self.touchesCancelledField.appear( LLTouchArg( touches, event ) )
    }
            
    public override func draw( _ rect: CGRect ) {
        super.draw( rect )
        self.drawLayerField.appear( rect )
    }
}

#endif
