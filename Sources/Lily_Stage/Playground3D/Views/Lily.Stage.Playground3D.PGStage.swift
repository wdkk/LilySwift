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
        public static var current:PGStage? = nil
        
        var device:MTLDevice
        var renderEngine:Lily.Stage.StandardRenderEngine?
        
        var modelRenderTextures:Model.ModelRenderTextures
        var mediumTexture:MediumTexture
        
        public var modelRenderFlow:Model.ModelRenderFlow
        public var bbRenderFlow:Billboard.BBRenderFlow
        public var sRGBRenderFlow:SRGBRenderFlow
        
        public var clearColor:LLColor = .white
        
        public var environment:Lily.Stage.ShaderEnvironment
        public var particleCapacity:Int
        public var textures:[String]

        public var minX:Double { -(metalView.width * 0.5) }
        public var maxX:Double { metalView.width * 0.5 }
        public var minY:Double { -(metalView.height * 0.5) }
        public var maxY:Double { metalView.height * 0.5 }
        
        public var screenSize:LLSizeFloat { .init( width, height ) }
        
        public var coordRegion:LLRegion { .init( left:minX, top:maxY, right:maxX, bottom:minY ) }
        
        public var randomPoint:LLPoint { coordRegion.randomPoint }
    
        // MARK: - パーティクル情報
        public var billboards:Set<Billboard.BBActor> { return Billboard.BBPool.shared.shapes( on:bbRenderFlow.storage ) }
        
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
                PGStage.current = vc
                
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.bbRenderFlow.storage.statuses.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            PGStage.current = vc
            // 時間の更新
            Billboard.BBActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.bbRenderFlow.storage.statuses.commit()
            
            // ビルボードの更新/終了処理を行う
            vc.checkBillboardsStatus()
            
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
                PGStage.current = vc
                
                vc.removeAllShapes()
                vc.pgDesignHandler?( self )
                vc.bbRenderFlow.storage.statuses.commit()
                vc._design_once_flag = true
            }
        }
        .draw( caller:self ) { me, vc, status in
            PGStage.current = vc
            
            // 時間の更新
            Billboard.BBActor.ActorTimer.shared.update()
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.bbRenderFlow.storage.statuses.commit()
        
            // ビルボードの更新/終了処理を行う
            vc.checkBillboardsStatus()
            
            vc.renderEngine?.update(
                with:status.drawable,
                renderPassDescriptor:status.renderPassDesc,
                completion: { commandBuffer in

                }
            ) 
        }
        #endif
                
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
            Billboard.BBPool.shared.removeAllShapes( on:bbRenderFlow.storage )
        }
        
        public init( 
            device:MTLDevice, 
            environment:Lily.Stage.ShaderEnvironment = .metallib,
            particleCapacity:Int = 2000,
            modelCapacity:Int = 500,
            textures:[String] = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            modelAssets:[String] = [ "acacia1", "plane" ]
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
                mediumTexture:mediumTexture,
                modelCapacity:modelCapacity,
                modelAssets:modelAssets
            )
                                    
            bbRenderFlow = .init( 
                device:device,
                viewCount:1,
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
            Billboard.BBActor.ActorTimer.shared.start()
                        
            startLooping()
        }
        
        open override func loop() {
            super.loop()
            
            changeCameraStatus()
            
            metalView.drawMetal()
        }
        
        open override func teardown() {
            endLooping()
        }
        
    
        var mouseDrag = LLFloatv2()
        
        func changeCameraStatus() {
            renderEngine?.camera.rotate( on:LLFloatv3( 0, 1, 0 ), radians: mouseDrag.x * 0.02 )
            renderEngine?.camera.rotate( on:renderEngine!.camera.left, radians: mouseDrag.y * 0.02 )
            mouseDrag = .zero
        }
        
        #if os(macOS)
        open override func mouseDragged(with event: NSEvent) {
            super.mouseDragged(with: event)
            mouseDrag = .init( event.deltaX.f, event.deltaY.f )
        }

        open override func rightMouseDragged(with event: NSEvent) {
            super.rightMouseDragged(with: event)
            mouseDrag = .init( event.deltaX.f, event.deltaY.f )
        }
        
        #else
        open override func touchesBegan( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesBegan( touches, with:event )
        }

        open override func touchesMoved( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesMoved( touches, with:event )
            let l0 = touches.first!.previousLocation( in:self.view )
            let l1 = touches.first!.location( in:self.view )
            mouseDrag = LLFloatv2( Float(l0.x - l1.x), Float(l0.y - l1.y) )
        }

        open override func touchesEnded( _ touches: Set<UITouch>, with event: UIEvent? ) {
            super.touchesEnded( touches, with:event )
        }
        #endif
    }
}
