//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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

   open override func preSetup() {
        super.preSetup()
        
        // MetalのViewを画面に追加
        #if os(iOS)
        metalView.chain
        .setup.add( with:self )
        { ( caller, me ) in
            me.chain
            .backgroundColor( .grey )
        }  
        .buildup.add( with:self ) 
        { ( caller, me ) in
            // セーフエリア画面いっぱいにサイズ指定
            CATransaction.stop {
                me.chain
                .rect( caller.safeArea )
            }
            // 画面のリサイズで呼び出す
            caller.rebuild()
        }
        .touchesBegan.add( with:self )
        { ( caller, me, args ) in
            caller.recogizeTouches( args.event )
        }
        .touchesMoved.add( with:self )
        { ( caller, me, args ) in
            caller.recogizeTouches( args.event )
        }
        .touchesEnded.add( with:self )
        { ( caller, me, args ) in
            caller.recogizeTouches( args.event )
        }
        .touchesCancelled.add( with:self )
        { ( caller, me, args ) in
            caller.recogizeTouches( args.event )
        }
        #elseif os(macOS)
        metalView.chain
        .setup.add( with:self )
        { ( caller, me ) in
            me.chain
            .backgroundColor( .grey )
        }  
        .buildup.add( with:self ) 
        { ( caller, me ) in
            // セーフエリア画面いっぱいにサイズ指定
            CATransaction.stop {
                me.chain
                .rect( caller.safeArea )
            }
            // 画面のリサイズで呼び出す
            caller.rebuild()
        }
        // TODO: macOSのイベント対応
        #endif
        
        self.view.addSubview( metalView )
    }

    open override func postSetup() {
        super.postSetup()
        self.startLooping()
    }
    
    /// viewLoopの基盤関数の上書き(loopの呼び場所を変えるため)
    open override func viewLoop() {
        preLoop()
    }
    
    // 繰り返し処理関数
    open override func preLoop() {
        super.preLoop()
        if !self.already { return }
        
        // Metalの実行
        LLMetalManager.shared.execute(
        main: { [weak self] commandBuffer in
            guard let strongself = self,
                  let drawable = strongself.metalView.drawable else { return }
            
            strongself.currentCommandBuffer = commandBuffer
            
            strongself.loop()
            strongself.postLoop()
            
            LLMetalComputer.compute( commandBuffer: commandBuffer ) {
                LBDecorationManager.shared.compute( encoder:$0 )
            }

            LLMetalRenderer.render(
                commandBuffer:commandBuffer,
                drawable: drawable,
                clearColor: strongself.clearColor,
                depthTexture: nil,
                renderer: { 
                    let size = LLSize( strongself.metalView.width, strongself.metalView.height )
                    // デコレーションマネージャに処理フローを依頼
                    LBDecorationManager.shared.render( encoder: $0, size: size )
                }
            )
                     
            strongself.currentCommandBuffer = nil
        },
        post: { (commandBuffer) in
            // LilyPlaygroundsではcompletedで待つ形にする(非同期の悪さを止める)
            #if LILY_FULL
            commandBuffer.waitUntilScheduled()
            #else
            commandBuffer.waitUntilCompleted()
            #endif
        })
    }
    
    func recogizeTouches( _ event:OSEvent? ) {
        // タッチ情報の配列をリセット
        self.touchManager.clear()
        
        #if os(iOS)
        guard let all_touches = event?.allTouches else { return }
        #elseif os(macOS)
        guard let all_touches = event?.allTouches() else { return }
        #endif
        
        // タッチ数
        var idx = 0
        for touch in all_touches {
            // point座標系を取得
            let lt_pos = touch.location( in: self.view )
 
            // MetalViewの中心座標を取得(TODO:self.viewとmetalViewの関係を簡潔にしたい)
            let o = metalView.center
            
            let pix_o_pos = LLPointFloat( lt_pos.x - o.x, -(lt_pos.y - o.y) )
            let pix_lt_pos = LLPointFloat( lt_pos.x, lt_pos.y )
            var state:LBTouch.State = .release
            
            switch touch.phase {
                case .began: state = .touch
                case .moved: state = .touch
                case .stationary: state = .touch
                case .ended: state = .release
                case .cancelled: state = .release
                default: state = .release
            }
            
            // 中心を0とした座標
            self.touchManager.units[idx].xy = pix_o_pos
            // 左上を0とした座標
            self.touchManager.units[idx].uv = pix_lt_pos
            // タッチ状態
            self.touchManager.units[idx].state = state
            
            idx += 1
            if idx >= self.touchManager.units.count { break }
        }
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
