//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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
    public lazy var designField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    
    public lazy var touchesBeganField = LLTouchFieldMap()
    public lazy var touchesMovedField = LLTouchFieldMap()
    public lazy var touchesEndedField = LLTouchFieldMap()
    public lazy var touchesCancelledField = LLTouchFieldMap()
    
    public lazy var drawLayerField = LLDrawFieldMap()
         
    public required init?(coder: NSCoder) { super.init(coder:coder) }
    public init() {
        super.init( frame:.zero )
        self.setup()
        self.postSetup()
    }
    
    public func setup() { }
    
    public func postSetup() { }
    
    public func buildup() { }
    
    public func postBuildup() {
        self.callDesignFunction()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }
    
    public func teardown() {
        self.callDissetupFunction()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    public func rebuild() {
        self.buildup()
        self.postBuildup()
    }
    
    public override func addSubview( _ view: UIView ) {
        if let llview = view as? LLView {
            llview.callAssembleFunction()
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
    
    public func callAssembleFunction() {
        self.setupField.appear( LLEmpty.none )
    }
    
    public func callDesignFunction() {
        self.designField.appear( LLEmpty.none )
    }
    
    public func callDissetupFunction() {
        self.teardownField.appear( LLEmpty.none )
    }
        
    public override func draw( _ rect: CGRect ) {
        self.drawLayerField.appear( rect )
    }
}

#endif
