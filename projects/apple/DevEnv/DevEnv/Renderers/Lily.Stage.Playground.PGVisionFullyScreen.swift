//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import CompositorServices
import LilySwift

#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.Stage.Playground
{ 
    public typealias PGVisionScene = PGBaseScene<PGVisionFullyScreen>
    
    open class PGVisionFullyScreen
    {
        // MARK: システム
        var device:MTLDevice        
        public var renderEngine:Lily.Stage.VisionFullyRenderEngine?
        public private(set) var environment:Lily.Stage.ShaderEnvironment
        
        // MARK: 描画テクスチャ
        public private(set) var modelRenderTextures:Model.ModelRenderTextures
        public private(set) var mediumTexture:MediumTexture
        
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
        
        /*
        public var minX:Double { -(metalView.width * 0.5) }
        public var maxX:Double { metalView.width * 0.5 }
        public var minY:Double { -(metalView.height * 0.5) }
        public var maxY:Double { metalView.height * 0.5 }
        
        public var screenSize:LLSizeFloat { .init( width, height ) }
        
        public var coordRegion:LLRegion { .init( left:minX, top:maxY, right:maxX, bottom:minY ) }

        public var randomPoint:LLPoint { coordRegion.randomPoint }
        */
        
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
        public var billboards:Set<Billboard.BBActor> { 
            if let storage = bbStorage { return Billboard.BBPool.shared.shapes( on:storage ) }
            return []
        }
        
        // MARK: - 3Dモデル情報
        public var models:Set<Model.ModelActor> { 
            if let storage = modelStorage { return Model.ModelPool.shared.shapes( on:storage ) }
            return []
        }
        
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGVisionFullyScreen )->Void)?
        public var pgUpdateHandler:(( PGVisionFullyScreen )->Void)?
        public var pgResizeHandler:(( PGVisionFullyScreen )->Void)?
       
        private var _design_once = false
        private var _design_mutex = Lily.View.RecursiveMutex()

        public func redesign() {
            self.designProc( vc:self, force:true )
        }
    
        // MARK: - 更新時関数群
        public func designProc( vc:PGVisionFullyScreen, force:Bool = false ) {
            // 強制描画でなくかつonceが効いているときはスキップ
            if !force && vc._design_once { return }

            // redesignの繰り返し呼び出しの防止をしつつ処理を実行
            _design_mutex.lock {
                vc.setCurrentStorage()
                
                vc.removeAllShapes()
                
                vc.pgDesignHandler?( self )
                
                vc.modelStorage?.statuses.commit()
                vc.bbStorage?.statuses.commit()
                vc.planeStorage?.statuses.commit()
                
                vc._design_once = true
            }
        }
        
        public func updateProc( 
            vc:PGVisionFullyScreen
        ) 
        {
            vc.setCurrentStorage()
            
            // 時間の更新
            Plane.PGActor.ActorTimer.shared.update()
            Billboard.BBActor.ActorTimer.shared.update()
            Model.ModelActor.ActorTimer.shared.update()
            
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.modelStorage?.statuses.commit()
            vc.bbStorage?.statuses.commit()
            vc.planeStorage?.statuses.commit()
            
            // 背景色の更新
            vc.clearRenderFlow?.clearColor = self.clearColor
            vc.modelStorage?.clearColor = self.clearColor
            
            // Shapeの更新/終了処理を行う
            vc.checkPlanesStatus()
            vc.checkBillboardsStatus()
            vc.checkModelsStatus()
            
            vc.renderEngine?.update(
                completion: { commandBuffer in
                    self.touchManager.changeBegansToTouches()
                    self.touchManager.resetReleases()
                }
            ) 
        }
        
        func setCurrentStorage() {
            Plane.PlaneStorage.current = self.planeStorage
            Billboard.BBStorage.current = self.bbStorage
            Model.ModelStorage.current = self.modelStorage
        }
                
        func checkPlanesStatus() {
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
        
        func checkModelsStatus() {
            for actor in self.models {
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
            Billboard.BBPool.shared.removeAllShapes( on:bbStorage )
            Model.ModelPool.shared.removeAllShapes( on:modelStorage )
        }
        
        public init( 
            layerRenderer:LayerRenderer,
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            scene:PGVisionScene
        )
        {
            self.device = layerRenderer.device
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
                        
            // レンダーフローの生成
            self.clearRenderFlow = .init(
                device:device,
                environment:self.environment,
                viewCount:1,
                modelRenderTextures:modelRenderTextures,
                mediumTexture:mediumTexture
            )
            
            self.modelRenderFlow = .init(
                device:device,
                environment:self.environment,
                viewCount:1,
                renderTextures:modelRenderTextures,
                mediumTexture:mediumTexture,
                storage:modelStorage
            )
                                    
            self.bbRenderFlow = .init( 
                device:device,
                environment:self.environment,
                viewCount:1,
                mediumTexture:mediumTexture,
                storage:bbStorage
            )
            
            self.planeRenderFlow = .init( 
                device:device,
                environment:self.environment,
                viewCount:1,
                mediumTexture:mediumTexture,
                storage:planeStorage
            )
            
            self.sRGBRenderFlow = .init(
                device:device, 
                environment:self.environment,
                viewCount:1,
                mediumTexture:mediumTexture
            )
            
            self.renderEngine = Lily.Stage.VisionFullyRenderEngine( 
                layerRenderer,
                renderFlows:[
                    clearRenderFlow,
                    modelRenderFlow,
                    bbRenderFlow, 
                    planeRenderFlow, 
                    sRGBRenderFlow
                ],
                buffersInFlight:3
            )
            
            self.renderEngine?.setupHandler = { self.designProc( vc:self ) }
            self.renderEngine?.updateHandler = { self.updateProc( vc:self ) }
            
            self.renderEngine?.startRenderLoop()
        }
    }
}
