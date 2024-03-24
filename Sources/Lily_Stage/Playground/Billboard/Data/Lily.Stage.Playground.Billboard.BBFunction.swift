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

extension Lily.Stage.Playground.Billboard
{  
    public struct BBFunction
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
                \(Lily.Stage.Playground.Billboard.h_SMetal)
                
                [[visible]]
                float4 \(name)( 
                    float2 pos,
                    float2 uv,
                    float4 color,
                    float4 color2,
                    float4 color3,
                    float4 color4,
                    float alpha,
                    float alpha2,
                    float alpha3,
                    float alpha4,
                    float4 texColor,
                    float texAlpha,
                    texture2d<float> tex
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

extension [Lily.Stage.Playground.Billboard.BBFunction]
{  
    public var metalFunctions:[MTLFunction] { self.filter { $0.function != nil }.map { $0.function! } }
}
