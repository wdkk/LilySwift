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

@available(iOS 9.1, *)
open class LLLabel : UILabel, LLUILifeEvent
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
    open func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    open func preSetup() { 
        // TODO: 初期化(サイズがないとiOS11では動作しない模様)
        CATransaction.stop { self.rect = LLRect( -1, -1, 1, 1 ) }
    }
    
    open func setup() { }
    
    open func postSetup() {
        self.callSetupFields()
    }
    
    open func preBuildup() {
        self.callDefaultBuildupFields()
    }
    
    open func buildup() { }
    
    open func postBuildup() {
        self.callBuildupFields()
        self.callStaticBuildupFields()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }
    
    open func teardown() {
        self.callTeardownFields()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    open override func addSubview( _ view: UIView ) {
        if let llui = view as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        super.addSubview( view )
    }
    
    open override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesBegan( touches, with:event )
        self.touchesBeganField.appear( LLTouchArg( touches, event ) )
    }
    
    open override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesMoved( touches, with:event )
        self.touchesMovedField.appear( LLTouchArg( touches, event ) )
    }
    
    open override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesEnded( touches, with:event )
        self.touchesEndedField.appear( LLTouchArg( touches, event ) )
        
        for touch in touches {
            if self.bounds.contains( touch.preciseLocation( in: self ) ) {
                self.touchesEndedInsideField.appear( LLTouchArg( touches, event ) )
                break
            }
        }
    }
    
    open override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesCancelled( touches, with:event )
        self.touchesCancelledField.appear( LLTouchArg( touches, event ) )
    }
     
    open override func draw( _ rect: CGRect ) {
        super.draw( rect )
        self.drawLayerField.appear( rect )
    }
}

#endif
