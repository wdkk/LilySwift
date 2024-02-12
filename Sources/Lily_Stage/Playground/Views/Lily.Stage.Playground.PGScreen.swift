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

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.Stage.Playground
{ 
    open class PGScreen
    : Lily.View.ViewController
    {
        public static var current:PGScreen? = nil
        
        // MARK: システム
        var device:MTLDevice        
        public var renderEngine:Lily.Stage.StandardRenderEngine?
        public private(set) var environment:Lily.Stage.ShaderEnvironment
        
        // MARK: 描画テクスチャ
        public private(set) var modelRenderTextures:Lily.Stage.Playground.Model.ModelRenderTextures
        public private(set) var mediumTexture:Lily.Stage.Playground.MediumTexture
        
        // MARK: ストレージ
        public private(set) var planeStorage:Plane.PlaneStorage?
        public private(set) var modelStorage:Lily.Stage.Playground.Model.ModelStorage?
        public private(set) var bbStorage:Lily.Stage.Playground.Billboard.BBStorage?
        
        // MARK: レンダーフロー
        public var clearRenderFlow:Lily.Stage.Playground.ClearRenderFlow
        public var planeRenderFlow:Plane.PlaneRenderFlow
        public var modelRenderFlow:Lily.Stage.Playground.Model.ModelRenderFlow
        public var bbRenderFlow:Lily.Stage.Playground.Billboard.BBRenderFlow
        public var sRGBRenderFlow:SRGBRenderFlow
        
        // MARK: プロパティ・アクセサ
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
        
        // MARK: - 2Dパーティクル情報
        public var shapes:Set<Plane.PGActor> { 
            if let storage = planeStorage { return Plane.PGPool.shared.shapes( on:storage ) }
            return []
        }
        
        // MARK: - 3Dビルボード情報
        public var billboards:Set<Lily.Stage.Playground.Billboard.BBActor> { 
            if let storage = bbStorage { return Lily.Stage.Playground.Billboard.BBPool.shared.shapes( on:storage ) }
            return []
        }
       
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGScreen )->Void)?
        public var pgUpdateHandler:(( PGScreen )->Void)?
        private var _design_once_flag = false
        
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .clear )
            me.isMultipleTouchEnabled = true
            vc._design_once_flag = false
        }
        .buildup( caller:self ) { me, vc in
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
                vc.modelRenderTextures.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
                vc.mediumTexture.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
            }
            
            if !vc._design_once_flag {
                PGScreen.current = vc
                
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )

                vc.modelStorage?.statuses.commit()
                vc.bbStorage?.statuses.commit()
                vc.planeStorage?.statuses.commit()

                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            PGScreen.current = vc
            // 時間の更新
            Plane.PGActor.ActorTimer.shared.update()
            Lily.Stage.Playground.Billboard.BBActor.ActorTimer.shared.update()
            
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.modelStorage?.statuses.commit()
            vc.bbStorage?.statuses.commit()
            vc.planeStorage?.statuses.commit()
            
            // 背景色の更新
            vc.clearRenderFlow.clearColor = self.clearColor
            
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            vc.checkBillboardsStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }        
        #if os(macOS)
        .mouseLeftDown( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.began, event:args.event )
        }
        .mouseLeftDragged( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.moved, event:args.event )
        }
        .mouseLeftUp( caller:self ) { me, caller, args in
            caller.recogizeMouse( pos:args.position, phase:.ended, event:args.event )
        }
        #else
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
        
        func checkBillboardsStatus() {
            for actor in self.billboards {
                actor.appearIterate()   // イテレート処理
                actor.appearInterval()  // インターバル処理
                
                if actor.life <= 0.0 {
                    actor.appearCompletion()    // 完了前処理
                    actor.checkRemove()         // 削除処理
                }
            }
        }
        
        func removeAllShapes() {
            Plane.PGPool.shared.removeAllShapes( on:planeStorage )
            Lily.Stage.Playground.Billboard.BBPool.shared.removeAllShapes( on:bbStorage )
        }
        
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            planeStorage:Lily.Stage.Playground.Plane.PlaneStorage? = nil,
            billboardStorage:Lily.Stage.Playground.Billboard.BBStorage? = nil,
            modelStorage:Lily.Stage.Playground.Model.ModelStorage? = nil,
            planeCapacity:Int = 2000,
            modelCapacity:Int = 500
        )
        {
            self.device = device
            self.environment = environment

            self.modelRenderTextures = .init( device:device )            
            self.mediumTexture = .init( device:device )
            
            // ストレージの生成
            self.planeStorage = planeStorage
            
            self.modelStorage = modelStorage
    
            self.bbStorage = billboardStorage
            
            // レンダーフローの生成
            self.clearRenderFlow = .init(
                device:device,
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment
            )
            
            self.modelRenderFlow = .init(
                device:device,
                viewCount:1,
                renderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture,
                storage:self.modelStorage
            )
                                    
            self.bbRenderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTexture:mediumTexture,                
                environment:self.environment,
                storage:self.bbStorage
            )
            
            self.planeRenderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment,
                storage:self.planeStorage
            )
            
            self.sRGBRenderFlow = .init(
                device:device, 
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment
            )
            
            super.init()
        }
        
        // ストレージ簡易版
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            planeCapacity:Int = 2000,
            planeTextures:[String] = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            modelCapacity:Int = 500,
            modelAssets:[String] = [ "cottonwood1", "acacia1", "plane" ],
            billboardCapacity:Int = 2000,
            billboardTextures:[String] = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
        )
        { 
            self.device = device
            self.environment = environment

            self.modelRenderTextures = .init( device:device )            
            self.mediumTexture = .init( device:device )
            
            // ストレージの生成
            self.planeStorage = .init( 
                device:device, 
                capacity:planeCapacity,
                textures:planeTextures
            )
            
            self.modelStorage = .init( 
                device:device, 
                objCount:modelCapacity,
                cameraCount:( Lily.Stage.Shared.Const.shadowCascadesCount + 1 ),
                modelAssets:modelAssets
            )
    
            self.bbStorage = .init( 
                device:device, 
                capacity:billboardCapacity,
                textures:billboardTextures
            )
            
            // レンダーフローの生成
            self.clearRenderFlow = .init(
                device:device,
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment
            )
            
            self.modelRenderFlow = .init(
                device:device,
                viewCount:1,
                renderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture,
                storage:self.modelStorage
            )
                                    
            self.bbRenderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTexture:mediumTexture,                
                environment:self.environment,
                storage:self.bbStorage
            )
            
            self.planeRenderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment,
                storage:self.planeStorage
            )
            
            self.sRGBRenderFlow = .init(
                device:device, 
                viewCount:1,
                mediumTextures:self.mediumTexture,
                environment:self.environment
            )
            
            super.init()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func setup() {
            super.setup()
            self.backgroundColor = .clear
            addSubview( metalView )
            
            renderEngine = .init( 
                device:device,
                size:CGSize( 320, 240 ), 
                renderFlows:[
                    clearRenderFlow,
                    modelRenderFlow,
                    bbRenderFlow, 
                    planeRenderFlow, 
                    sRGBRenderFlow 
                ],
                buffersInFlight:1
            )

            // 時間の初期化
            Plane.PGActor.ActorTimer.shared.start()
            Lily.Stage.Playground.Billboard.BBActor.ActorTimer.shared.start()
            // ループの開始
            startLooping()
        }
        
        open override func buildup() {
            super.buildup()
            // ループの開始及び再開
            startLooping()
        }
        
        open override func loop() {
            super.loop()
            // Metal描画
            metalView.drawMetal()
        }
        
        open override func teardown() {
            endLooping()
            super.teardown()
        }
    }
}

#if os(iOS) || os(visionOS)
extension Lily.Stage.Playground.PGScreen
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
            var state:Lily.Stage.Playground.PGTouch.State = .release
            
            switch touch.phase {
                case .began: state = .began
                case .moved: state = .touch
                case .stationary: state = .touch
                case .ended: state = .release
                case .cancelled: state = .release
                default: state = .release
            }
            
            let pg_touch = Lily.Stage.Playground.PGTouch(
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
extension Lily.Stage.Playground.PGScreen
{
    public func recogizeMouse( pos:LLPoint, phase:Lily.Stage.Playground.MacOSMousePhase, event:NSEvent? ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // MetalViewの中心座標を取得
        let o = metalView.center
            
        let pix_o_pos  = LLPointFloat( pos.x.cgf - o.x, -(pos.y.cgf - o.y) )
        let pix_lt_pos = LLPointFloat( pos.x, pos.y )
        var state:Lily.Stage.Playground.PGTouch.State = .release
        
        switch phase {
            case .began: state = .began
            case .moved: state = .touch
            case .stationary: state = .touch
            case .ended: state = .release
            case .cancelled: state = .release
        }
 
        let pg_touch = Lily.Stage.Playground.PGTouch(
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
