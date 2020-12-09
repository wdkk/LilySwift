//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

#if !LILY_FULL
import PlaygroundSupport
#endif

open class PGViewController : LBViewController
{
    public override init() {
        super.init()
        PGScreen.current = self
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 外部処理ハンドラ 
    public var buildupHandler:(()->Void)?
    public var loopHandler:(()->Void)?
    
    public var shapes:Set<LBActor> { PGMemoryPool.shared.shapes }
    
    // 表示からの経過時間
    public var elapsedTime:Double { PGActorTimer.shared.elapsedTime }
    
    // 準備関数
    override open func setup() {
        super.setup()
        
        // 親元のデザイン関数を削除
        metalView.buildupField.fields.removeAll()
        
        // 時間の初期化
        PGActorTimer.shared.start()
        
        // デザイン関数のみ再定義
        metalView.chain
        .buildup.add( with:self )
        { caller, me in
            // 現在ある全ての図形を削除する
            caller.removeAllShapes()
            // セーフエリアいっぱいにリサイズ
            CATransaction.stop {
                me.chain.rect( self.ourBounds.llRect )
            }
            // ボード描画
            caller.buildupBoard()
        }
    }
    
    // ボード構築関数
    open override func buildupBoard() {
        buildupHandler?()
    }
        
    // ボード繰り返し処理関数
    override open func loopBoard() {
        // 時間の更新
        PGActorTimer.shared.update()
        
        loopHandler?()
        
        // Shapeの更新/終了処理を行う
        checkShapesStatus()
    }
        
    func checkShapesStatus() {
        for s in PGMemoryPool.shared.shapes {
            guard let pgactor = s as? PGActor else { continue }
            // イテレート処理
            pgactor.appearIterate()
            // インターバル処理
            pgactor.appearIntervals()
            
            if s.life <= 0.0 {
                // 完了前処理
                pgactor.appearCompletion()
                // 削除処理
                pgactor.checkRemove()
            }
        }
    }
    
    func removeAllShapes() {
        PGMemoryPool.shared.removeAllShapes()
    }
    
    // テクスチャの取得 & まだつくっていないときは生成
    public func getTexture( _ path:String ) -> LLMetalTexture {
        return PGMemoryPool.shared.getTexture( path )
    }
    
    #if os(macOS)
    // TODO: イベント系を整理したら削除する
    public var mousedownHandler:(()->Void)?
    open override func mouseDown(with event: NSEvent) {
        super.mouseDown( with: event )
        mousedownHandler?()
    }
    #endif
}
