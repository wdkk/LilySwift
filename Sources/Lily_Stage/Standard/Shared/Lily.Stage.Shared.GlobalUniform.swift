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
import simd

extension Lily.Stage.Shared
{
    public struct GlobalUniform 
    {
        public struct CameraUniformArray
        {
            public var uniforms = ( CameraUniform(), CameraUniform(), CameraUniform() )
            
            public subscript( index:Int ) -> CameraUniform {
                get { 
                    return Mirror( reflecting:uniforms ).children[AnyIndex(index)].value as? CameraUniform ?? CameraUniform()
                }
                set {
                    switch index {
                        case 0: uniforms.0 = newValue
                        case 1: uniforms.1 = newValue
                        case 2: uniforms.2 = newValue
                        default: print( "out of range shadow camera" )
                    }
                }
            }
        }
        
        public var cameraUniform = CameraUniform()
        public var shadowCameraUniforms = CameraUniformArray()
        
        public var invScreenSize:LLFloatv2 = .zero
        public var aspect:Float = 1.0
        
        public var sunDirection:LLFloatv3 = .zero
        public var projectionYScale:Float = 0.0
        public var ambientOcclusionContrast:Float = 0.0
        public var ambientOcclusionScale:Float = 0.0
        public var ambientLightScale:Float = 0.0
        
        public var frameTime:Float = 0.0
        
        public init() {}
    }
    
    // Vision用のGlobalUniform
    public struct GlobalUniformArray
    {
        public var uniforms:( GlobalUniform, GlobalUniform ) = ( .init(), .init() )
        
        public init() {}
        
        public subscript( index:Int ) -> GlobalUniform {
            get { 
                return Mirror( reflecting:uniforms ).children[AnyIndex(index)].value as? GlobalUniform ?? GlobalUniform()
            }
            set {
                switch index {
                    case 0: uniforms.0 = newValue
                    case 1: uniforms.1 = newValue
                    default: print( "out of range shadow camera" )
                }
            }
        }
    }
}
