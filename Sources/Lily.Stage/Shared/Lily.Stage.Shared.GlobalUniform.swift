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
            var uniforms = ( CameraUniform(), CameraUniform(), CameraUniform() )
            
            subscript( index:Int ) -> CameraUniform {
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
        
        var cameraUniform = CameraUniform()
        var shadowCameraUniforms = CameraUniformArray()
        
        var invScreenSize:LLFloatv2 = .zero
        var aspect:Float = 1.0
        
        var sunDirection:LLFloatv3 = .zero
        var projectionYScale:Float = 0.0
        var ambientOcclusionContrast:Float = 0.0
        var ambientOcclusionScale:Float = 0.0
        var ambientLightScale:Float = 0.0
        
        var frameTime:Float = 0.0
    }
    
    // Vision用のGlobalUniform
    public struct GlobalUniformArray
    {
        var uniforms:( GlobalUniform, GlobalUniform )
        
        subscript( index:Int ) -> GlobalUniform {
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
