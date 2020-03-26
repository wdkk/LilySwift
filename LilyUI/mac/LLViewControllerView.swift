//
// LLViewControllerView.swift
// Lily Library
//
// Copyright (c) 2017- Watanabe-DENKI Inc.
//   https://wdkk.co.jp/
//

import Foundation
import Cocoa
import QuartzCore

open class LLViewControllerView : NSView, CALayerDelegate, LLUILifeEvent
{
    public lazy var assemble = LLViewFieldContainer()
    public lazy var design = LLViewFieldContainer()
    public lazy var disassemble = LLViewFieldContainer()
        
    private weak var _vc:LLViewController?
    private weak var _capture_view:LLViewBase?
    private weak var _dragging_view:LLViewBase?
    
    open var enabled:Bool = true
    
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
    
    public func setup() { }
    
    public func postSetup() { }
    
    public func buildup() { }
    
    public func postBuildup() {
        self.callDesignFunction()
        
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
    
    public func teardown() {
        self.callDisassembleFunction()
         
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
    
    public func rebuild() {
        self.buildup()
        self.postBuildup()
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
    open func pick( _ global_pt: LLPoint ) -> ( view:LLViewBase?, local_pt:LLPoint ) {
        let sublayers = layer?.sublayers
        if sublayers != nil {
            // 子レイヤーをzIndex順にソートし、かつ同じz深度のものは逆順にあたるようreversedをかける
            let sorted_sublayers = sublayers!.sorted { ( l1:CALayer, l2:CALayer ) -> Bool in
                return l1.zPosition > l2.zPosition
            }.reversed()
            
            for layer in sorted_sublayers {
                if !(layer is LLViewBase) { continue }
                let result = (layer as! LLViewBase).pick( global_pt )
                if result.view != nil { return result }
            }
        }
        return ( nil, global_pt )
    }
    
    // キャプチャしているビューの変更関数(各イベント関数内で呼び出し)
    open func changeCaptureView( target:LLViewBase?, global_pos: CGPoint, event: NSEvent ) {
        if _capture_view == target { return }
        if _dragging_view != nil { return }
        
        /*
        target?.igMouse.over.ignite( 
            LLMouseArg( target, pos: target!.convert(global_pos, from: nil).llPoint, event: event )
        )
        */
        
        /*
        _capture_view?.igMouse.out.ignite(
            LLMouseArg( _capture_view, 
                        pos: _capture_view!.convert(global_pos, from: nil).llPoint,
                        event: event ) 
        )
        */
        
        _capture_view = target
    }
        
    // MARK: - イベント関数(マウス)
    open func eventMouseMoved( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if result.view != nil {
            changeCaptureView( target: result.view, global_pos: pt_on_win, event: event )
            /*
            result.view?.igMouse.move.ignite( LLMouseArg( result.view, pos: result.local_pt, event: event ) )
            */
            return event
        }
        
        /*
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, global_pos: pt_on_win, event: event )
        _vc?.igMouse.move.ignite( LLMouseArg( _vc, pos: pt_on_view, event: event ) )
        */
        
        return event
    }
    
    open func eventMouseLeftDown( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        let pt_on_win  = event.locationInWindow

        let result = pick( pt_on_win.llPoint )
        if( result.view != nil ) {
            _dragging_view = result.view
            changeCaptureView( target: result.view, global_pos: pt_on_win, event: event )
            /*
            result.view?.igMouse.leftDown.ignite( LLMouseArg( result.view, pos: result.local_pt, event: event ) )
            */
            return event
        }
        
        /*
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, global_pos: pt_on_win, event: event )
        _vc?.igMouse.leftDown.ignite( LLMouseArg( _vc, pos: pt_on_view, event: event ) )
        */
        return event
    }
    
    open func eventMouseLeftDragged( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        
        //let pt_on_win = event.locationInWindow
 
        if( _capture_view != nil ) {
            /*
            let local_pt = _capture_view!.convert( pt_on_win, to: nil ).llPoint
            _capture_view?.igMouse.leftDragged.ignite( LLMouseArg( _capture_view, pos: local_pt, event: event ) )
            */
            return event
        }

        /*        
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        _vc?.igMouse.leftDragged.ignite( LLMouseArg( _vc, pos: pt_on_view, event: event ) )
        */
        return event
    }
    
    open func eventMouseLeftUp( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow

        let result = pick( pt_on_win.llPoint )
        if( _dragging_view != nil ) {
            // [マウス左アップ]
            /*
            _dragging_view?.igMouse.leftUp.ignite( 
                LLMouseArg( _dragging_view, pos: result.local_pt, event: event ) 
            )
            */
            // [UI内部マウス左アップ]
            if _dragging_view == result.view {
                /*
                _dragging_view?.igMouse.leftUpInside.ignite(
                    LLMouseArg( _dragging_view, pos: result.local_pt, event: event ) 
                )
                */
            }
            _dragging_view = nil
            changeCaptureView( target: result.view, global_pos: pt_on_win, event: event )
            return event
        }

        /*        
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, global_pos: pt_on_win, event: event )
        _vc?.igMouse.leftUp.ignite( LLMouseArg( _vc, pos: pt_on_view, event: event ) )
        */
        return event
    }
    
    open func eventMouseRightDown( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }

        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if( result.view != nil ) {
            _dragging_view = result.view
            /*
            changeCaptureView( target: result.view, global_pos: pt_on_win, event: event )
            result.view?.igMouse.rightDown.ignite( 
                LLMouseArg( result.view, pos: result.local_pt, event: event ) 
            )
            */
            return event
        }
        
        /*
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        changeCaptureView( target: nil, global_pos: pt_on_win, event: event )
        _vc?.igMouse.rightDown.ignite(
            LLMouseArg( _vc, pos: pt_on_view, event: event )
        )
        */
        return event
    }
    
    open func eventMouseRightDragged( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        
        //let pt_on_win = event.locationInWindow
        
        if( _capture_view != nil ) {
            /*
            let local_pt = _capture_view!.convert( pt_on_win, to: nil ).llPoint
            _capture_view?.igMouse.rightDragged.ignite( 
                LLMouseArg( _capture_view, pos: local_pt, event: event )
            )
            */
            return event
        }

        /*        
        let pt_on_view = self.convert(pt_on_win, from: nil).llPoint
        _vc?.igMouse.rightDragged.ignite(
            LLMouseArg( _vc, pos: pt_on_view, event: event )
        )
        */
        return event
    }
    
    open func eventMouseRightUp( event:NSEvent ) -> NSEvent? {
        if !enabled { return event }
        
        LLTablet.updateState( event: event )
        
        let pt_on_win  = event.locationInWindow
        
        let result = pick( pt_on_win.llPoint )
        if( _dragging_view != nil ) {
            // [マウス右アップ]
            //_dragging_view?.igMouse.rightUp.ignite( 
            //    LLMouseArg( _dragging_view, pos: result.local_pt, event: event )
            //)
            
            // [UI内部マウス右アップ]
            if _dragging_view == result.view {
                //_dragging_view?.igMouse.rightUpInside.ignite( 
                //    LLMouseArg( _dragging_view, pos: result.local_pt, event: event )
                //)
            }
            _dragging_view = nil
            changeCaptureView( target: result.view, global_pos: pt_on_win, event: event )
            return event
        }
        
        /*
        let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
        changeCaptureView( target: nil, global_pos: pt_on_win, event: event )
        _vc?.igMouse.rightUp.ignite( LLMouseArg( _vc, pos: pt_on_view, event: event ) )
        */
        return event
    }
    
    // MARK: - イベント関数(タッチ)
    //private var _current_touches_state = LLTouchesState()
    
    open override func touchesBegan( with event: NSEvent ) {
        if !enabled { return }
        
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
        if !enabled { return }
        
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
        if !enabled { return }
        
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
        if !enabled { return }
        
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
        if !enabled { return }
        
        LLTablet.updateState( event: event )
    }
}

extension LLViewControllerView : LLViewFieldCallable
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
