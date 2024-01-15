//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

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
        public static var current:PGScreen? = nil
        
        var device:MTLDevice
        
        public var renderEngine:Lily.Stage.StandardRenderEngine?
        
        public var renderFlow:PlaneRenderFlow
        public var sRGBRenderFlow:SRGBRenderFlow
        
        public var mediumTextures:Lily.Stage.Playground2D.MediumTextures
        
        public var environment:Lily.Stage.ShaderEnvironment
        public var particleCapacity:Int
        public var textures:[String]
        public var clearColor:LLColor = .white

        public let touchManager = PGTouchManager()
        public var touches:[PGTouch] { return touchManager.touches }
        public var releases:[PGTouch] { return touchManager.releases }
        
        public var minX:Double { -(metalView.width * 0.5) }
        public var maxX:Double { metalView.width * 0.5 }
        public var minY:Double { -(metalView.height * 0.5) }
        public var maxY:Double { metalView.height * 0.5 }
        
        public var screenSize:LLSizeFloat { .init( width, height ) }
        
        public var coordRegion:LLRegion { .init( left:minX, top:maxY, right:maxX, bottom:minY ) }
        
        public var randomPoint:LLPoint { coordRegion.randomPoint }
        
        // MARK: - タッチ情報ヘルパ
        private var latest_touch = PGTouch( xy:.zero, uv: .zero, state:.touch )
        public var latestTouch:PGTouch {
            if let touch = touches.first { latest_touch = touch }
            return latest_touch
        }
        
        // MARK: - パーティクル情報
        public var shapes:Set<PGActor> { return PGPool.shared.shapes( on:renderFlow.storage ) }
        
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGScreen )->Void)?
        public var pgUpdateHandler:(( PGScreen )->Void)?
        private var _design_once_flag = false
        
        #if os(iOS) || os(visionOS)
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
            me.isMultipleTouchEnabled = true
            vc._design_once_flag = false
        }
        .buildup( caller:self ) { me, vc in
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
                vc.mediumTextures.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
            }
            
            if !vc._design_once_flag {
                PGScreen.current = vc
                
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.renderFlow.storage.statuses.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            PGScreen.current = vc
            // 時間の更新
            PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.renderFlow.storage.statuses.commit()
            vc.renderFlow.clearColor = self.clearColor
            
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
        .touchesBegan( caller:self ) { me, vc, args in
            vc.touchManager.allTouches.removeAll()
            args.event?.allTouches?.forEach { vc.touchManager.allTouches.append( $0 ) }
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        .touchesMoved( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        .touchesEnded( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
            
            for i in (0 ..< vc.touchManager.allTouches.count).reversed() {
                args.event?.allTouches?
                .filter { $0 == vc.touchManager.allTouches[i] }
                .forEach { _ in vc.touchManager.allTouches.remove( at:i ) }
            }
        }
        .touchesCancelled( caller:self ) { me, vc, args in
            vc.recogizeTouches( touches:vc.touchManager.allTouches )
        }
        
        #elseif os(macOS)
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
            vc._design_once_flag = false
        }
        .buildup( caller:self ) { me, vc in
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
                vc.mediumTextures.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
            }
            
            if !vc._design_once_flag {
                PGScreen.current = vc
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.renderFlow.storage.statuses.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            PGScreen.current = vc
            // 時間の更新
            PGActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.renderFlow.storage.statuses.commit()
            vc.renderFlow.clearColor = self.clearColor
            
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
            for actor in self.shapes {
                actor.appearIterate()       // イテレート処理
                actor.appearInterval()      // インターバル処理
                
                if actor.life <= 0.0 {
                    actor.appearCompletion()    // 完了前処理
                    actor.checkRemove()         // 削除処理
                }
            }
        }
        
        func removeAllShapes() {
            PGPool.shared.removeAllShapes( on:renderFlow.storage )
        }
        
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            particleCapacity:Int = 10000,
            textures:[String] = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )
        {
            self.device = device
            
            self.environment = environment
            self.particleCapacity = particleCapacity
            self.textures = textures
            
            self.mediumTextures = .init( device:device )
            
            renderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTextures:self.mediumTextures,
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures
            )
            
            sRGBRenderFlow = .init(
                device:device, 
                viewCount:1,
                mediumTextures:self.mediumTextures,
                environment:self.environment
            )
            
            super.init()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func setup() {
            super.setup()
            addSubview( metalView )
            
            renderEngine = .init( 
                device:device,
                size:CGSize( 320, 240 ), 
                renderFlows:[ renderFlow, sRGBRenderFlow ],
                buffersInFlight:1
            )

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
    public func recogizeTouches( touches allTouches:[UITouch] ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // タッチ数
        var idx = 0
        for touch in allTouches {
            // point座標系を取得
            let lt_pos = touch.location( in:self.view )
            
            // MetalViewの中心座標を取得
            let o = metalView.center
            
            let pix_o_pos = LLPointFloat( lt_pos.x - o.x, -(lt_pos.y - o.y) )
            let pix_lt_pos = LLPointFloat( lt_pos.x, lt_pos.y )
            var state:Lily.Stage.Playground2D.PGTouch.State = .release
            
            switch touch.phase {
                case .began: state = .began
                case .moved: state = .touch
                case .stationary: state = .touch
                case .ended: state = .release
                case .cancelled: state = .release
                default: state = .release
            }
            
            let pg_touch = Lily.Stage.Playground2D.PGTouch(
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
    public func recogizeMouse( pos:LLPoint, phase:Lily.Stage.Playground2D.MacOSMousePhase, event:NSEvent? ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // MetalViewの中心座標を取得
        let o = metalView.center
            
        let pix_o_pos  = LLPointFloat( pos.x.cgf - o.x, -(pos.y.cgf - o.y) )
        let pix_lt_pos = LLPointFloat( pos.x, pos.y )
        var state:Lily.Stage.Playground2D.PGTouch.State = .release
        
        switch phase {
            case .began: state = .began
            case .moved: state = .touch
            case .stationary: state = .touch
            case .ended: state = .release
            case .cancelled: state = .release
        }
 
        let pg_touch = Lily.Stage.Playground2D.PGTouch(
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
