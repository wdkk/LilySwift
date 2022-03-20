//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Foundation
import Cocoa
import QuartzCore

open class LLTextField : NSTextField, CALayerDelegate, LLUILifeEvent
{
    public var isUserInteractionEnabled: Bool = true
    
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    public lazy var styleField = LLViewStyleFieldMap()
        
    public lazy var actionBeganField = LLActionFieldMap()
    public lazy var actionMovedField = LLActionFieldMap()
    public lazy var actionEndedField = LLActionFieldMap()
    public lazy var actionEndedInsideField = LLActionFieldMap()

    public lazy var mouseMovedField = LLMouseFieldMap()
    public lazy var mouseLeftDownField = LLMouseFieldMap()
    public lazy var mouseLeftDraggedField = LLMouseFieldMap()
    public lazy var mouseLeftUpField = LLMouseFieldMap()
    public lazy var mouseLeftUpInsideField = LLMouseFieldMap()
    public lazy var mouseRightDownField = LLMouseFieldMap()
    public lazy var mouseRightDraggedField = LLMouseFieldMap()
    public lazy var mouseRightUpField = LLMouseFieldMap()
    public lazy var mouseRightUpInsideField = LLMouseFieldMap()
    public lazy var mouseOverField = LLMouseFieldMap()
    public lazy var mouseOutField = LLMouseFieldMap()
    
    public private(set) var placeholderText:LLString = ""
    public private(set) var placeholderColor = LLColor.black
    
    open func placeholderText( _ text:LLString ) {
        self.placeholderText = text
        self.placeholderAttributedString = NSAttributedString(
            string: self.placeholderText, 
            attributes: [
                NSAttributedString.Key.foregroundColor : self.placeholderColor.nsColor,
                NSAttributedString.Key.font : self.font!
            ] 
        )
    }
    
    open func placeholderColor( _ c:LLColor ) {
        self.placeholderColor = c
        self.placeholderAttributedString = NSAttributedString(
            string: self.placeholderText, 
            attributes: [
                NSAttributedString.Key.foregroundColor : self.placeholderColor.nsColor,
                NSAttributedString.Key.font : self.font!
            ]
        )
    }

    required public init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init( frame:.zero )
        
        self.focusRingType = .none
        
        self.chain
        .style.default { me in
            me.chain
            .borderColor( .clear )
            .backgroundColor( .clear )
            .placeholderColor( .grey )
        }
    }
    
    open func preSetup() { }
    
    open func setup() { }
    
    open func postSetup() { 
        self.callSetupFields()
    }
    
    open func preBuildup() { }
    
    open func buildup() { }
    
    open func postBuildup() {
        self.callBuildupFields()
        
        self.styleField.default?.appear() 
        if !isEnabled { self.styleField.disable?.appear() }
                
        // NSView側
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
        
        // CALayer側
        guard let sublayers = self.layer?.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }
    
    open func teardown() {
        self.callTeardownFields()
         
        // NSView側
        for child in self.subviews {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
        
        // CALayer側
        guard let sublayers = self.layer?.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
    
    public var _mutex = LLRecursiveMutex()
    open func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
        
    private func addEvents() {
        NSEvent.addLocalMonitorForEvents( matching: [.mouseMoved], handler: eventMouseMoved(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.leftMouseDown], handler: eventMouseLeftDown(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.leftMouseDragged], handler: eventMouseLeftDragged(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.leftMouseUp], handler: eventMouseLeftUp(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.rightMouseDown], handler: eventMouseRightDown(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.rightMouseDragged], handler: eventMouseRightDragged(event:) )
        NSEvent.addLocalMonitorForEvents( matching: [.rightMouseUp], handler: eventMouseRightUp(event:) )
    }

    // MARK: - イベント関数(マウス)
    open func eventMouseMoved( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow
        // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
        let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
        // LLViewのイベントを代わりに発火させる
        self.mouseMovedField.appear( LLMouseArg( pt_on_view, event ) )

        return event
    }
    
    open func eventMouseLeftDown( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
                
        if isEnabled { self.styleField.action?.appear() }
        
        let pt_on_win = event.locationInWindow
        let localPosition = self.convert( pt_on_win, to: nil ).llPoint
        
        self.actionBeganField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseLeftDownField.appear( LLMouseArg( localPosition, event ) )
        
        return event
    }
    
    open func eventMouseLeftDragged( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        let pt_on_win = event.locationInWindow
        let localPosition = self.convert( pt_on_win, to: nil ).llPoint
        // LLViewのイベントを代わりに発火させる
        self.actionMovedField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseLeftDraggedField.appear( LLMouseArg( localPosition, event ) )
            
        return event
    }
    
    open func eventMouseLeftUp( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        let localPosition = self.convert( pt_on_win, from: nil ).llPoint

        if isEnabled { self.styleField.default?.appear() }
            
        // [マウス左アップ]
        self.actionEndedField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseLeftUpField.appear( LLMouseArg( localPosition, event ) )
        
        return event
    }
    
    open func eventMouseRightDown( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }

        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        let localPosition = self.convert( pt_on_win, from: nil ).llPoint
        
        if isEnabled { self.styleField.action?.appear() }
            
        self.actionBeganField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseLeftDownField.appear( LLMouseArg( localPosition, event ) )
            
        return event
    }
    
    open func eventMouseRightDragged( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow        
        let localPosition = self.convert( pt_on_win, to: nil ).llPoint
            
        self.actionMovedField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseRightDraggedField.appear( LLMouseArg( localPosition, event ) )
        
        return event
    }
    
    open func eventMouseRightUp( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow
        let localPosition = self.convert( pt_on_win, to: nil ).llPoint
        
        if isEnabled { self.styleField.default?.appear() }
            
        // [マウス右アップ]
        self.actionEndedField.appear( LLActionArg( [ localPosition ] ) )
        self.mouseRightUpField.appear( LLMouseArg( localPosition, event ) )

        return event
    }
    
    // MARK: - イベント関数(タッチ)
    
    // TODO: タッチ処理は未実装
    
    // MARK: - イベント関数(タブレット)
    open override func tabletPoint( with event: NSEvent ) {
        if !isEnabled { return }
        LLTablet.updateState( event: event )
    }

    public func callSetupFields() {
        self.setupField.appear( LLEmpty.none )
    }
    
    public func callBuildupFields() {
        self.buildupField.appear( LLEmpty.none )
    }
    
    public func callTeardownFields() {
        self.teardownField.appear( LLEmpty.none )
    }
}

#endif
