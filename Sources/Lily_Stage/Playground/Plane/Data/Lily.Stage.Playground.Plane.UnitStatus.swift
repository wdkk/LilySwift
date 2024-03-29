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

extension Lily.Stage.Playground.Plane
{    
    public struct UnitStatus
    {
        //-- メモリアラインメント範囲START --//
        // 公開パラメータ
        public var matrix:LLMatrix4x4 = .identity                   
        public var atlasUV:LLFloatv4 = .init( 0.0, 0.0, 1.0, 1.0 ) 
        public var color:LLFloatv4 = LLColor.black.floatv4         
        public var deltaColor:LLFloatv4 = .zero                     
        public var color2:LLFloatv4 = LLColor.black.floatv4  
        public var deltaColor2:LLFloatv4 = .zero               
        public var color3:LLFloatv4 = LLColor.black.floatv4     
        public var deltaColor3:LLFloatv4 = .zero                 
        public var color4:LLFloatv4 = LLColor.black.floatv4 
        public var deltaColor4:LLFloatv4 = .zero                    
        public var position:LLFloatv2 = .zero               
        public var deltaPosition:LLFloatv2 = .zero          
        public var scale:LLFloatv2 = .init( 100.0, 100.0 )   
        public var deltaScale:LLFloatv2 = .zero         
        
        public var angle:LLFloat = 0.0
        public var deltaAngle:LLFloat = 0.0
        
        public var life:LLFloat = 1.0
        public var deltaLife:LLFloat = 1.0

        public var zIndex:LLFloat = 0.0
        public var childDepth:LLUInt32 = 0

        public var shaderIndex:LLInt32 = -1
        public var _r:LLInt32 = -1
        public var _r2:LLInt32 = -1
        public var _r3:LLInt32 = -1
        
        public var startTime:LLFloat = LLClock.Precision.now.f
        public var elapsedTime:LLFloat = 0.0
        
        public private(set) var states:LLFloatv2 = LLFloatv2(
            1.0,                       // enabled: 1.0 = true, 0.0 = false
            LifeState.trush.rawValue   // state: .active or .trush    
        )
        public private(set) var types:(LLUInt32, LLUInt32) = (
            CompositeType.alpha.rawValue,
            ShapeType.rectangle.rawValue
        )
                
        //-- メモリアラインメント範囲END --//
        
        public init() {}
        
        // アクセサ
        public var enabled:Bool { get { states.x > 0.0 } set { states.x = newValue ? 1.0 : 0.0 } }
        public var state:LifeState { get { .init( rawValue: states.y )! } set { states.y = newValue.rawValue } }
        
        public var compositeType:CompositeType { get { .init( rawValue:types.0 )! } set { types.0 = newValue.rawValue } }
        public var shapeType:ShapeType { get { .init( rawValue:types.1 )! } set { types.1 = newValue.rawValue } }
    }
}
