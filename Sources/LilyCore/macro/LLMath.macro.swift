//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// LLMaxマクロのSwift実装
/// - Parameters:
///   - v1: 比較値1
///   - v2: 比較値2
/// - Returns: v1, v2のうち大きい値
public func LLMax<T: Comparable>( _ v1:T, _ v2:T ) -> T {
    return v1 > v2 ? v1 : v2 
}

/// LLMinマクロのSwift実装
/// - Parameters:
///   - v1: 比較値1
///   - v2: 比較値2
/// - Returns: v1, v2のうち小さい値
public func LLMin<T: Comparable>( _ v1:T, _ v2:T ) -> T { 
    return v1 < v2 ? v1 : v2 
}

/// 値を範囲で区切る. vの値をmin ~ maxの間に収めた値を返す
/// - Parameters:
///   - min: 最小値
///   - v: 対象の値
///   - max: 最大値
/// - Returns: min~maxの間に収まるvの値
public func LLWithin<T: Comparable>( min:T, _ v:T, max:T ) -> T { 
    return LLMin( LLMax( min, v ), max ) 
}

/// v1とv2の値を入れ替える
/// - Parameters:
///   - v1: 入れ替える値1
///   - v2: 入れ替える値2
public func LLSwap<T: Comparable>( _ v1:inout T, _ v2:inout T ) {
    let swap:T = v1
    v1 = v2
    v2 = swap
}
