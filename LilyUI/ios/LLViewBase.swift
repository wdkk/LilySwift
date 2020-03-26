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

open class LLViewBase : UIView, LLUILifeEvent
{
    public lazy var assemble = LLViewFieldContainer()
    public lazy var design = LLViewFieldContainer()
    public lazy var disassemble = LLViewFieldContainer()
    
    public lazy var touchesBegan = LLTouchFieldContainer()
    public lazy var touchesMoved = LLTouchFieldContainer()
    public lazy var touchesEnded = LLTouchFieldContainer()
    public lazy var touchesCancelled = LLTouchFieldContainer()
        
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
        self.callDisassembleFunction()
        
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    public func rebuild() {
        self.buildup()
        self.postBuildup()
    }
    
    public override func addSubview( _ view: UIView ) {
        if let llview = view as? LLViewFieldCallable {
            llview.callAssembleFunction()
        }
        super.addSubview( view )
    }
    
    public override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesBegan( touches, with:event )
        self.touchesBegan.appear( LLTouchArg( touches, event ) )
    }
    
    public override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesMoved( touches, with:event )
        self.touchesMoved.appear( LLTouchArg( touches, event ) )
    }
    
    public override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesEnded( touches, with:event )
        self.touchesEnded.appear( LLTouchArg( touches, event ) )
    }
    
    public override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesCancelled( touches, with:event )
        self.touchesCancelled.appear( LLTouchArg( touches, event ) )
    }
}

extension LLViewBase : LLViewFieldCallable
{
    public func callAssembleFunction() {
        self.assemble.appear( LLEmptyObject.none )
    }
    
    public func callDesignFunction() {
        self.design.appear( LLEmptyObject.none )
    }
    
    public func callDisassembleFunction() {
        self.disassemble.appear( LLEmptyObject.none )
    }
}

#endif
