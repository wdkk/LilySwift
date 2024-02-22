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
    , Lily_Stage_Playground_PGSceneProtocol
    {
        // MARK: システム
        var device:MTLDevice        
        public var renderEngine:Lily.Stage.StandardRenderEngine?
        public private(set) var environment:Lily.Stage.ShaderEnvironment
        
        // MARK: 描画テクスチャ
        public var modelRenderTextures:Model.ModelRenderTextures
        public var mediumTexture:MediumTexture
        
        // MARK: ストレージ
        public var planeStorage:Plane.PlaneStorage?
        public var modelStorage:Model.ModelStorage?
        public var bbStorage:Billboard.BBStorage?
        
        // MARK: レンダーフロー
        public var clearRenderFlow:ClearRenderFlow?
        public var planeRenderFlow:Plane.PlaneRenderFlow?
        public var modelRenderFlow:Model.ModelRenderFlow?
        public var bbRenderFlow:Billboard.BBRenderFlow?
        public var sRGBRenderFlow:SRGBRenderFlow?
        
        // MARK: プロパティ・アクセサ
        public var clearColor:LLColor = .white
        
        public var cubeMap:String? = nil {
            didSet { modelStorage?.setCubeMap(device:device, assetName:cubeMap ) }
        }

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
       
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGScreen )->Void)?
        public var pgUpdateHandler:(( PGScreen )->Void)?
        public var pgResizeHandler:(( PGScreen )->Void)?
       

        public var _design_mutex = Lily.View.RecursiveMutex()
        private var _design_once = false        
        public func alreadySetupDesignOnce() -> Bool { _design_once }
        public func designOnce( _ torf:Bool ) { _design_once = torf }
        
        private var _metal_view_size:CGSize = .init( -1, -1 )
        
        // Metalビュー
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .clear )
            me.isMultipleTouchEnabled = true
            vc.designOnce( false )
        }
        .buildup( caller:self ) { me, vc in
            CATransaction.stop {
                me.rect( vc.rect )
                vc.renderEngine?.changeScreenSize( size:me.scaledBounds.size )
            }
            
            // リサイズ処理の受け入れハンドラ
            if vc._metal_view_size != me.size.cgSize {
                vc.pgResizeHandler?( vc )
                vc._metal_view_size = me.size.cgSize
            }
            // リサイズの独自処理の後にdesignを試みる. リサイズハンドラでredesignをした場合は無視される
            vc.designProc( vc:vc )
        }
        .draw( caller:self ) { me, vc, status in
            vc.updateProc( vc:vc )
            
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
        
        
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            planeStorage:Plane.PlaneStorage? = nil,
            bbStorage:Billboard.BBStorage? = nil,
            modelStorage:Model.ModelStorage? = nil
        )
        {
            self.device = device
            self.environment = environment

            self.modelRenderTextures = .init( device:device )            
            self.mediumTexture = .init( device:device )
            
            // ストレージの生成
            self.planeStorage = planeStorage
            self.modelStorage = modelStorage
            self.bbStorage = bbStorage
            
            super.init()
        }
        
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            scene:PGScene
        )
        {
            self.device = device
            self.environment = environment

            self.modelRenderTextures = .init( device:device )            
            self.mediumTexture = .init( device:device )
            
            // ストレージの生成
            self.planeStorage = scene.planeStorage
            self.modelStorage = scene.modelStorage
            self.bbStorage = scene.bbStorage
            
            self.pgDesignHandler = scene.design
            self.pgUpdateHandler = scene.update
            self.pgResizeHandler = scene.resize
                        
            super.init()
        }
        
        required public init?( coder aDecoder: NSCoder ) {
            fatalError("init(coder:) has not been implemented")
        }
                
        open override func setup() {
            super.setup()
            addSubview( metalView )
            
            self.backgroundColor = .clear
            
            self.makeRenderFlows( device:self.device, environment:self.environment )

            // レンダーエンジンの初期化
            self.renderEngine = .init( device:device, buffersInFlight:1 )

            self.renderEngine?.setRenderFlows([
                clearRenderFlow,
                modelRenderFlow,
                bbRenderFlow, 
                planeRenderFlow, 
                sRGBRenderFlow 
            ])
            
            // 時間の初期化
            Plane.PGActor.ActorTimer.shared.start()
            Billboard.BBActor.ActorTimer.shared.start()
            Model.ModelActor.ActorTimer.shared.start()
            
            startLooping()          // ループの開始
        }
        
        open override func buildup() {
            super.buildup()
            startLooping()          // ループの開始及び再開
        }
        
        open override func loop() {
            super.loop()
            metalView.drawMetal()   // Metal描画
        }
        
        open override func teardown() {
            endLooping()
            super.teardown()
        }
        
        func makeRenderFlows( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment
        )
        {
            // レンダーフローの生成
            self.clearRenderFlow = .init(
                device:device,
                environment:environment,
                viewCount:1,
                modelRenderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture
            )
            
            self.modelRenderFlow = .init(
                device:device,
                environment:environment,
                viewCount:1,
                renderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture,
                storage:self.modelStorage
            )
                                    
            self.bbRenderFlow = .init( 
                device:device,
                environment:environment,
                viewCount:1,
                mediumTexture:mediumTexture,
                storage:self.bbStorage
            )
            
            self.planeRenderFlow = .init( 
                device:device,
                environment:environment,
                viewCount:1,
                mediumTexture:self.mediumTexture,
                storage:self.planeStorage
            )
            
            self.sRGBRenderFlow = .init(
                device:device, 
                environment:environment,
                viewCount:1,
                mediumTexture:self.mediumTexture
            )
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
