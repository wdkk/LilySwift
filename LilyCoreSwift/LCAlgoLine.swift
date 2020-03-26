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

/// ラインアルゴリズムのステップ情報構造体
public struct LLAlgoLineStep
{
    /// 座標
    public var pt:LLPoint
    /// 移動距離
    public var length:LLDouble
    /// 移動方向cos
    public var cosv:LLDouble
    /// 移動方向sin
    public var sinv:LLDouble
    /// ステップ間の長さ
    public var span:LLDouble
    /// ターゲット間移動の進捗率(0.0~1.0)
    public var progress:LLDouble
    
    /// 初期化関数
    /// - Parameters:
    ///   - pt: 座標
    ///   - length: 移動距離
    ///   - cosv: 移動方向cos
    ///   - sinv: 移動方向sin
    ///   - span: ステップ間の長さ
    ///   - progress: ターゲット間移動の進捗率
    public init( _ pt:LLPoint = LLPointZero(),
                 _ length:LLDouble = 0.0,
                 _ cosv:LLDouble = 0.0,
                 _ sinv:LLDouble = 0.0,
                 _ span:LLDouble = 0.0,
                 _ progress:LLDouble = 0.0 )
    {
        self.pt = pt
        self.length = length
        self.cosv = cosv
        self.sinv = sinv
        self.span = span
        self.progress = progress
    }
}
