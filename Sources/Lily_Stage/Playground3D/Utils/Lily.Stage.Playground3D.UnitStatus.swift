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
    public struct UnitStatus
    {
        //-- メモリアラインメント範囲START --//
        // 公開パラメータ
        public var matrix:LLMatrix4x4 = .identity
        public var atlasUV:LLFloatv4 = .init( 0.0, 0.0, 1.0, 1.0 )
        public var color:LLFloatv4 = LLColor.black.floatv4
        public var deltaColor:LLFloatv4 = .zero
        public var position:LLFloatv3 = .zero
        private var _reserved:LLFloat = 0.0
        public var deltaPosition:LLFloatv3 = .zero
        private var _reserved2:LLFloat = 0.0
        public var scale:LLFloatv2 = .init( 100.0, 100.0 )
        public var deltaScale:LLFloatv2 = .zero
        public var angle:LLFloat = 0.0
        public var deltaAngle:LLFloat = 0.0
        // 内部パラメータ
        fileprivate var lifes:LLFloatv2 = LLFloatv2(
            1.0,    // life
            0.0     // deltaLife
        )
        fileprivate var states:LLFloatv2 = LLFloatv2(
            1.0,                       // enabled: 1.0 = true, 0.0 = false
            LifeState.trush.rawValue   // state: .active or .trush    
        )
        fileprivate var types:(LLUInt32, LLUInt32) = (
            CompositeType.alpha.rawValue,
            ShapeType.rectangle.rawValue
        )
        //-- メモリアラインメント範囲END --//
        
        // アクセサ
        public var life:LLFloat { get { lifes.x } set { lifes.x = newValue } }
        public var deltaLife:LLFloat { get { lifes.y } set { lifes.y = newValue } }

        public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
        public var state:LifeState { get { LifeState( rawValue: states.y )! } set { states.y = newValue.rawValue } }
        
        public var compositeType:CompositeType { get { CompositeType( rawValue:types.0 )! } set { types.0 = newValue.rawValue } }
        public var shapeType:ShapeType { get { ShapeType( rawValue:types.1 )! } set { types.1 = newValue.rawValue } }
        
        static let reset = UnitStatus(
            matrix: .identity, 
            atlasUV: .init( 0.0, 0.0, 1.0, 1.0 ),
            color: LLColor.black.floatv4, 
            deltaColor: .zero, 
            position: .zero,
            _reserved: 0.0,
            deltaPosition: .zero,
            _reserved2: 0.0,
            scale: .init( 100.0, 100.0 ),
            deltaScale: .zero, 
            angle: 0.0,
            deltaAngle: 0.0,
            lifes: .init( 1.0, 0.0 ), 
            states: .init( 1.0, 0.0 ), 
            types: ( 0, 0 ) 
        )
    }
}
