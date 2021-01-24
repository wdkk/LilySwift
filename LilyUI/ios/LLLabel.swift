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

open class LLLabel : UILabel, LLUILifeEvent, LLUIFieldFunctionable
{
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    
    public lazy var touchesBeganField = LLTouchFieldMap()
    public lazy var touchesMovedField = LLTouchFieldMap()
    public lazy var touchesEndedField = LLTouchFieldMap()
    public lazy var touchesCancelledField = LLTouchFieldMap()
    
    public lazy var drawLayerField = LLDrawFieldMap()
         
    public required init?(coder: NSCoder) { super.init(coder:coder) }
    public init() {
        super.init( frame:.zero )
        self.preSetup()
        self.setup()
        self.postSetup()
    }
    
    public func preSetup() { 
        // TODO: 初期化(サイズがないとiOS11では動作しない模様)
        CATransaction.stop {
            self.rect = LLRect( -1, -1, 1, 1 )
        }
    }
    
    public func setup() { }
    
    public func postSetup() { }
    
    public func preBuildup() { }
    
    public func buildup() { }
    
    public func postBuildup() {
        self.callBuildupFunctions()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }
    
    public func teardown() {
        self.callTeardownFunctions()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    var _mutex = LLRecursiveMutex()
    public func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    public override func addSubview( _ view: UIView ) {
        if let llfield_f = view as? LLUIFieldFunctionable {
            llfield_f.callSetupFunctions()
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
    }
    
    public override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesCancelled( touches, with:event )
        self.touchesCancelledField.appear( LLTouchArg( touches, event ) )
    }
    
    public func callSetupFunctions() {
        self.setupField.appear( LLEmpty.none )
    }
    
    public func callBuildupFunctions() {
        self.buildupField.appear( LLEmpty.none )
    }
    
    public func callTeardownFunctions() {
        self.teardownField.appear( LLEmpty.none )
    }
        
    public override func draw( _ rect: CGRect ) {
        super.draw( rect )
        self.drawLayerField.appear( rect )
    }
}

#endif
