//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal
import QuartzCore

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension Lily.View.Playground2D
{ 
    open class PGViewController : Lily.View.ViewController
    {
        lazy var device:MTLDevice? = MTLCreateSystemDefaultDevice()
        var renderEngine:Lily.Stage.StandardRenderEngine?
        var renderFlow:Lily.Stage.Playground2D.RenderFlow?
        
        #if os(iOS) || os(visionOS)
        public lazy var metalView = Lily.View.MetalView( device:device! )
        .setup( caller:self ) { me, vc in
            me
            .bgColor( .grey )
        }
        .buildup( caller:self ) { me, vc in
            PGScreen.current = self
            
            vc.removeAllShapes()
            
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
            }
            
            vc.buildupHandler?()
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            Lily.Stage.Playground2D.PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.loopHandler?()
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in
                    //commandBuffer?.waitUntilCompleted() 
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }
        .touchesBegan( caller:self )
        { me, caller, args in
            for touch in args.touches {
                caller.touchManager.allTouches.append( touch )
            }
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        .touchesMoved( caller:self ) { me, caller, args in
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        .touchesEnded( caller:self ) { me, caller, args in
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
            
            for i in (0 ..< caller.touchManager.allTouches.count).reversed() {
                for touch in args.touches {
                    if touch == caller.touchManager.allTouches[i] {
                        caller.touchManager.allTouches.remove( at:i )
                        break
                    }
                }
            }
        }
        .touchesCancelled( caller:self ) { me, caller, args in
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        
        #elseif os(macOS)
        public lazy var metalView = Lily.View.MetalView( device:device! )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
        }
        .buildup( caller:self ) { me, vc in
            PGScreen.current = self
            
            vc.removeAllShapes()
            
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
            }
            
            vc.buildupHandler?()
            vc.renderFlow?.pool.storage?.statuses?.commit()
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            Lily.Stage.Playground2D.PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.loopHandler?()
            vc.renderFlow?.pool.storage?.statuses?.commit()
            
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in
                    //commandBuffer?.waitUntilCompleted() 
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }
        // TODO: イベントつくる
        /*
        .mouseLeftDown( caller:self ) { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.began, event:args.event )
        }
        .mouseLeftDragged( caller:self ) { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.moved, event:args.event )
        }
        .mouseLeftUp( caller:self ) { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.ended, event:args.event )
        }
        */
        #endif
        
        public var clearColor:LLColor = .white

        public let touchManager = PGTouchManager()
        public var touches:[PGTouch] { return touchManager.touches }
        public var releases:[PGTouch] { return touchManager.releases }
        
        public var coordMinX:Double { -(metalView.width * 0.5) }
        public var coordMaxX:Double { metalView.width * 0.5 }
        public var coordMinY:Double { -(metalView.height * 0.5) }
        public var coordMaxY:Double { metalView.height * 0.5 }
        
        public var screenSize:LLSizeFloat { LLSizeFloat( width, height ) }
        
        public var coordRegion:LLRegion { 
            return LLRegion(
                left:coordMinX,
                top:coordMaxY,
                right:coordMaxX,
                bottom:coordMinY 
            )
        }
        
        public var shapes:Set<Lily.Stage.Playground2D.PGActor> { renderFlow!.pool.shapes }
        // TODO: 表示からの経過時間(sharedを避けたい)
        public var elapsedTime:Double { Lily.Stage.Playground2D.PGActor.ActorTimer.shared.elapsedTime }
        
        // 外部処理ハンドラ 
        open var buildupHandler:(()->Void)?
        open var loopHandler:(()->Void)?
        
        func checkShapesStatus() {
            for actor in renderFlow!.pool.shapes {
                // イテレート処理
                actor.appearIterate()
                // インターバル処理
                actor.appearInterval()
                
                if actor.life <= 0.0 {
                    // 完了前処理
                    actor.appearCompletion()
                    // 削除処理
                    actor.checkRemove()
                }
            }
        }
        
        func removeAllShapes() {
            renderFlow!.pool.removeAllShapes()
        }
        
        func setupKeyInput() {
            #if os(macOS)
            let options:NSTrackingArea.Options = [.activeAlways, .inVisibleRect, .mouseEnteredAndExited, .mouseMoved]
            let area = NSTrackingArea( rect:metalView.bounds, options:options, owner: self, userInfo: nil )
            self.view.addTrackingArea( area )
            #endif
        }
        
        #if os(macOS)
        // TODO: イベント系を整理したら削除する
        public var mousedownHandler:(()->Void)?
        open override func mouseDown(with event: NSEvent) {
            super.mouseDown( with: event )
            mousedownHandler?()
        }
        #endif
                
        open override func setup() {
            super.setup()
            addSubview( metalView )
            
            setupKeyInput()
            
            renderFlow = .init( device:device!, viewCount:1 )
            
            renderEngine = .init( 
                device:device!,
                size:CGSize( 320, 240 ),
                renderFlow:renderFlow!
            )

            // 時間の初期化
            Lily.Stage.Playground2D.PGActor.ActorTimer.shared.start()
                        
            startLooping()
        }
        
        open override func loop() {
            super.loop()
            metalView.drawMetal()
        }
        
        open override func teardown() {
            endLooping()
        }
    }
}

#if os(iOS)
extension Lily.View.Playground2D.PGViewController
{
    public typealias Here = Lily.View.Playground2D
    public func recogizeTouches( touches all_touches:[UITouch] ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // タッチ数
        var idx = 0
        for touch in all_touches {
            // point座標系を取得
            let lt_pos = touch.location( in: self.view )
            
            // MetalViewの中心座標を取得(TODO: self.viewとmetalViewの関係を簡潔にしたい)
            let o = metalView.center
            
            let pix_o_pos = LLPointFloat( lt_pos.x - o.x, -(lt_pos.y - o.y) )
            let pix_lt_pos = LLPointFloat( lt_pos.x, lt_pos.y )
            var state:Here.PGTouch.State = .release
            
            switch touch.phase {
                case .began: state = .began
                case .moved: state = .touch
                case .stationary: state = .touch
                case .ended: state = .release
                case .cancelled: state = .release
                default: state = .release
            }
            
            let lb_touch = Here.PGTouch(
                xy: pix_o_pos,  // 中心を0とした座標
                uv: pix_lt_pos, // 左上を0とした座標
                state: state    // タッチ状態
            )
            
            if touch.phase == .began {
                self.touchManager.starts[idx] = lb_touch
            }            
            self.touchManager.units[idx] = lb_touch
            self.touchManager.units[idx].startPos = self.touchManager.starts[idx].xy
            
            idx += 1
            if idx >= self.touchManager.units.count { break }
        }
    }
}
#endif

#if os(macOS)
extension Lily.View.Playground2D.PGViewController
{
    public typealias Here = Lily.View.Playground2D
    public func recogizeMouse( pos:LLPoint, phase:Here.MacOSMousePhase, event:NSEvent? ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // MetalViewの中心座標を取得
        let o = metalView.center
            
        let pix_o_pos  = LLPointFloat( pos.x.cgf - o.x, -(pos.y.cgf - o.y) )
        let pix_lt_pos = LLPointFloat( pos.x, pos.y )
        var state:Here.PGTouch.State = .release
        
        switch phase {
            case .began: state = .began
            case .moved: state = .touch
            case .stationary: state = .touch
            case .ended: state = .release
            case .cancelled: state = .release
        }
 
        let pg_touch = Here.PGTouch(
            xy: pix_o_pos,  // 中心を0とした座標
            uv: pix_lt_pos, // 左上を0とした座標
            state: state    // タッチ状態
        )

        if phase == .began {
            self.touchManager.starts[0] = pg_touch
        }        
        self.touchManager.units[0] = pg_touch
        self.touchManager.units[0].startPos = self.touchManager.starts[0].xy
    }
}
#endif
