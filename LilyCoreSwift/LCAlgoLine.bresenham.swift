//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// Bresenhamラインステップアルゴリズムの内部実装クラス
private struct __LCAlgoLineBresenham
{
    /// ステップ情報
    var ls:LLAlgoLineStep = LLAlgoLineStep()

    /// 停止確認フラグ
    var is_stopped:Bool = true
    /// ターゲット間のx方向変化量
    var dx:LLDouble = 0.0
    /// ターゲット間のy方向変化量
    var dy:LLDouble = 0.0
    /// ターゲット間のプロットスパン変化量
    var dspan:LLDouble = 0.0
    /// 移動距離
    var length:LLDouble = 0.0
    /// 移動方向cos
    var cosv:LLDouble = 0.0
    /// 移動方向sin
    var sinv:LLDouble = 0.0
    
    /// 状態情報(現在位置しているステップ情報)
    var now_point:LLPoint = LLPointZero()
    /// 現在のプロットスパン情報
    var now_span:LLDouble = 0.0

    /// ターゲット間で進んだstep数
    var step:LLDouble = 0.0
    /// ターゲット間の総ステップ数
    var step_all:LLDouble = 0.0
    
    var step_span:LLDouble = 0.0
} 

/// Bresenhamラインステップアルゴリズムモジュール
public class LCAlgoLineBresenhamSmPtr
{
    /// 内部実装オブジェクト
    fileprivate var lb:__LCAlgoLineBresenham = __LCAlgoLineBresenham()
    
    fileprivate init() {}
}

/// Bresenhamラインステップアルゴリズムオブジェクトの作成
/// - Returns: Bresenhamラインステップアルゴリズムオブジェクト
public func LCAlgoLineBresenhamMake() -> LCAlgoLineBresenhamSmPtr {
    return LCAlgoLineBresenhamSmPtr()
}

/// Bresenhamラインステップアルゴリズムの開始情報を設定する
/// - Parameters:
///   - line: Bresenhamラインステップアルゴリズムオブジェクト
///   - pt: 初期座標(x,y)
///   - span: 初期プロット距離
public func LCAlgoLineBresenhamStart( _ line:LCAlgoLineBresenhamSmPtr, _ pt:LLPoint, _ span:LLDouble ) {
    var lb:__LCAlgoLineBresenham = line.lb
    
    lb.is_stopped = true
    lb.now_span = span
    lb.now_point = pt
    
    lb.ls.pt = lb.now_point
    lb.ls.length = 0.0
    lb.ls.cosv = 0.0
    lb.ls.sinv = 0.0
    lb.ls.span = lb.now_span

    lb.ls.progress = 0.0
    
    // 状態オブジェクトを上書き
    line.lb = lb
}

/// Bresenhamラインステップアルゴリズムの次のターゲット情報を設定する
/// - Parameters:
///   - line: Bresenhamラインステップアルゴリズムオブジェクト
///   - pt: 次の目標(x,y)座標
///   - span: 新しいプロット距離
/// - Returns: 移動範囲の外接領域
/// - Description: spanは前のターゲットで指定した値で線形に変化していく
@discardableResult
public func LCAlgoLineBresenhamRetarget( _ line:LCAlgoLineBresenhamSmPtr, _ pt:LLPoint, _ span:LLDouble ) -> LLRegion {
    var lb:__LCAlgoLineBresenham = line.lb
    
    if span < 0.01 {
        lb.is_stopped = true
        // 状態オブジェクトを上書き
        line.lb = lb
        return LLRegionZero()
    }
    
    let dx:LLDouble = pt.x - lb.now_point.x
    let dy:LLDouble = pt.y - lb.now_point.y
    
    // 移動距離よりスパンの方が長い場合プロットできないので、ストップさせる
    if dx*dx + dy*dy < span * span {
        lb.is_stopped = true
        // 状態オブジェクトを上書き
        line.lb = lb
        return LLRegionZero()   
    }
    
    var reg:LLRegion = LLRegionZero()
    reg.left   = LLMin(pt.x, line.lb.now_point.x) - 2.0
    reg.top    = LLMin(pt.y, line.lb.now_point.y) - 2.0
    reg.right  = LLMax(pt.x, line.lb.now_point.x) + 2.0
    reg.bottom = LLMax(pt.y, line.lb.now_point.y) + 2.0
    
    lb.dx = pt.x - lb.now_point.x
    lb.dy = pt.y - lb.now_point.y
    lb.dspan = span - lb.now_span
    
    // initialize internal parameters
    lb.cosv = 0.0
    lb.sinv = 0.0
    lb.step = 0
    lb.step_span = 0.0
    
    // calculate internal parameters
    lb.length = sqrt( lb.dx * lb.dx + lb.dy * lb.dy )
    if lb.length <= 0.0 {
        lb.is_stopped = true
        // 状態オブジェクトを上書き
        line.lb = lb
        return LLRegionZero()
    }

    lb.cosv = lb.dx / lb.length
    lb.sinv = lb.dy / lb.length

    // linear step calculation.
    let calc_leng1:LLDouble = lb.length / lb.now_span
    let calc_leng2:LLDouble = lb.length / span
    lb.step_all = (calc_leng1 + calc_leng2) / 2.0
    if lb.step_all < 1 {
        lb.is_stopped = true
        // 状態オブジェクトを上書き
        line.lb = lb;
        return LLRegionZero()
    }
    
    lb.step_span = lb.dspan / lb.step_all

    // initialize output paramters
    lb.ls.pt = lb.now_point
    lb.ls.length = lb.length
    lb.ls.cosv = lb.cosv
    lb.ls.sinv = lb.sinv
    lb.ls.span = lb.now_span
    lb.ls.progress = 0.0

    lb.is_stopped = false
    
    // 状態オブジェクトを上書き
    line.lb = lb
    
    // return region
    return reg
}

/// Bresenhamラインステップアルゴリズムを進行させ,次のプロット情報を取得する
/// - Parameter line: Bresenhamラインステップアルゴリズムオブジェクト
/// - Returns: ラインステップ情報
public func LCAlgoLineBresenhamNext( _ line:LCAlgoLineBresenhamSmPtr ) -> LLAlgoLineStep {
    var lb:__LCAlgoLineBresenham = line.lb
    
    // 停止のチェック
    lb.is_stopped = (lb.step_all <= lb.step)
    if lb.is_stopped {
        // 状態オブジェクトを上書き
        line.lb = lb
        return line.lb.ls;
    }

    // ステップの更新
    lb.step += 1.0
    
    // 情報の更新・加算
    lb.ls.progress = LLMin( 1.0, lb.step / lb.step_all )
    lb.ls.span += lb.step_span    
    lb.ls.pt.x += lb.ls.span * lb.cosv
    lb.ls.pt.y += lb.ls.span * lb.sinv

    // 現在情報を最新で上書き
    lb.now_point = lb.ls.pt
    lb.now_span  = lb.ls.span

    // 停止の再チェック
    lb.is_stopped = (lb.step_all <= lb.step)
    // 状態オブジェクトを上書き
    line.lb = lb
    
    return line.lb.ls
}

/// Bresenhamラインステップアルゴリズムの現在のステップ情報を取得する
/// - Parameter line: Bresenhamラインステップアルゴリズムオブジェクト
/// - Returns: ラインステップ情報
public func LCAlgoLineBresenhamNow( _ line:LCAlgoLineBresenhamSmPtr ) -> LLAlgoLineStep {
    return line.lb.ls
}

/// Bresenhamラインステップアルゴリズムのターゲット追跡が終了しているかを返す
/// - Parameter line: Bresenhamラインステップアルゴリズムオブジェクト
/// - Returns: 追跡停止状況(停止している = true, 追跡中 = false)
public func LCAlgoLineBresenhamIsStopped( _ line:LCAlgoLineBresenhamSmPtr ) -> Bool {
    return line.lb.is_stopped
}
