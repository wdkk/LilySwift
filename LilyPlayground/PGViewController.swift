//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY
import UIKit
#else
import UIKit
import PlaygroundSupport
#endif

#if LILY 
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
    public static let shared:PGViewController = PGViewController()
    private override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var shapes = Set<PGShape>()
    
    public var designBoardHandler:(()->Void)?
    public var updateBoardHandler:(()->Void)?
    
    // 準備関数
    override open func setupBoard() {
        super.setupBoard()
        
        // 親元のデザイン関数を削除
        metalView.design.fields.removeAll()
        
        // デザイン関数のみ再定義
        LLFlow( metalView )
        .design.add( with:self )
        { ( obj, phenomena ) in
            // 画面いっぱいにサイズ指定
            CATransaction.stop {
                obj.me.rect = obj.caller.ourBounds.llRect
            }
            
            obj.caller.removeAllShapes()
            
            // 画面のリサイズで呼び出す
            obj.caller.designBoard()
        }
    }
    
    override open func designBoard() {
        super.designBoard()
        designBoardHandler?()
    }
    
    // 繰り返し処理関数
    override open func updateBoard() {
        super.updateBoard()
        updateBoardHandler?()
        
        // 終了したShapeに対する処理を行う
        checkCompletedShapes()
    }
    
    func checkCompletedShapes() {
        for s in shapes {
            if s.life <= 0.0 {
                s.completionCallBack( s )
            }
        }
    }
    
    func removeAllShapes() {
        shapes.removeAll()
    }
}
