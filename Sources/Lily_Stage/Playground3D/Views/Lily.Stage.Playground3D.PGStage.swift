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

extension Lily.Stage.Playground3D
{ 
    open class PGStage
    : Lily.View.ViewController
    {
        var device:MTLDevice
        var renderEngine:Lily.Stage.StandardRenderEngine?
        
        var modelRenderTextures:ModelRenderTextures
        var mediumTexture:MediumTexture
        
        var modelRenderFlow:ModelRenderFlow
        var bbRenderFlow:BBRenderFlow
        var sRGBRenderFlow:SRGBRenderFlow
        
        public var clearColor:LLColor = .white
        
        public var environment:Lily.Stage.ShaderEnvironment
        public var particleCapacity:Int
        public var textures:[String]
        
        public var screenSize:LLSizeFloat { LLSizeFloat( width, height ) }
    
        // MARK: - パーティクル情報
        public var shapes:Set<BBActor> { bbRenderFlow.pool.shapes }
        
        // MARK: - 外部処理ハンドラ
        public var pgDesignHandler:(( PGStage )->Void)?
        public var pgUpdateHandler:(( PGStage )->Void)?
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
                vc.modelRenderTextures.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
                vc.mediumTexture.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
            }
            
            if !vc._design_once_flag {
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.bbRenderFlow.pool.storage?.statuses?.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            BBActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.bbRenderFlow.pool.storage?.statuses?.commit()
            
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in

                }
            ) 
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
                vc.modelRenderTextures.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
                vc.mediumTexture.updateBuffers( size:me.scaledBounds.size, viewCount:1 )
            }
            
            if !vc._design_once_flag {
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.bbRenderFlow.pool.storage?.statuses?.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            // 時間の更新
            BBActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.bbRenderFlow.pool.storage?.statuses?.commit()
        
            // Shapeの更新/終了処理を行う
            vc.checkShapesStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in

                }
            ) 
        }
        #endif
                
        func checkShapesStatus() {
            for actor in bbRenderFlow.pool.shapes {
                actor.appearIterate()   // イテレート処理
                actor.appearInterval()  // インターバル処理
                
                if actor.life <= 0.0 {
                    actor.appearCompletion()    // 完了前処理
                    actor.checkRemove()         // 削除処理
                }
            }
        }
        
        func removeAllShapes() {
            bbRenderFlow.pool.removeAllShapes()
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
            
            self.modelRenderTextures = .init( device:device )
            self.mediumTexture = .init( device:device )
            
            modelRenderFlow = .init(
                device:device,
                viewCount:1,
                renderTextures:self.modelRenderTextures,
                mediumTexture:mediumTexture
            )
                                    
            bbRenderFlow = .init( 
                device:device,
                viewCount:1,
                renderTextures:self.modelRenderTextures,
                mediumTexture:mediumTexture,                
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures
            )
            
            sRGBRenderFlow = .init( 
                device:device,
                viewCount:1,
                mediumTexture:mediumTexture,
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
                renderFlows:[ modelRenderFlow, bbRenderFlow, sRGBRenderFlow ],
                buffersInFlight:1
            )

            // 時間の初期化
            BBActor.ActorTimer.shared.start()
                        
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
