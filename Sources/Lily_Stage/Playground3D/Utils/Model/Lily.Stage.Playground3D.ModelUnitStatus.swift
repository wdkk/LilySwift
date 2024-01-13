//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground3D
{    
    public struct ModelUnitStatus
    {
        //-- メモリアラインメント範囲START --//
        // 公開パラメータ
        public var key:String = ""
        public var matrix:LLMatrix4x4 = .identity
        // 内部パラメータ
        fileprivate var lifes:LLFloatv2 = LLFloatv2(
            1.0,    // life
            0.0     // deltaLife
        )
        fileprivate var states:LLFloatv2 = LLFloatv2(
            1.0,                       // enabled: 1.0 = true, 0.0 = false
            LifeState.trush.rawValue   // state: .active or .trush    
        )
        //-- メモリアラインメント範囲END --//
        
        public init( key:String ) { self.key = key }
        
        public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
        public var state:LifeState { get { LifeState( rawValue: states.y )! } set { states.y = newValue.rawValue } }
    }
}
