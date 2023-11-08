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

/// 2Dアフィン変換係数を作成
/// - Parameters:
///   - a: 係数a
///   - b: 係数b
///   - c: 係数c
///   - d: 係数d
///   - e: 係数e
///   - f: 係数f
/// - Returns: 2次元アフィン変換係数
/// - Description: x' = ax + by + c, y' = dx + ey + fの式の係数となる
public func LL2DAffineMake( _ a:Double, _ b:Double, _ c:Double, _ d:Double, _ e:Double, _ f:Double ) -> LL2DAffine {
    return LL2DAffine( a:a, b:b, c:c, d:d, e:e, f:f )
}

/// 2Dアフィン変換係数(単位係数群: a=1, b=0, c=0, b=0, e=1, f=0)を取得
public func LL2DAffineIdentity() -> LL2DAffine {
    return LL2DAffine( a:1.0, b:0.0, c:0.0, d:0.0, e:1.0, f:0.0 )
}

/// 平行移動の2Dアフィン変換係数を作成する
/// - Parameters:
///   - tx: x方向平行移動量
///   - ty: y方向平行移動量
/// - Returns: 平行移動の2Dアフィン変換係数
public func LL2DAffineTranslate( _ tx:Double, _ ty:Double ) -> LL2DAffine {
    return LL2DAffine( a:1.0, b:0.0, c:tx, d:0.0, e:1.0, f:ty )
}

/// 拡大縮小の2Dアフィン変換係数を作成する
/// - Parameters:
///   - scx: x方向拡大率
///   - scy: y方向拡大率
/// - Returns: 拡大縮小の2Dアフィン変換係数
public func LL2DAffineScale( _ scx:Double, _ scy:Double ) -> LL2DAffine {
    return LL2DAffine( a:scx, b:0.0, c:0.0, d:0.0, e:scy, f:0.0 )
}
    
/// 回転の2Dアフィン変換係数を作成する
/// - Parameter degree: 回転角(360度法)
/// - Returns: 回転の2Dアフィン変換係数
public func LL2DAffineRotate( _ degree:Double ) -> LL2DAffine {
    let rad:LLDouble = degree * LL_PI / 180.0
    let cosv:LLDouble = cos( rad )
    let sinv:LLDouble = sin( rad )
    return LL2DAffine( a:cosv, b:-sinv, c:0.0, d:sinv, e:cosv, f:0.0 )
}

/// 2Dアフィン変換係数の合成
/// - Parameters:
///   - af1: 合成元のアフィン変換係数1
///   - af2: 合成元のアフィン変換係数2
/// - Returns: 合成結果のアフィン変換係数
public func LL2DAffineMultiply( _ af1:LL2DAffine, _ af2:LL2DAffine ) -> LL2DAffine {
    return LL2DAffine(
        a: af1.a * af2.a + af1.d * af2.b,
        b: af1.b * af2.a + af1.e * af2.b,
        c: af1.c * af2.a + af1.f * af2.b + af2.c,
        d: af1.a * af2.d + af1.d * af2.e,
        e: af1.b * af2.d + af1.e * af2.e,
        f: af1.c * af2.d + af1.f * af2.e + af2.f )
}

/// 逆2Dアフィン変換係数の計算
/// - Parameter af: 元となるアフィン変換係数
/// - Returns: 逆アフィン変換係数
public func LL2DAffineInverse( _ af:LL2DAffine ) -> LL2DAffine {
    let work:LLDouble = af.a * af.e - af.b * af.d
    return LL2DAffine(
        a: af.e / work,
        b: -af.b / work,
        c: (af.b * af.f - af.c * af.e) / work,
        d: -af.d / work,
        e: af.a / work,
        f: (af.c * af.d - af.a * af.f) / work )
}
