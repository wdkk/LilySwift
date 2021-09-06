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

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

open class LBViewController : LLViewController
{
    public let metalView = LLMetalView()
    public var clearColor:LLColor = .white
    public weak var currentCommandBuffer:MTLCommandBuffer?
    //lazy var depth_tex = LLMetalDepthTexture()
    
    public let touchManager = LBTouchManager()
    public var touches:[LBTouch] { return touchManager.touches }
    public var releases:[LBTouch] { return touchManager.releases }
    
    public var coordMinX:Double { -(metalView.width * 0.5) }
    public var coordMaxX:Double { metalView.width * 0.5 }
    public var coordMinY:Double { -(metalView.height * 0.5) }
    public var coordMaxY:Double { metalView.height * 0.5 }
    
    public var screenSize:LLSizeFloat { LLSizeFloat( width, height ) }
    
    public var coordRegion:LLRegion { LLRegion( left:coordMinX,
                                                top:coordMaxY,
                                                right:coordMaxX,
                                                bottom:coordMinY ) }
    // オーバーライド用関数
    open func buildupBoard() { }
    // オーバーライド用関数
    open func loopBoard() { }
    
    open override func preSetup() {
        super.preSetup()

        // MetalのViewを画面に追加
        #if os(iOS)
        metalView.isMultipleTouchEnabled = true
        metalView.chain
        .setup.add( caller:self )
        { caller, me in
            me.chain
            .backgroundColor( .grey )
        }  
        .buildup.add( caller:self ) 
        { caller, me in
            // セーフエリアいっぱいにリサイズ
            CATransaction.stop {
                me.chain.rect( self.safeArea )
            }
            // ボード描画
            caller.buildupBoard()
        }
        .touchesBegan.add( caller:self )
        { caller, me, args in
            for touch in args.touches {
                caller.touchManager.allTouches.append( touch )
            }
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        .touchesMoved.add( caller:self )
        { caller, me, args in
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        .touchesEnded.add( caller:self )
        { caller, me, args in
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
        .touchesCancelled.add( caller:self )
        { caller, me, args in
            let all_touches = caller.touchManager.allTouches
            caller.recogizeTouches( touches:all_touches )
        }
        #elseif os(macOS)
        metalView.chain
        .setup.add( caller:self )
        { caller, me in
            me.chain
            .backgroundColor( .grey )
        }  
        .buildup.add( caller:self ) 
        { caller, me in
            // セーフエリアいっぱいにリサイズ
            CATransaction.stop {
                me.chain.rect( self.safeArea )
            }
            // ボード描画
            caller.buildupBoard()
        }
        .mouseLeftDown.add( caller:self )
        { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.began, event:args.event )
        }
        .mouseLeftDragged.add( caller:self )
        { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.moved, event:args.event )
        }
        .mouseLeftUp.add( caller:self )
        { caller, me, args in
            caller.recogizeMouse( pos:args.position, phase:.ended, event:args.event )
        }
        // TODO: macOSのイベント対応
        #endif
        
        self.view.addSubview( metalView )
    }

    open override func postSetup() {
        super.postSetup()
        self.startLooping()
    }
    
    // 繰り返し処理関数
    open override func loop() {
        super.loop()
        if !self.already { return }
        
        // Metalの実行
        LLMetalManager.shared.execute(
        main: { [weak self] commandBuffer in
            guard let self = self,
                  let drawable = self.metalView.drawable 
            else { return }
            
            self.currentCommandBuffer = commandBuffer
            
            self.loopBoard()
            
            /*
            depth_tex.updateDepthTexture( 
                drawable: drawable,
                depthFormat: .depth32Float_stencil8,
                type:.type2D,
                sampleCount: 1,
                mipmapped: false )
            */
            
            LLMetalComputer.compute( commandBuffer: commandBuffer ) {
                LBObjectPipelineManager.shared.compute( encoder:$0 )
            }
        
            LLMetalRenderer.render(
                commandBuffer:commandBuffer,
                drawable: drawable,
                clearColor: self.clearColor,
                depthTexture: nil //depth_tex
                )
            {
                /*
                // エンコーダにデプスとステンシルの初期設定
                let depth_desc = MTLDepthStencilDescriptor()
                depth_desc.depthCompareFunction = .less
                depth_desc.isDepthWriteEnabled = true
                $0.setDepthStencilDescriptor( depth_desc )
                */
                
                // 初期値: メッシュの裏表の回転方向（逆時計回りを設定）
                $0.setFrontFacing( .counterClockwise )
                // 初期値: エンコーダにカリングの初期設定
                $0.setCullMode( .none )

                let size = LLSize( self.metalView.width, self.metalView.height )
                // オブジェクトパイプラインマネージャに処理フローを依頼
                LBObjectPipelineManager.shared.render( encoder: $0, screenSize: size )
            }
    
            self.currentCommandBuffer = nil
        },
        post: { commandBuffer in
            // LilyPlaygroundではcompletedで待つ形にする(非同期の悪さを止める)
            #if LILY_FULL
            commandBuffer.waitUntilScheduled()
            #else
            commandBuffer.waitUntilCompleted()
            #endif
            
            self.touchManager.changeBegansToTouches()
            self.touchManager.resetReleases()
        })
    }

    // MetalでCraft類をコンピュートパイプラインを動作させる関数
    open func compute( _ f:( MTLComputeCommandEncoder )->Void ) {
        // コマンドバッファがある場合は用いて動作する
        if let command_buffer = currentCommandBuffer { 
            LLMetalComputer.compute( commandBuffer: command_buffer ) {
                f( $0 )
            }
        }
        // コマンドバッファがない場合は発行して用いる. ただしパフォーマンスは落ちる可能性あり
        else {
            LLMetalManager.shared.execute {
                LLMetalComputer.compute( commandBuffer: $0 ) {
                   f( $0 )
                }
            }
        }
    }
}

#if os(iOS)
public extension LBViewController
{
    func recogizeTouches( touches all_touches:[UITouch] ) {
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
            var state:LBTouch.State = .release
            
            switch touch.phase {
                case .began: state = .began
                case .moved: state = .touch
                case .stationary: state = .touch
                case .ended: state = .release
                case .cancelled: state = .release
                default: state = .release
            }
            
            let lb_touch = LBTouch(
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
public extension LBViewController
{
    func recogizeMouse( pos:LLPoint, phase:MacOSMousePhase, event:NSEvent? ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        // MetalViewの中心座標を取得(TODO: self.viewとmetalViewの関係を簡潔にしたい)
        let o = metalView.center
            
        let pix_o_pos  = LLPointFloat( pos.x.cgf - o.x, -(pos.y.cgf - o.y) )
        let pix_lt_pos = LLPointFloat( pos.x, pos.y )
        var state:LBTouch.State = .release
        
        switch phase {
            case .began: state = .began
            case .moved: state = .touch
            case .stationary: state = .touch
            case .ended: state = .release
            case .cancelled: state = .release
        }
 
        let lb_touch = LBTouch(
            xy: pix_o_pos,  // 中心を0とした座標
            uv: pix_lt_pos, // 左上を0とした座標
            state: state    // タッチ状態
        )

        if phase == .began {
            self.touchManager.starts[0] = lb_touch
        }        
        self.touchManager.units[0] = lb_touch
        self.touchManager.units[0].startPos = self.touchManager.starts[0].xy
    }
    
}
#endif
