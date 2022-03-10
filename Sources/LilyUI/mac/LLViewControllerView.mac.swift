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

open class LLViewControllerView : NSView, CALayerDelegate, LLUILifeEvent
{
    public var isUserInteractionEnabled: Bool = true
    
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    public lazy var styleField = LLViewStyleFieldMap()
    
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
        
    private weak var _vc:LLViewController?
    private weak var _capture_view:LLView?
    private weak var _dragging_view:LLView?
    
    // layer-backed NSView properties
    override open var isFlipped: Bool { return true }
    override open var wantsUpdateLayer: Bool { return true }
    
    public init( vc:LLViewController ) {
        super.init(frame: .zero)
        
        _vc = vc
        self.wantsLayer = true
        self.layer?.delegate = self
        self.layer?.contentsScale = LLSystem.retinaScale.cgf
        self.allowedTouchTypes = [.indirect]
        addEvents()
    }

    required public init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func preSetup() { }
    
    open func setup() { }
    
    open func postSetup() { 
        self.callSetupFields()
    }
    
    open func preBuildup() { }
    
    open func buildup() { }
    
    open func postBuildup() {
        self.styleField.default?.appear() 
       if !isEnabled { self.styleField.disable?.appear() }
        
        self.callBuildupFields()
        
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
    
    // 指定座標のLLViewのピック
    open func pick( _ global_pt:LLPoint ) -> ( view:LLView?, localPosition:LLPoint ) {
        let sublayers = layer?.sublayers
        if sublayers != nil {
            // 子レイヤーをzIndex順にソートし、かつ同じz深度のものは逆順にあたるようreversedをかける
            let sorted_sublayers = sublayers!.sorted { ( l1:CALayer, l2:CALayer ) -> Bool in
                return l1.zPosition > l2.zPosition
            }.reversed()
            
            for layer in sorted_sublayers {
                guard let llview = layer as? LLView else { continue }
                let result = llview.pick( global_pt )
                if result.view != nil { return ( result.view!, result.local_pt ) }
            }
        }
        return ( nil, global_pt )
    }
    
    // キャプチャしているビューの変更関数(各イベント関数内で呼び出し)
    open func changeCaptureView( target:LLView?, globalPosition: CGPoint, event: NSEvent ) {
        if _capture_view == target { return }
        if _dragging_view != nil { return }
        
        /*
        target?.igMouse.over.ignite( 
            LLMouseArg( target, pos: target!.convert(globalPosition, from: nil).llPoint, event: event )
        )
        */
        
        /*
        _capture_view?.igMouse.out.ignite(
            LLMouseArg( _capture_view, 
                        pos: _capture_view!.convert(globalPosition, from: nil).llPoint,
                        event: event ) 
        )
        */
        
        _capture_view = target
    }
        
    // MARK: - イベント関数(マウス)
    open func eventMouseMoved( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if result.view != nil {
            changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
            // LLViewのイベントを代わりに発火させる
            result.view?.mouseMovedField.appear( LLMouseArg( result.localPosition, event ) )
            
            return event
        }
        
        // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
        let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
        changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
        self.mouseMovedField.appear(
            LLMouseArg( pt_on_view, event ) 
        )
        
        return event
    }
    
    open func eventMouseLeftDown( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        let pt_on_win = event.locationInWindow

        let result = pick( pt_on_win.llPoint )
        if result.view != nil {
            _dragging_view = result.view
            changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
            
            if let v = _dragging_view, v.isEnabled { v.styleField.action?.appear() }
            
            // LLViewのイベントを代わりに発火させる
            result.view?.actionBeganField.appear( LLActionArg( [ result.localPosition ] ) )
            result.view?.mouseLeftDownField.appear( LLMouseArg( result.localPosition, event ) )
            
            return event
        }
        
        // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
        let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
        changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
        self.mouseLeftDownField.appear(
            LLMouseArg( pt_on_view, event ) 
        )
        
        return event
    }
    
    open func eventMouseLeftDragged( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        let pt_on_win = event.locationInWindow
 
        if _capture_view != nil {
            let localPosition = _capture_view!.convert( pt_on_win, to: nil ).llPoint
            // LLViewのイベントを代わりに発火させる
            _capture_view?.actionMovedField.appear( LLActionArg( [ localPosition ] ) )
            _capture_view?.mouseLeftDraggedField.appear( LLMouseArg( localPosition, event ) )
            
            return event
        }

        // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる     
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        self.mouseLeftDraggedField.appear(
            LLMouseArg( pt_on_view, event ) 
        )
        return event
    }
    
    open func eventMouseLeftUp( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow

        let result = pick( pt_on_win.llPoint )
        if _dragging_view != nil {
            if let v = _dragging_view, v.isEnabled { v.styleField.default?.appear() }
            
            // [マウス左アップ]
            _dragging_view?.actionEndedField.appear( LLActionArg( [ result.localPosition ] ) )
            _dragging_view?.mouseLeftUpField.appear( LLMouseArg( result.localPosition, event ) )

            // [UI内部マウス左アップ]
            if _dragging_view == result.view {
                _dragging_view?.mouseLeftUpInsideField.appear(
                    LLMouseArg( result.localPosition, event ) 
                )
            }
            
            _dragging_view = nil
            changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
            return event
        }

        // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
        self.mouseLeftUpField.appear(
            LLMouseArg( pt_on_view, event ) 
        )
        
        return event
    }
    
    open func eventMouseRightDown( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }

        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if result.view != nil {
            _dragging_view = result.view
            changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
            
            if let v = _dragging_view, v.isEnabled { v.styleField.action?.appear() }
            
            result.view?.actionBeganField.appear( LLActionArg( [ result.localPosition ] ) )
            result.view?.mouseLeftDownField.appear( LLMouseArg( result.localPosition, event ) )
            
            return event
        }
        
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
        self.mouseRightDownField.appear(
            LLMouseArg( pt_on_view, event ) 
        )
        
        return event
    }
    
    open func eventMouseRightDragged( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow
        
        if _capture_view != nil {            
            let localPosition = _capture_view!.convert( pt_on_win, to: nil ).llPoint
            
            _capture_view?.actionMovedField.appear( LLActionArg( [ localPosition ] ) )
            _capture_view?.mouseRightDraggedField.appear( LLMouseArg( localPosition, event ) )
       
            return event
        }
   
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        self.mouseRightDraggedField.appear(
            LLMouseArg( pt_on_view, event )
        )
        
        return event
    }
    
    open func eventMouseRightUp( event:NSEvent ) -> NSEvent? {
        if !isEnabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if _dragging_view != nil {
            if let v = _dragging_view, v.isEnabled { v.styleField.default?.appear() }
            
            // [マウス右アップ]
            _dragging_view?.actionEndedField.appear( LLActionArg( [ result.localPosition ] ) )
            _dragging_view?.mouseRightUpField.appear( LLMouseArg( result.localPosition, event ) )
            
            // [UI内部マウス右アップ]
            if _dragging_view == result.view {
                _dragging_view?.mouseRightUpInsideField.appear( 
                    LLMouseArg( result.localPosition, event )
                )
            }
            
            _dragging_view = nil
            changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
            return event
        }
        
        let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
        changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
        self.mouseRightUpField.appear(
            LLMouseArg( pt_on_view, event )
        )

        return event
    }
    
    // MARK: - イベント関数(タッチ)
    
    // TODO: タッチ処理は未実装
    //private var _current_touches_state = LLTouchesState()
    
    open override func touchesBegan( with event: NSEvent ) {
        if !isEnabled { return }
        
        /*
        let touches = event.touches( for: self )
        let preview_touches_state = _current_touches_state
        _current_touches_state = LLTouchesState( touches )
        */
        
        let pt_on_win = event.locationInWindow
        let result = pick( pt_on_win.llPoint )
        if( result.view != nil ) {
            /*
            let arg = LLIndirectTouchArg( result.view,
                                          cursor_pos: pt_on_win.llPoint,
                                          preview:preview_touches_state,
                                          current:_current_touches_state,
                                          event: event )
            result.view?.igTouch.began.ignite( arg )
            */
            return
        }
        
        /*
        let arg = LLIndirectTouchArg( _vc,
                                      cursor_pos: pt_on_win.llPoint,
                                      preview:preview_touches_state,
                                      current:_current_touches_state,
                                      event: event )
        _vc?.igTouch.began.ignite( arg )
        */
    }
    
    open override func touchesMoved( with event: NSEvent ) {
        if !isEnabled { return }
        
        /*
        let touches = event.touches( for: self )
        
        let preview_touches_state = _current_touches_state
        _current_touches_state = LLTouchesState( touches )
        */
        
        let pt_on_win = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if result.view != nil {
            /*
            let arg = LLIndirectTouchArg( result.view,
                                          cursor_pos: pt_on_win.llPoint,
                                          preview:preview_touches_state,
                                          current:_current_touches_state,
                                          event: event )
            result.view?.igTouch.moved.ignite( arg )
            */
            return
        }
        
        /*
        let arg = LLIndirectTouchArg( _vc,
                                      cursor_pos: pt_on_win.llPoint,
                                      preview:preview_touches_state,
                                      current:_current_touches_state,
                                      event: event )
        _vc?.igTouch.moved.ignite( arg )
        */
    }
    
    open override func touchesEnded( with event: NSEvent ) {
        if !isEnabled { return }
        
        /*
        let touches = event.touches( for: self )
        let preview_touches_state = _current_touches_state
        _current_touches_state = LLTouchesState( touches )
        */
        
        let pt_on_win = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if( result.view != nil ) {
            /*
            let arg = LLIndirectTouchArg( result.view,
                                          cursor_pos: pt_on_win.llPoint,
                                          preview:preview_touches_state,
                                          current:_current_touches_state,
                                          event: event )
            result.view?.igTouch.ended.ignite( arg )
            */
            return
        }
        
        /*
        let arg = LLIndirectTouchArg( _vc,
                                      cursor_pos: pt_on_win.llPoint,
                                      preview:preview_touches_state,
                                      current:_current_touches_state,
                                      event: event )
        _vc?.igTouch.ended.ignite( arg )
        */
    }
    
    open override func touchesCancelled( with event: NSEvent ) {
        if !isEnabled { return }
        
        /*
        let touches = event.allTouches()
        let preview_touches_state = _current_touches_state
        _current_touches_state = LLTouchesState( touches )
        */
        
        let pt_on_win = event.locationInWindow
 
        let result = pick( pt_on_win.llPoint )
        if( result.view != nil ) {
            /*
            let arg = LLIndirectTouchArg( result.view,
                                          cursor_pos: pt_on_win.llPoint,
                                          preview:preview_touches_state,
                                          current:_current_touches_state,
                                          event: event )
            result.view?.igTouch.cancelled.ignite( arg )
            */
            return
        }
        
        /*
        let arg = LLIndirectTouchArg( _vc,
                                      cursor_pos: pt_on_win.llPoint,
                                      preview:preview_touches_state,
                                      current:_current_touches_state,
                                      event: event )
        _vc?.igTouch.cancelled.ignite( arg )
        */
    }
    
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
