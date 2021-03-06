//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public enum LBActorState : Float
{
    case active = 1.0
    case trush  = 0.0
}

public struct LBActorVertex 
{
    var xy = LLFloatv2()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
    var uv = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
    var tex_uv = LLFloatv2() // 0.0 ~ 1.0 テクスチャのuv座標
}

public struct LBActorParam
{
    //-- メモリアラインメント範囲START --//
    // 公開パラメータ
    public var matrix:LLMatrix4x4 = .identity
    public var atlasUV:LLFloatv4 = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
    public var color:LLFloatv4 = LLColor.black.floatv4
    public var deltaColor:LLFloatv4 = .zero
    public var position:LLFloatv2 = .zero
    public var deltaPosition:LLFloatv2 = .zero
    public var scale:LLFloatv2 = LLFloatv2( 100.0, 100.0 )
    public var deltaScale:LLFloatv2 = .zero
    public var angle:LLFloat = 0.0
    public var deltaAngle:LLFloat = 0.0
    // 内部パラメータ
    fileprivate var indices:LLFloatv2 = LLFloatv2(
        0.0,    // zIndex
        0.0     // arrayIndex
    )
    fileprivate var lifes:LLFloatv2 = LLFloatv2(
        1.0,    // life
        0.0     // deltaLife
    )
    fileprivate var states:LLFloatv2 = LLFloatv2(
        1.0,                           // enabled = true
        LBActorState.active.rawValue   // state = .active      
    )
    //-- メモリアラインメント範囲END --//
    
    // アクセサ
    public var arrayIndex:Int { get { indices.y.i! } set { indices.y = newValue.f } }

    public var life:LLFloat { get { lifes.x } set { lifes.x = newValue } }
    public var deltaLife:LLFloat { get { lifes.y } set { lifes.y = newValue } }

    public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
    public var state:LBActorState { get { LBActorState( rawValue: states.y )! } set { states.y = newValue.rawValue } }
}
