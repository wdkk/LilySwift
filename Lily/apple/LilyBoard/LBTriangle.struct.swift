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

public struct LBTriangleVertex 
{
    var xy = LLFloatv2()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
    var uv = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
    var tex_uv = LLFloatv2() // 0.0 ~ 1.0 アトラス内の座標
}

public struct LBTriangleStep
{
    public var step:(( inout LBTriangleParam )->Void)?
}

public struct LBTriangleParam : LLMetalBufferAllocatable
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
    fileprivate var lifes:LLFloatv2      // life & deltaLife
    fileprivate var states:LLFloatv2     // enabled & trash
    //-- メモリアラインメント範囲END --//
    
    // アクセサ
    public var zindex:LLFloat { get { indices.x } set { indices.x = newValue } }
    public var arrayIndex:Int { get { indices.y.i! } set { indices.y = newValue.f } }

    public var life:LLFloat { get { lifes.x } set { lifes.x = newValue } }
    public var deltaLife:LLFloat { get { lifes.y } set { lifes.y = newValue } }

    public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
    public var state:LBState { get { LBState( rawValue: states.y )! } set { states.y = newValue.rawValue } }
    
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
            1.0,                      // enabled = true
            LBState.active.rawValue   // state = .active      
        )
        lifes = LLFloatv2(
            1.0,    // life = 1.0
            0.0     // deltaLife = 0.0
        )
    }
}
