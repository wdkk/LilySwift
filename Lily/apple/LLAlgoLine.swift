//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation

/// 直線プロットモジュール(Bresenhamアルゴリズム)
open class LLAlgoLineBresenham
{
    /// LilyCoreのラインオブジェクト
    fileprivate(set) var linec:LCAlgoLineBresenhamSmPtr = LCAlgoLineBresenhamMake()
    
    /// オブジェクトを生成
    public init() {}
    
    /// プロットの開始位置の指定
    /// - Parameter pt: 初期(x,y)座標
    /// - Parameter span: プロット間隔(px)
	open func start( _ pt:LLPoint, span:Double ) {
		LCAlgoLineBresenhamStart( linec, pt, span )
	}
	
    /// 次のプロット位置の再ターゲット
    /// - Parameter pt: 次の目標(x,y)座標
    /// - Parameter span: プロット間隔(px)
    /// - Returns: ラインステップで移動するステップを囲う外接領域
    @discardableResult
	open func retarget( _ pt:LLPoint, span:Double ) -> LLRegion {
		return LCAlgoLineBresenhamRetarget( linec, pt, span )
	}
	
    /// 次のプロットポイントへ進み,ラインステップ情報を取得
    /// - Returns: ラインステップ情報
    open func next() -> LLAlgoLineStep {
		return LCAlgoLineBresenhamNext( linec )
	}
    
    /// 現在のプロットポイントのラインステップ情報を取得
    /// - Returns: ラインステップ情報
    open var now:LLAlgoLineStep {
        return LCAlgoLineBresenhamNow( linec )
    }
	
    /// ターゲット位置にたどり着き、停止しているかを確認する
    /// - Returns: 停止している = true, 移動中 = false
    open var stopped:Bool {
		return LCAlgoLineBresenhamIsStopped( linec )
	}
}

/// 直線プロットモジュール(Hermiteアルゴリズム)
open class LLAlgoLineHermite
{
    /// LilyCoreのラインオブジェクト
    fileprivate(set) var linec:LCAlgoLineHermiteSmPtr = LCAlgoLineHermiteMake()
    
    /// オブジェクトを生成
    public init() {}
    
    /// プロットの開始位置の指定
    /// - Parameter pt: 初期(x,y)座標
    /// - Parameter span: プロット間隔(px)
    open func start( _ pt:LLPoint, span:Double ) {
        LCAlgoLineHermiteStart( linec, pt, span )
    }
    
    /// 次のプロット位置の再ターゲット
    /// - Parameter pt: 次の目標(x,y)座標
    /// - Parameter span: プロット間隔(px)
    /// - Returns: ラインステップで移動するステップを囲う外接領域
    @discardableResult
    open func retarget( _ pt:LLPoint, span:Double ) -> LLRegion {
        return LCAlgoLineHermiteRetarget( linec, pt, span )
    }
    
    /// 次のプロットポイントへ進み,ラインステップ情報を取得
    /// - Returns: ラインステップ情報
    open func next() -> LLAlgoLineStep {
        return LCAlgoLineHermiteNext( linec )
    }
    
    /// 現在のプロットポイントのラインステップ情報を取得
    /// - Returns: ラインステップ情報
    open var now:LLAlgoLineStep {
        return LCAlgoLineHermiteNow( linec )
    }
    
    /// ターゲット位置にたどり着き、停止しているかを確認する
    /// - Returns: 停止している = true, 移動中 = false
    open var stopped:Bool {
        return LCAlgoLineHermiteIsStopped( linec )
    }
}

/// スタイラス用のパラメータオブジェクト
/// 直線アルゴリズムで得たラインステップ情報を用いて値を得る
open class LLAlgoStylusParam
{
    /// LilyCoreのパラメータオブジェクト
    public fileprivate(set) var param = LCAlgoStylusParamMake()
    
    /// 初期パラメータを設定する
    /// - Parameter step: 初期パラメータのステップ情報
    open func start( _ step:LLAlgoStylusParamStep ) {
        LCAlgoStylusParamStart( param, step )
    }
    
    /// 次のターゲット値を設定する
    /// - Parameter step: 次回のパラメータのステップ情報
    open func retarget( _ step:LLAlgoStylusParamStep ) {
        return LCAlgoStylusParamRetarget( param, step )
    }
    
    /// パラメータステップの進捗中の情報を得る
    /// - Parameter progress: 進捗率(0.0~1.0), 基本的にLLAlgoLineStep.progressを用いる
    open func progress( _ k:Double ) -> LLAlgoStylusParamStep {
        return LCAlgoStylusParamProgress( param, k )
    }
}

#endif
