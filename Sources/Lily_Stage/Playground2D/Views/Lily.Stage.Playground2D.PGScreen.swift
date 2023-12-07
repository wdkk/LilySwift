//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

extension Lily.Stage.Playground2D
{ 
    open class PGScreen
    : Lily.View.ViewController
    {
        var device:MTLDevice
        var renderEngine:Lily.Stage.StandardRenderEngine?
        var renderFlow:RenderFlow?
        
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
        
        public var randomPoint:LLPoint { coordRegion.randomPoint }
        
        // MARK: - タッチ情報ヘルパ
        private var latest_touch = PGTouch( xy:.zero, uv: .zero, state:.touch )
        public var latestTouch:PGTouch {
            if let touch = touches.first { latest_touch = touch }
            return latest_touch
        }
        
        // MARK: - パーティクル情報
        public var shapes:Set<PGActor> { renderFlow!.pool.shapes }
        // TODO: 表示からの経過時間(sharedを避けたい)
        public var elapsedTime:Double { PGActor.ActorTimer.shared.elapsedTime }
        
        // 外部処理ハンドラ 
        open var buildupHandler:(( PGScreen )->Void)?
        open var loopHandler:(( PGScreen )->Void)?
        
        #if os(iOS) || os(visionOS)
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
        }
        .buildup( caller:self ) { me, vc in
            vc.removeAllShapes()
            
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
            }
            
            vc.buildupHandler?( self )
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.loopHandler?( self )
            // 変更の確定
            vc.renderFlow?.pool.storage?.statuses?.commit()
            vc.renderFlow?.clearColor = self.clearColor
            
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }
        .touchesBegan( caller:self )
        { me, vc, args in
            args.touches.forEach { vc.touchManager.allTouches.append( $0 ) }
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        .touchesMoved( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        .touchesEnded( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
            
            for i in (0 ..< vc.touchManager.allTouches.count).reversed() {
                args.touches
                .filter { $0 == vc.touchManager.allTouches[i] }
                .forEach { _ in vc.touchManager.allTouches.remove( at:i ) }
            }
        }
        .touchesCancelled( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        
        #elseif os(macOS)
        public lazy var metalView = Lily.View.MetalView( device:device! )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
        }
        .buildup( caller:self ) { me, vc in
            vc.removeAllShapes()
            
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
            }
            
            vc.buildupHandler?( self )
            vc.renderFlow?.pool.storage?.statuses?.commit()
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.loopHandler?( self )
            // 変更の確定
            vc.renderFlow?.pool.storage?.statuses?.commit()
            vc.renderFlow?.clearColor = self.clearColor
            
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }
        .mouseLeftDown( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.began, event:args.event )
        }
        .mouseLeftDragged( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.moved, event:args.event )
        }
        .mouseLeftUp( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.ended, event:args.event )
        }
        #endif
                
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
        
        public init( device:MTLDevice ) {
            self.device = device
            super.init()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func setup() {
            super.setup()
            addSubview( metalView )
            
            renderFlow = .init( device:device, viewCount:1 )
            
            renderEngine = .init( device:device, size:CGSize( 320, 240 ), renderFlow:renderFlow! )

            // 時間の初期化
            PGActor.ActorTimer.shared.start()
                        
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

#if os(iOS) || os(visionOS)
extension Lily.Stage.Playground2D.PGScreen
{
    public typealias Here = Lily.Stage.Playground2D
    public func recogizeTouches( touches allTouches:[UITouch] ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // タッチ数
        var idx = 0
        for touch in allTouches {
            // point座標系を取得
            let lt_pos = touch.location( in: self.view )
            
            // MetalViewの中心座標を取得
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
            
            let pg_touch = Here.PGTouch(
                xy: pix_o_pos,  // 中心を0とした座標
                uv: pix_lt_pos, // 左上を0とした座標
                state: state    // タッチ状態
            )
            
            if touch.phase == .began { self.touchManager.starts[idx] = pg_touch }            
            self.touchManager.units[idx] = pg_touch
            self.touchManager.units[idx].startPos = self.touchManager.starts[idx].xy
            
            idx += 1
            if idx >= self.touchManager.units.count { break }
        }
    }
}
#endif

#if os(macOS)
extension Lily.Stage.Playground2D.PGScreen
{
    public typealias Here = Lily.Stage.Playground2D
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

        if phase == .began { self.touchManager.starts[0] = pg_touch }        
        self.touchManager.units[0] = pg_touch
        self.touchManager.units[0].startPos = self.touchManager.starts[0].xy
    }
}
#endif
