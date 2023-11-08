//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// Hermiteラインステップアルゴリズムの内部実装クラス
private struct __LCAlgoLineHermite
{
    /// Hermiteの初期頂点p0
    var p0:LLPoint = LLPointZero()
    /// Hermiteの目標頂点p1
    var p1:LLPoint = LLPointZero()
    /// Hermiteの初期ベクトルv0
    var v0:LLPoint = LLPointZero()
    /// Hermiteの目標ベクトルv1
    var v1:LLPoint = LLPointZero()

    /// Hermite曲線ターゲット1回分の移動距離
    var hermite_length:LLDouble = 0.0 
    /// ターゲット移動中の累積移動距離( <= hermite_length ) 
    var accumulated_length:LLDouble = 0.0 
    
    /// 停止確認フラグ
    var is_stopped:Bool = true
    /// Hermiteのステップ進行状況
    var hermite_step:LLDouble = 0.0
    /// 最小のspan
    var min_span:LLDouble = 0.0
    
    /// 現在ステップ情報
    var ls:LLAlgoLineStep = LLAlgoLineStep()   
    /// 前回ステップ情報
    var pre:LLAlgoLineStep = LLAlgoLineStep()  
    /// 差分情報
    var delta:LLAlgoLineStep = LLAlgoLineStep() 
    /// 保管用ステップ情報
    var store:LLAlgoLineStep = LLAlgoLineStep() 
}

/// Hermiteラインステップアルゴリズムモジュール
public class LCAlgoLineHermiteSmPtr
{
    /// 内部実装オブジェクト
    fileprivate var lh:__LCAlgoLineHermite = __LCAlgoLineHermite()
    
    fileprivate init() {}
}

/// Hermite曲線の計算
/// - Parameters:
///   - pp0: 頂点0
///   - vv0: ベクトル0
///   - pp1: 頂点1
///   - vv1: ベクトル1
///   - dev: 曲線の進捗係数(0.0=pp0 ~ 1.0=pp1)
/// - Returns: 指定したdevで得られた座標値
private func __LCAlgoLineHermiteGetCurve( _ pp0:LLPoint, _ vv0:LLPoint, _ pp1:LLPoint, _ vv1:LLPoint, _ dev:LLDouble ) 
-> LLPoint {
    let d1:LLDouble = dev
    let d2:LLDouble = d1 * d1
    let d3:LLDouble = d1 * d1 * d1

    let mp0:LLDouble =  2.0 * d3 - 3.0 * d2 + 1.0
    let mv0:LLDouble =        d3 - 2.0 * d2 + d1
    let mp1:LLDouble = -2.0 * d3 + 3.0 * d2
    let mv1:LLDouble =        d3 -       d2

    let v:LLPoint = LLPoint( 
        pp0.x * mp0 + vv0.x * mv0 + pp1.x * mp1 + vv1.x * mv1,
        pp0.y * mp0 + vv0.y * mv0 + pp1.y * mp1 + vv1.y * mv1
    )
    return v
}

/// Hermite曲線の移動距離(積分値)
/// - Parameters:
///   - pp0: 頂点0
///   - vv0: ベクトル0
///   - pp1: 頂点1
///   - vv1: ベクトル1
///   - sample: 積分サンプル数
///   - region: (inout)移動範囲の外接領域
/// - Returns: 移動距離
private func __LCAlgoLineHermiteLength( _ pp0:LLPoint, _ vv0:LLPoint, _ pp1:LLPoint, _ vv1:LLPoint, _ sample:Int, _ region:inout LLRegion ) 
-> LLDouble {
    var integral:LLDouble = 0.0
    var prev_pt = pp0

    var reg = LLRegionMake( 999999.0, 999999.0, -999999.0, -999999.0 )
    
    for i in 0 ..< sample+1 {
        let dev = Double(i) / Double(sample+1)
        let next_pt = __LCAlgoLineHermiteGetCurve( pp0, vv0, pp1, vv1, dev )

        let dx = next_pt.x - prev_pt.x
        let dy = next_pt.y - prev_pt.y
        
        integral += sqrt(dx * dx + dy * dy)
        prev_pt = next_pt
        
        reg.left   = LLMin( next_pt.x, reg.left )
        reg.top    = LLMin( next_pt.y, reg.top )
        reg.right  = LLMax( next_pt.x, reg.right )
        reg.bottom = LLMax( next_pt.y, reg.bottom )
    }
    
    region = reg
    
    return integral
}

/// Hermiteラインステップアルゴリズムのオブジェクトを作成
public func LCAlgoLineHermiteMake() -> LCAlgoLineHermiteSmPtr {
    return LCAlgoLineHermiteSmPtr()
}

/// Hermiteラインステップアルゴリズムの開始情報を設定する
/// - Parameters:
///   - line: Hermiteラインステップアルゴリズムオブジェクト
///   - pt: 初期座標(x,y)
///   - span: 初期プロット距離
public func LCAlgoLineHermiteStart( _ line:LCAlgoLineHermiteSmPtr, _ pt:LLPoint, _ span:LLDouble ) {
    var lh = line.lh
    
    lh.is_stopped = true
    lh.min_span = span
    lh.hermite_length = 0.0
    lh.accumulated_length = 0.0
        
    // 公開LineStep情報の設定
    lh.ls.progress = 0.0
    lh.ls.pt = pt
    lh.ls.length = 0.0
    lh.ls.cosv = 1.0
    lh.ls.sinv = 0.0
    lh.ls.span = span

    // ストア用情報をコピー
    lh.pre = lh.ls
    lh.store = lh.ls
    
    // 差分もnowで初期化
    lh.delta.pt = LLPointZero()
    lh.delta.span = lh.ls.span
    
    // 状態オブジェクトを上書き
    line.lh = lh
}

/// Hermiteラインステップアルゴリズムの次のターゲット情報を設定する
/// - Parameters:
///   - line: Hermiteラインステップアルゴリズムオブジェクト
///   - pt: 次の目標(x,y)座標
///   - span: 新しいプロット距離
/// - Returns: 移動範囲の外接領域
/// - Description: spanは前のターゲットで指定した値で線形に変化していく
@discardableResult
public func LCAlgoLineHermiteRetarget( _ line:LCAlgoLineHermiteSmPtr, _ pt:LLPoint, _ span:LLDouble ) -> LLRegion {
    var lh = line.lh
    
    lh.pre = lh.store
    
    let dpt = LLPointMake( pt.x - lh.pre.pt.x, pt.y - lh.pre.pt.y )
    let dist2 = dpt.x * dpt.x + dpt.y * dpt.y
    
    if dist2 < span {
        lh.is_stopped = true
        // 状態オブジェクトを上書き
        line.lh = lh
        return LLRegionZero()
    }
    
    lh.min_span = LLMin( span, lh.pre.span )

    let leng = sqrt( dist2 )
    if leng <= 0.0 {
        lh.is_stopped = true
        // 状態オブジェクトを上書き
        line.lh = lh
        return LLRegionZero()
    }
    
    // ベクトル強度の係数(0.5,0.5は両方のベクトルを半分ずつ扱う)
    let k1 = 0.5
    let k2 = 0.5

    lh.p0 = LLPointMake( lh.pre.pt.x, lh.pre.pt.y )
    lh.v0 = LLPointMake( lh.delta.pt.x * k1, lh.delta.pt.y * k1 )  // ひとつ前のベクトルを用いる
    lh.p1 = LLPointMake( pt.x, pt.y )
    lh.v1 = LLPointMake( dpt.x * k2, dpt.y * k2 )  // 新たに計算したベクトルdptを用いる
    
    // 差分データの更新
    lh.delta.pt = dpt
    lh.delta.span  = span - lh.pre.span
    
    // 移動の長さを取得するサンプル数は2点間距離x5回.
    var reg = LLRegionZero()
    let sample = Int( lh.hermite_length * 5.0 )
    lh.hermite_length = LLMax( __LCAlgoLineHermiteLength( lh.p0, lh.v0, lh.p1, lh.v1, sample, &reg ), leng )
    lh.accumulated_length = 0.0
    
    lh.ls.progress = 0.0
    lh.ls.length = lh.pre.length
    lh.ls.cosv = lh.pre.cosv
    lh.ls.sinv = lh.pre.sinv
    lh.ls.span = lh.pre.span

    // ストア用情報をコピー
    lh.store = lh.ls
    
    // ステップ処理, フラグの更新
    lh.hermite_step = 0.0
    lh.is_stopped = false
    
    // 状態オブジェクトを上書き
    line.lh = lh
    // return region
    return reg
}

/// Hermiteラインステップアルゴリズムを進行させ,次のプロット情報を取得する
/// - Parameter line: Hermiteラインステップアルゴリズムオブジェクト
/// - Returns: ラインステップ情報
public func LCAlgoLineHermiteNext( _ line:LCAlgoLineHermiteSmPtr ) -> LLAlgoLineStep {
    var lh = line.lh
    
    lh.store = lh.ls
    
    if lh.is_stopped { 
        // 状態オブジェクトを上書き
        line.lh = lh
        return lh.store 
    }
    
    // ステップ単位(lh.lengの長さに係数をかけて求める)
    let step_unit = LLMin( 0.25, 0.05 / lh.hermite_length )
    // 終了判定値
    let hermite_step_end_point = 1.0 - step_unit
    
    var sum_leng = 0.0
    var prev_point = __LCAlgoLineHermiteGetCurve( lh.p0, lh.v0, lh.p1, lh.v1, lh.hermite_step )
    
    while true {
        // エルミート曲線を1ステップ進める
        lh.hermite_step += step_unit
        let point = __LCAlgoLineHermiteGetCurve( lh.p0, lh.v0, lh.p1, lh.v1, lh.hermite_step )
        // 移動距離
        let dx = point.x - prev_point.x
        let dy = point.y - prev_point.y
        let d_leng = sqrt(dx * dx + dy * dy)
        // 対象頂点の差し替え
        prev_point = point
        // 移動距離累積値の積分
        sum_leng += d_leng
        lh.accumulated_length += d_leng
        
        if lh.ls.span <= sum_leng ||
           lh.hermite_step >= hermite_step_end_point 
        {
            lh.ls.pt = point
            break
        }
    }
    
    // stepのオーバーを止める
    lh.hermite_step = LLMin( 1.0, lh.hermite_step )
    
    if lh.hermite_step >= hermite_step_end_point {
        lh.is_stopped = true
        // 状態オブジェクトを上書き
        line.lh = lh
        return line.lh.store
    }
    
    // 係数を計算(0.0 ~ 1.0に収める)
    let k = LLWithin( min: 0.0, lh.accumulated_length / lh.hermite_length, max: 1.0 )
    
    // Line Stepの値を更新
    lh.ls.progress = k
    lh.ls.length = sum_leng
    lh.ls.cosv = lh.delta.pt.x / lh.ls.length
    lh.ls.sinv = lh.delta.pt.y / lh.ls.length
    lh.ls.span = lh.pre.span + lh.delta.span * k

    // 状態オブジェクトを上書き
    line.lh = lh
    
    // hermiteステップはスパンの途中で途切れることが基本となるので、
    // 最新の値をつかうと整合性が取れなくなる。そこでひとつ前の加工前の値(store)を用いて返すものとする
    return line.lh.store
}

/// Hermiteラインステップアルゴリズムの現在のステップ情報を取得する
/// - Parameter line: Hermiteラインステップアルゴリズムオブジェクト
/// - Returns: ラインステップ情報
public func LCAlgoLineHermiteNow( _ line:LCAlgoLineHermiteSmPtr ) -> LLAlgoLineStep {
    return line.lh.ls 
}

/// Hermiteラインステップアルゴリズムのターゲット追跡が終了しているかを返す
/// - Parameter line: Hermiteラインステップアルゴリズムオブジェクト
/// - Returns: 追跡停止状況(停止している = true, 追跡中 = false)
public func LCAlgoLineHermiteIsStopped( _ line:LCAlgoLineHermiteSmPtr ) -> Bool {
    return line.lh.is_stopped
}
