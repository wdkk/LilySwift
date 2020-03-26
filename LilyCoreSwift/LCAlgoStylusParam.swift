//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// ラインアルゴリズムを用いたスタイラスステップ情報
public struct LLAlgoStylusParamStep
{
    // 筆圧
    public var force:LLDouble
    // 方位角
    public var azimuth_angle:LLDouble
    // 方位角のxベクトル
    public var azimuth_vec_x:LLDouble
    // 方位角のyベクトル
    public var azimuth_vec_y:LLDouble
    // スタイラスの高度(傾き)
    public var altitude:LLDouble
    
    /// 初期化
    /// - Parameters:
    ///   - force: 筆圧
    ///   - azimuth_angle: 方位角
    ///   - azimuth_vec_x: 方位角xベクトル
    ///   - azimuth_vec_y: 方位角yベクトル
    ///   - altitude: スタイラスの高度(傾き)
    public init( _ force:LLDouble = 0.0,
                 _ azimuth_angle:LLDouble = 0.0,
                 _ azimuth_vec_x:LLDouble = 0.0,
                 _ azimuth_vec_y:LLDouble = 0.0,
                 _ altitude:LLDouble = 0.0 ) 
    {
        self.force = force
        self.azimuth_angle = azimuth_angle
        self.azimuth_vec_x = azimuth_vec_x
        self.azimuth_vec_y = azimuth_vec_y
        self.altitude = altitude
    }
}

/// ラインアルゴリズムを用いたスタイラスステップ情報の内部実装クラス
private struct __LCAlgoStylusParam
{
    /// 開始点(1つ前のターゲット)ステップ情報
    var start = LLAlgoStylusParamStep()
    /// 現在のステップ情報
    var now = LLAlgoStylusParamStep()
    /// 次のターゲットステップ情報
    var target = LLAlgoStylusParamStep()
} 

/// スタイラスステップ情報モジュール
public class LCAlgoStylusParamSmPtr
{
    /// 内部実装オブジェクト
    fileprivate var p = __LCAlgoStylusParam()
    
    fileprivate init() {}
}

/// スタイラスステップ情報オブジェクトの作成
/// - Returns: スタイラスステップ情報オブジェクト
public func LCAlgoStylusParamMake() -> LCAlgoStylusParamSmPtr {
    return LCAlgoStylusParamSmPtr()
}

/// スタイラスステップ情報オブジェクトの開始情報を設定
/// - Parameters:
///   - lsp: スタイラスステップ情報オブジェクト
///   - start_step: 開始ステップ情報
public func LCAlgoStylusParamStart( _ lsp:LCAlgoStylusParamSmPtr, _ start_step:LLAlgoStylusParamStep ) {
    var p = lsp.p
    p.start = start_step
    p.now = start_step
    p.target = start_step
    lsp.p = p
}


/// スタイラスステップ情報オブジェクトの次のターゲット情報を設定
/// - Parameters:
///   - lsp: スタイラスステップ情報オブジェクト
///   - retarget_step: 次のターゲットになるステップ情報
public func LCAlgoStylusParamRetarget( _ lsp:LCAlgoStylusParamSmPtr, _ retarget_step:LLAlgoStylusParamStep ) {
    var p = lsp.p
    // nowの値をstartの値に更新
    p.start = p.now
    // 目標値の更新
    p.target = retarget_step
    lsp.p = p
}


/// スタイラスステップ情報オブジェクトの進捗に合わせたステップ情報を取得
/// - Parameters:
///   - lsp: スタイラスステップ情報オブジェクト
///   - k: 進捗率(0.0 ~ 1.0)
/// - Returns: 進捗率のスタイラスステップ情報
public func LCAlgoStylusParamProgress( _ lsp:LCAlgoStylusParamSmPtr, _ k:LLDouble ) -> LLAlgoStylusParamStep {
    var p = lsp.p
    var step = LLAlgoStylusParamStep()
    
    // アルファ係数
    let k1 = LLWithin( min: 0.0, k, max: 1.0 )
    let k2 = (1.0 - k1)
    
    // アルファ計算
    step.force = p.start.force * k2 + p.target.force * k1
    step.azimuth_angle = p.start.azimuth_angle * k2 + p.target.azimuth_angle * k1
    step.azimuth_vec_x = p.start.azimuth_vec_x * k2 + p.target.azimuth_vec_x * k1
    step.azimuth_vec_y = p.start.azimuth_vec_y * k2 + p.target.azimuth_vec_y * k1
    step.altitude = p.start.altitude * k2 + p.target.altitude * k1

    // nowの値を更新
    p.now = step
    
    // クラス内部値の上書き
    lsp.p = p    

    // stepの値を返す
    return p.now
}
