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
    public var currentCommandBuffer:MTLCommandBuffer?
    
    public let touchManager = LBTouchManager()
    public var touches:[LBTouch] { return touchManager.touches }
    public var releases:[LBTouch] { return touchManager.releases }
    
    public var coordMinX:Double { -(metalView.width * 0.5) }
    public var coordMaxX:Double { metalView.width * 0.5 }
    public var coordMinY:Double { -(metalView.height * 0.5) }
    public var coordMaxY:Double { metalView.height * 0.5 }
    
    final public override func setup() {
        super.setup()
        
        // MetalのViewを画面に追加
        #if os(iOS)
        LLFlow( metalView )
        .assemble.add( with:self )
        { ( obj, phenomena ) in
            LLFlow( obj.me )
            .backgroundColor( .grey )
        }  
        .design.add( with:self ) 
        { ( obj, phenomena ) in
            // セーフエリア画面いっぱいにサイズ指定
            CATransaction.stop {
                LLFlow( obj.me )
                .rect( obj.caller.safeArea )
            }
            // 画面のリサイズで呼び出す
            obj.caller.designBoard()
        }
        .touchesBegan.add( with:self )
        { ( obj, phenomena ) in
            obj.caller.recogizeTouches( obj.args.event )
        }
        .touchesMoved.add( with:self )
        { ( obj, phenomena ) in
            obj.caller.recogizeTouches( obj.args.event )
        }
        .touchesEnded.add( with:self )
        { ( obj, phenomena ) in
            obj.caller.recogizeTouches( obj.args.event )
        }
        .touchesCancelled.add( with:self )
        { ( obj, phenomena ) in
            obj.caller.recogizeTouches( obj.args.event )
        }
        
        #elseif os(macOS)
        LLFlow( metalView )
        .assemble.add( with:self )
        { ( obj, phenomena ) in
            LLFlow( obj.me )
            .backgroundColor( .grey )
        }  
        .design.add( with:self ) 
        { ( obj, phenomena ) in
            // セーフエリア画面いっぱいにサイズ指定
            CATransaction.stop {
                LLFlow( obj.me )
                .rect( obj.caller.safeArea )
            }
            // 画面のリサイズで呼び出す
            obj.caller.designBoard()
        }
        // TODO: macOSのイベント対応
        #endif
        
        self.view.addSubview( metalView )
        
        self.setupBoard()
    }

    // TODO: macOS: DisplayLinkへの対応
    // 繰り返し処理関数
    final public override func viewUpdate() {
        super.viewUpdate()
    
        // Metalの実行
        LLMetalManager.execute(
        main: {
            self.currentCommandBuffer = $0
            
            self.updateBoard()

            LLMetalRenderer.render(
                commandBuffer:$0,
                drawable: self.metalView.drawable,
                clearColor: self.clearColor,
                depthTexture: nil,
                renderer:self.render )
            
            self.currentCommandBuffer = nil
        } )
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

    open func setupBoard() {
        // overrideしてLilyBoardオブジェクトの初期化処理を書く
    }   
    
    open func designBoard() {
        // overrideしてLilyBoardオブジェクトの初期化処理を書く
    }    

    open func updateBoard() {
        // overrideしてLilyBoardオブジェクトの更新処理を書く
    }

    // Metalで実際に描画を指示する関数
    open func render( encoder:MTLRenderCommandEncoder ) {
        let size = LLSize( metalView.width, metalView.height )
    
        // LilyBoardの描画をデコレーションマネージャに依頼
        LBDecorationManager.shared.drawAll( encoder: encoder, size: size )
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
            LLMetalManager.execute {
                LLMetalComputer.compute( commandBuffer: $0 ) {
                   f( $0 )
                }
            }
        }
    }
}
