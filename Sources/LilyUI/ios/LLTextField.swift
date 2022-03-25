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

open class LLTextField 
: UITextField
, LLUILifeEvent
, LLTouchEvent
{
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    
    public lazy var actionBeganField = LLActionFieldMap()
    public lazy var actionMovedField = LLActionFieldMap()
    public lazy var actionEndedField = LLActionFieldMap()
    public lazy var actionEndedInsideField = LLActionFieldMap()
    
    public lazy var touchesBeganField = LLTouchFieldMap()
    public lazy var touchesMovedField = LLTouchFieldMap()
    public lazy var touchesEndedField = LLTouchFieldMap()
    public lazy var touchesEndedInsideField = LLTouchFieldMap()
    public lazy var touchesCancelledField = LLTouchFieldMap()
    
    public lazy var drawLayerField = LLDrawFieldMap()
    public lazy var styleField = LLViewStyleFieldMap()
    public var layoutField:LLField?
    
    public lazy var borderBottom = CALayer(layer:self.layer)
    
    public private(set) var placeholderText:LLString = ""
    public private(set) var placeholderColor = LLColor.black
    
    open func placeholderText( _ text:LLString ) {
        self.placeholderText = text
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholderText, 
        attributes: [NSAttributedString.Key.foregroundColor : self.placeholderColor.uiColor] )
    }
    
    open func placeholderColor( _ c:LLColor ) {
        self.placeholderColor = c
        self.attributedPlaceholder = NSAttributedString(
            string: self.placeholderText, 
        attributes: [NSAttributedString.Key.foregroundColor : self.placeholderColor.uiColor] )
    }

    public required init?(coder: NSCoder) { super.init(coder:coder) }
    public init() {
        super.init( frame:.zero )
        
        self.chain
        .setup.add( order:.pre, caller:self ) { caller, me in
            me.chain
            .isUserInteractionEnabled( true )
            .autocorrectionType( .no )
            .autocapitalizationType( .none )
        }     
        .style.default { me in
            me.chain
            .textColor( LLColorSet["text-field","text"] )
            .borderColor( LLColorSet["text-field","border"] )
            .backgroundColor( LLColorSet["text-field","background"] )
            .placeholderColor( LLColorSet["text-field","placeholder"] )
            
            me.borderBottom.backgroundColor = LLColorSet["text-field","border"].cgColor
       
            CATransaction.stop {
                me.borderBottom.frame = CGRect( 0, me.height-2.0, me.width, 2.0 )   
            }
        }
        
        self.layer.addSublayer( self.borderBottom )
    }
    
    public var _mutex = LLRecursiveMutex()
    
    open func preSetup() { }
    
    open func setup() { }
    
    open func postSetup() { self.lifeEventDefaultSetup() }
    
    open func preBuildup() { }
    
    open func buildup() { }
    
    open func postBuildup() { self.lifeEventDefaultBuildup() }
    
    open func teardown() { self.lifeEventDefaultTeardown() }
    
    open override func addSubview( _ view:UIView ) {
        if let llui = view as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        super.addSubview( view )
    }
    
    open override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesBegan( touches, with:event )
        self.touchEvent( began:self, touches:touches, with:event )
    }
    
    open override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesMoved( touches, with:event )
        self.touchEvent( moved:self, touches:touches, with:event )
    }
    
    open override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesEnded( touches, with:event )
        self.touchEvent( ended:self, touches:touches, with:event )
    }
    
    open override func touchesCancelled( _ touches: Set<UITouch>, with event: UIEvent? ) {
        super.touchesCancelled( touches, with:event )
        self.touchEvent( cancelled:self, touches:touches, with:event )
    }
     
    open override func draw( _ rect: CGRect ) {
        super.draw( rect )
        self.drawLayerField.appear( rect )
    }
}

#endif
