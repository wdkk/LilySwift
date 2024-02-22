//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//
#if os(visionOS)
import Metal
import CompositorServices
import UIKit

extension Lily.Stage.Playground
{ 
    open class PGVisionFullyScreen
    : Lily_Stage_Playground_PGSceneProtocol
    {        
        // MARK: システム
        var device:MTLDevice        
        public var renderEngine:Lily.Stage.VisionFullyRenderEngine?
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
        
        public var minX:Double { -(renderEngine != nil ? renderEngine!.screenSize.width.d * 0.5 : -1.0) }
        public var maxX:Double { renderEngine != nil ? renderEngine!.screenSize.width.d * 0.5 : 1.0 }
        public var minY:Double { -(renderEngine != nil ? renderEngine!.screenSize.height.d * 0.5 : -1.0) }
        public var maxY:Double { renderEngine != nil ? renderEngine!.screenSize.height.d * 0.5 : 1.0 }
        
        public var screenSize:LLSizeFloat { 
            let wid = renderEngine != nil ? renderEngine!.screenSize.width : 2.0
            let hgt = renderEngine != nil ? renderEngine!.screenSize.height : 2.0
            return .init( wid, hgt ) 
        }
        
        public var coordRegion:LLRegion { .init( left:minX, top:maxY, right:maxX, bottom:minY ) }

        public var randomPoint:LLPoint { coordRegion.randomPoint }
        
        // MARK: - タッチ情報ヘルパ
        private var latest_touch = PGTouch( xy:.zero, uv: .zero, state:.touch )
        public var latestTouch:PGTouch {
            if let touch = touches.first { latest_touch = touch }
            return latest_touch
        }
        
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGVisionFullyScreen )->Void)?
        public var pgUpdateHandler:(( PGVisionFullyScreen )->Void)?
        public var pgResizeHandler:(( PGVisionFullyScreen )->Void)?
       
        public var _design_mutex = Lily.View.RecursiveMutex()
        private var _design_once = false        
        public func alreadySetupDesignOnce() -> Bool { _design_once }
        public func designOnce( _ torf:Bool ) { _design_once = torf }
                
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
                        
            self.renderEngine = .init( layerRenderer, buffersInFlight:3 )
            
            // 時間の初期化
            Plane.PGActor.ActorTimer.shared.start()
            Billboard.BBActor.ActorTimer.shared.start()
            Model.ModelActor.ActorTimer.shared.start()
            
            self.renderEngine?.setupHandler = {
                self.makeRenderFlows(
                    device:self.device, 
                    environment:self.environment, 
                    viewCount:self.renderEngine!.viewCount 
                )
                
                self.renderEngine?.setRenderFlows( [
                    self.clearRenderFlow,
                    self.modelRenderFlow,
                    self.bbRenderFlow, 
                    self.planeRenderFlow, 
                    self.sRGBRenderFlow
                ] )
                
                self.designOnce( false )
                self.designProc( vc:self )
            }
            
            self.renderEngine?.updateHandler = { 
                self.updateProc( vc:self ) 
                
                self.renderEngine?.update(
                    completion: { commandBuffer in
                        self.touchManager.changeBegansToTouches()
                        self.touchManager.resetReleases()
                    }
                ) 
            }
            
            self.renderEngine?.startRenderLoop()
        }
        
        func makeRenderFlows( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int
        )
        {
            // レンダーフローの生成
            self.clearRenderFlow = .init(
                device:device,
                environment:environment,
                viewCount:viewCount,
                modelRenderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture
            )
            
            self.modelRenderFlow = .init(
                device:device,
                environment:environment,
                viewCount:viewCount,
                renderTextures:self.modelRenderTextures,
                mediumTexture:self.mediumTexture,
                storage:self.modelStorage
            )
                                    
            self.bbRenderFlow = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                mediumTexture:mediumTexture,
                storage:self.bbStorage
            )
            
            self.planeRenderFlow = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                mediumTexture:self.mediumTexture,
                storage:self.planeStorage
            )
            
            self.sRGBRenderFlow = .init(
                device:device, 
                environment:environment,
                viewCount:viewCount,
                mediumTexture:self.mediumTexture
            )
        }
    }
}
#endif
