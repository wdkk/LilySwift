//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public enum LBState : Float
{
    case active = 1.0
    case trush  = 0.0
}

public struct LBPanelVertex 
{
    var xy = LLFloatv2()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
    var uv = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
    var tex_uv = LLFloatv2() // 0.0 ~ 1.0 アトラス内の座標
}

public struct LBPanelParam : LLMetalBufferAllocatable
{
    //-- メモリアラインメント範囲START --//
    // 公開パラメータ
    public var matrix:LLMatrix4x4
    public var color:LLFloatv4
    public var deltaColor:LLFloatv4
    public var position:LLFloatv2
    public var deltaPosition:LLFloatv2
    public var scale:LLFloatv2
    public var deltaScale:LLFloatv2
    public var angle:LLFloat
    public var deltaAngle:LLFloat
    // 内部パラメータ
    fileprivate var indices:LLFloatv2    // zindex & arrayindex
    fileprivate var lifes:LLFloatv2      // enabled & life
    fileprivate var states:LLFloatv2     // trush & (reserved)
    //-- メモリアラインメント範囲END --//
    
    // アクセサ
    public var zindex:LLFloat { get { indices.x } set { indices.x = newValue } }
    public var arrayIndex:Int { get { indices.y.i! } set { indices.y = newValue.f } }
    public var state:LBState { get { LBState( rawValue: states.x )! } set { states.x = newValue.rawValue } }
    public var enabled:Bool { get { lifes.x > 0.0 } set { lifes.x = newValue ? 1.0 : 0.0 } }
    public var life:LLFloat { get { lifes.y } set { lifes.y = newValue } }
    
    public init() {
        matrix = .identity
        
        color = LLColor.black.floatv4
        
        deltaColor = .zero
        
        position = LLFloatv2(
            0.0,
            0.0 
        )
        
        deltaPosition = .zero
        
        scale = LLFloatv2(
            100.0,
            100.0
        )
        
        deltaScale = .zero
        
        angle = 0.0
        
        deltaAngle = 0.0
        
        indices = LLFloatv2(
            0.0,    // zIndex
            0.0     // arrayIndex
        )
        states = LLFloatv2(
            LBState.active.rawValue,    // state = active
            0.0                         // reserved
        )
        lifes = LLFloatv2(
            1.0,    // enabled = true
            1.0     // life = 1.0
        )
    }
}
