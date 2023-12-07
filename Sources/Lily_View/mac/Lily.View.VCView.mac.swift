//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Foundation
import AppKit
import QuartzCore

extension Lily.View
{
    open class VCView 
    : NSView
    , CALayerDelegate
    , LLUILifeEvent
    {
        public struct MouseObj 
        {
            public let position:LLPoint
            public let event:NSEvent?
        }
        
        public struct TouchObj 
        {
            public var touches:Set<NSTouch> 
            public var event:NSEvent?
        }
        
        public typealias Me = Lily.View.VCView
        public typealias MouseField = Lily.Field.ViewEvent<Me, MouseObj>
        public typealias TouchField = Lily.Field.ViewEvent<Me, TouchObj>
        
        public var isUserInteractionEnabled: Bool = true
     
        public var setupField:(any LLField)?
        public var buildupField:(any LLField)?
        public var teardownField:(any LLField)?
        public func setup() {}
        public func buildup() {}
        public func teardown() {}
        
        public var mouseMovedField:MouseField?
        public var mouseLeftDownField:MouseField?
        public var mouseLeftDraggedField:MouseField?
        public var mouseLeftUpField:MouseField?
        public var mouseLeftUpInsideField:MouseField?
        public var mouseRightDownField:MouseField?
        public var mouseRightDraggedField:MouseField?
        public var mouseRightUpField:MouseField?
        public var mouseRightUpInsideField:MouseField?
        public var mouseOverField:MouseField?
        public var mouseOutField:MouseField?
        
        public var touchesBeganField:TouchField?
        public var touchesMovedField:TouchField?
        public var touchesEndedField:TouchField?
        public var touchesCancelledField:TouchField?
                 
        private weak var _vc:ViewController?
        private weak var _capture_view:BaseView?
        private weak var _dragging_view:BaseView?
        
        // layer-backed NSView properties
        override open var isFlipped: Bool { return true }
        override open var wantsUpdateLayer: Bool { return true }
        
        public init( vc:ViewController ) {
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
        
        public var _mutex = Lily.View.RecursiveMutex()
        
        private func addEvents() {

            NSEvent.addLocalMonitorForEvents( 
                matching: [.mouseMoved], 
                handler: eventMouseMoved(event:) 
            )
            NSEvent.addLocalMonitorForEvents( 
                matching: [.leftMouseDown, .leftMouseDragged, .leftMouseUp],
                handler: eventMouseLeft(event:)
            )
            NSEvent.addLocalMonitorForEvents(
                matching: [.rightMouseDown, .rightMouseDragged, .rightMouseUp],
                handler: eventMouseRight(event:) 
            )
        }
        
        // 指定座標のBaseViewのピック
        open func pick( _ global_pt:LLPoint ) -> ( view:BaseView?, localPosition:LLPoint ) {
            let sublayers = layer?.sublayers
            if sublayers != nil {
                // 子レイヤーをzIndex順にソートし、かつ同じz深度のものは逆順にあたるようreversedをかける
                let sorted_sublayers = sublayers!.sorted { ( l1:CALayer, l2:CALayer ) -> Bool in
                    return l1.zPosition > l2.zPosition
                }.reversed()
                
                for layer in sorted_sublayers {
                    guard let llview = layer as? BaseView else { continue }
                    let result = llview.pick( global_pt )
                    if result.view != nil { return ( result.view!, result.local_pt ) }
                }
            }
            return ( nil, global_pt )
        }
        
        // キャプチャしているビューの変更関数(各イベント関数内で呼び出し)
        open func changeCaptureView( target:BaseView?, globalPosition: CGPoint, event:NSEvent ) {
            if _capture_view == target { return }
            if _dragging_view != nil { return }
        
            target?.mouseOverField?.appear(
                .init( position:target!.convert(globalPosition, from: nil).llPoint, event:event )
            ) 
            
            _capture_view?.mouseOutField?.appear(
                .init( position:_capture_view!.convert(globalPosition, from: nil).llPoint, event:event )
            )
                         
            _capture_view = target
        }
        
        // MARK: - イベント関数(マウス)
        open func eventMouseMoved( event:NSEvent ) -> NSEvent? {
            if !isEnabled { return event }
            
            Tablet.updateState( event: event )
            
            let pt_on_win = event.locationInWindow

            let result = pick( pt_on_win.llPoint )
            if result.view != nil {
                changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
                // ターゲットのviewのイベントを起こす
                result.view?.mouseMovedField?.appear( .init( position:result.localPosition, event:event ) )
                return event
            }

            // 該当するビューがなかった場合、VCView自身のイベントフィールドを起こす
            let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
            changeCaptureView( target: nil, globalPosition: pt_on_win, event: event )
            self.mouseMovedField?.appear( .init( position:pt_on_view, event:event ) )

            return event
        }

        open func eventMouseLeft( event:NSEvent ) -> NSEvent? {
            if !isEnabled { return event }
            
            Tablet.updateState( event: event )
            
            let pt_on_win = event.locationInWindow

            let result = pick( pt_on_win.llPoint )
            if result.view != nil {
                // ターゲットのviewのイベントを起こす
                switch( event.type ) {
                case .leftMouseDown:
                    _dragging_view = result.view
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                    result.view?.mouseLeftDownField?.appear( .init( position:result.localPosition, event:event ) )
                case .leftMouseDragged:
                    _dragging_view = result.view
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                    result.view?.mouseLeftDraggedField?.appear( .init( position:result.localPosition, event:event ) )    
                case .leftMouseUp:
                    // [マウス左アップ]
                    _dragging_view?.mouseLeftUpField?.appear( .init( position:result.localPosition, event:event ) )
                    // [UI内部マウス左アップ]
                    if _dragging_view == result.view {
                        _dragging_view?.mouseLeftUpInsideField?.appear( .init( position:result.localPosition, event:event ) )
                    }
                    _dragging_view = nil
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
                default: break
                }
                return event
            }

            // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
            let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
            switch( event.type ) {
            case .leftMouseDown:
                _dragging_view = result.view
                changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                self.mouseLeftDownField?.appear( .init( position:pt_on_view, event:event ) )
            case .leftMouseDragged:
                _dragging_view = result.view
                changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                self.mouseLeftDraggedField?.appear( .init( position:pt_on_view, event:event ) )   
            case .leftMouseUp:
                self.mouseLeftUpField?.appear( .init( position:pt_on_view, event:event ) )
                changeCaptureView( target: nil, globalPosition:pt_on_win, event: event )
            default: break
            }
            
            return event
        }
        
        open func eventMouseRight( event:NSEvent ) -> NSEvent? {
            if !isEnabled { return event }
            
            Tablet.updateState( event: event )
            
            let pt_on_win = event.locationInWindow

            let result = pick( pt_on_win.llPoint )
            if result.view != nil {
                // ターゲットのviewのイベントを起こす
                switch( event.type ) {
                case .leftMouseDown:
                    _dragging_view = result.view
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                    result.view?.mouseRightDownField?.appear( .init( position:result.localPosition, event:event ) )
                case .leftMouseDragged:
                    _dragging_view = result.view
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                    result.view?.mouseRightDraggedField?.appear( .init( position:result.localPosition, event:event ) )    
                case .leftMouseUp:
                    // [マウス左アップ]
                    _dragging_view?.mouseRightUpField?.appear( .init( position:result.localPosition, event:event ) )
                    // [UI内部マウス左アップ]
                    if _dragging_view == result.view {
                        _dragging_view?.mouseRightUpInsideField?.appear( .init( position:result.localPosition, event:event ) )
                    }
                    _dragging_view = nil
                    changeCaptureView( target: result.view, globalPosition: pt_on_win, event: event )
                default: break
                }
                return event
            }

            // 該当するビューがなかった場合、ビューコントローラのビューイベントを発火させる
            let pt_on_view = self.convert( pt_on_win, from: nil ).llPoint
            switch( event.type ) {
            case .leftMouseDown:
                _dragging_view = result.view
                changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                self.mouseRightDownField?.appear( .init( position:pt_on_view, event:event ) )
            case .leftMouseDragged:
                _dragging_view = result.view
                changeCaptureView( target: result.view, globalPosition: pt_on_win, event:event )
                self.mouseRightDraggedField?.appear( .init( position:pt_on_view, event:event ) )   
            case .leftMouseUp:
                self.mouseRightUpField?.appear( .init( position:pt_on_view, event:event ) )
                changeCaptureView( target: nil, globalPosition:pt_on_win, event: event )
            default: break
            }
            
            return event
        }
        
        // MARK: - イベント関数(タッチ)
        
        open override func touchesBegan( with event:NSEvent ) {
            if !isEnabled { return }
            
            let touches = event.touches( for:self )
            let pt_on_win = event.locationInWindow
            let result = pick( pt_on_win.llPoint )
            
            if result.view != nil {
                result.view?.touchesBeganField?.appear( .init( touches:touches, event:event ) )
                return
            }
            
            self.touchesBeganField?.appear( .init( touches:touches, event:event ) )
        }
        
        open override func touchesMoved( with event: NSEvent ) {
            if !isEnabled { return }
            
            let touches = event.touches( for: self )
            let pt_on_win = event.locationInWindow
            let result = pick( pt_on_win.llPoint )
            
            if result.view != nil {
                result.view?.touchesMovedField?.appear( .init( touches:touches, event:event ) )
                return
            }
            
            self.touchesMovedField?.appear( .init( touches:touches, event:event ) )
        }
        
        open override func touchesEnded( with event: NSEvent ) {
            if !isEnabled { return }
            
            let touches = event.touches( for: self )
            let pt_on_win = event.locationInWindow
            let result = pick( pt_on_win.llPoint )
            
            if result.view != nil {
                result.view?.touchesEndedField?.appear( .init( touches:touches, event:event ) )
                return
            }
            
            self.touchesEndedField?.appear( .init( touches:touches, event:event ) )
        }
        
        open override func touchesCancelled( with event: NSEvent ) {
            if !isEnabled { return }
            
            let touches = event.touches( for: self )
            let pt_on_win = event.locationInWindow
            let result = pick( pt_on_win.llPoint )
            
            if result.view != nil {
                result.view?.touchesCancelledField?.appear( .init( touches:touches, event:event ) )
                return
            }
            
            self.touchesCancelledField?.appear( .init( touches:touches, event:event ) )
        }
        
        // MARK: - イベント関数(タブレット)
        open override func tabletPoint( with event: NSEvent ) {
            if !isEnabled { return }
            Tablet.updateState( event: event )
        }
    }
}

#endif
