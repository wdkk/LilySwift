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
    public struct PGFunction
    {
        public var name:String
        public var code:String
        public var function:MTLFunction?
        
        public init( device:MTLDevice, name:String, code:String ) {
            self.name = name
            self.code = code
            
            let shader = Lily.Metal.Shader(
                device:device, 
                code:"""
                #include <metal_stdlib>
                using namespace metal;
                \(Lily.Stage.Playground.Plane.h_SMetal)
                
                [[visible]]
                float4 \(name)( 
                    Plane::CustomShaderParam p
                ) 
                {     
                    \(code)
                }
                """,
                shaderName:name
            )
            
            self.function = shader.function
        }
    }
}

extension [Lily.Stage.Playground.Plane.PGFunction]
{  
    public var metalFunctions:[MTLFunction] { self.filter { $0.function != nil }.map { $0.function! } }
}
