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

extension Lily.Stage.Playground.Model
{    
    public struct ModelUnitStatus
    {
        //-- メモリアラインメント範囲START --//
        // 公開パラメータ
       
        public var matrix:LLMatrix4x4 = .identity
        public var atlasUV:LLFloatv4 = .init( 0.0, 0.0, 1.0, 1.0 )
        public var color:LLFloatv4 = LLColor.black.floatv4
        public var deltaColor:LLFloatv4 = .zero
        public var position:LLFloatv3 = .zero
        public var deltaPosition:LLFloatv3 = .zero
        public var scale:LLFloatv3 = .init( 1.0, 1.0, 1.0 )
        public var deltaScale:LLFloatv3 = .zero
        public var rotate:LLFloatv3 = .zero
        public var deltaRotate:LLFloatv3 = .zero
        // 内部パラメータ
        fileprivate var lifes:LLFloatv2 = LLFloatv2(
            1.0,    // life
            0.0     // deltaLife
        )
        fileprivate var states:LLFloatv2 = LLFloatv2(
            0.0,                       // enabled: 1.0 = true, 0.0 = false
            LifeState.trush.rawValue   // state: .active or .trush    
        )
        public var modelIndex:Int32
        //-- メモリアラインメント範囲END --//
        
        public init( modelIndex:Int32 ) { self.modelIndex = modelIndex }
        
        // アクセサ
        public var life:LLFloat { get { lifes.x } set { lifes.x = newValue } }
        public var deltaLife:LLFloat { get { lifes.y } set { lifes.y = newValue } }

        public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
        public var state:LifeState { get { .init( rawValue: states.y )! } set { states.y = newValue.rawValue } }
    }
}
