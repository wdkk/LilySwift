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
        
        var renderTextures:Lily.Stage.RenderTextures
        
        var modelRenderFlow:ModelRenderFlow?
        var BBRenderFlow:BBRenderFlow?
        
        public var clearColor:LLColor = .white
        
        public var environment:Lily.Stage.ShaderEnvironment
        public var particleCapacity:Int
        public var textures:[String]
        
        public var screenSize:LLSizeFloat { LLSizeFloat( width, height ) }
    
        public var randomPoint:LLFloatv3 { LLFloatv3( ) }
        
        // MARK: - パーティクル情報
        public var shapes:Set<BBActor> { BBRenderFlow!.pool.shapes }
        
        // 外部処理ハンドラ
        public var buildupHandler:(( PGStage )->Void)?
        public var loopHandler:(( PGStage )->Void)?
        
        #if os(iOS) || os(visionOS)
        public lazy var metalView = Lily.View.MetalView( device:device )
        .setup( caller:self ) { me, vc in
            me.bgColor( .grey )
            me.isMultipleTouchEnabled = true
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
            BBActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.loopHandler?( self )
            // 変更の確定
            vc.BBRenderFlow?.pool.storage?.statuses?.commit()
            
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
            vc.BBRenderFlow?.pool.storage?.statuses?.commit()
        
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
            for actor in BBRenderFlow!.pool.shapes {
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
            BBRenderFlow!.pool.removeAllShapes()
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
            
            self.renderTextures = .init( device:device )
            
            super.init()
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        open override func setup() {
            super.setup()
            addSubview( metalView )
            
            modelRenderFlow = .init(
                device:device,
                viewCount:1,
                renderTextures:self.renderTextures
            )
                                    
            BBRenderFlow = .init( 
                device:device,
                viewCount:1,
                renderTextures:self.renderTextures,
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures
            )
            
            renderEngine = .init( 
                device:device,
                size:CGSize( 320, 240 ), 
                renderFlows:[modelRenderFlow!, BBRenderFlow!],
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
