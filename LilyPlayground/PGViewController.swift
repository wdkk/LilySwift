//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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

#if !LILY_NOT_PG
import PlaygroundSupport
#endif

#if LILY_NOT_PG 
open class PGBaseViewController : LBViewController 
{
}
#else
@objc(BookCore_LiveViewController)
open class PGBaseViewController: LBViewController, PlaygroundLiveViewSafeAreaContainer
{
}
#endif

open class PGViewController: PGBaseViewController
{
    public static let shared = PGViewController()
    private override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 形状データ
    public var panels = Set<PGPanelBase>()
    public var triangles = Set<PGTriangleBase>()
    public var shapes:Set<LBActor> {
        Set<LBActor>( panels ).union( triangles )
    }
    
    // テクスチャデータ
    public var textures = [String:LLMetalTexture]()
    
    // 処理ハンドラ 
    public var designHandler:(()->Void)?
    public var updateHandler:(()->Void)?
   
    // 表示からの経過時間
    public var elapsedTime:Double { PGActorTimer.shared.elapsedTime }
    
    // 準備関数
    override open func setup() {
        super.setup()
        
        // 親元のデザイン関数を削除
        metalView.designField.fields.removeAll()
        
        // 時間の初期化
        PGActorTimer.shared.start()
        
        // デザイン関数のみ再定義
        metalView.chain
        .design.add( with:self )
        { (caller, me) in
            // 画面いっぱいにサイズ指定
            CATransaction.stop {
                me.rect = caller.ourBounds.llRect
            }
            
            caller.removeAllShapes()
            
            // 画面のリサイズで呼び出す
            caller.updateBoard()
        }
    }
    
    override open func buildup() {
        super.buildup()
        designHandler?()
    }
    
    // 繰り返し処理関数
    override open func updateBoard() {
        super.updateBoard()
        // 時間の更新
        PGActorTimer.shared.update()
        
        updateHandler?()
        
        // Shapeの更新/終了処理を行う
        checkShapesStatus()
    }
        
    func checkShapesStatus() {
        for s in shapes {
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
        panels.removeAll()
        triangles.removeAll()
    }
    
    public func getTexture( _ path:String ) -> LLMetalTexture {
        guard let tex = textures[path] else {
            textures[path] = LLMetalTexture( named: path )
            return textures[path]!
        }
        return tex
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
