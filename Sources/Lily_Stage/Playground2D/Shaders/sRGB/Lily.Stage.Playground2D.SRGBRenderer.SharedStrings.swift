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

extension Lily.Stage.Playground2D
{   
    open class SRGBShaderString
    {
        static var importsCode:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;
        
        """ }
        
        static var definesCode:String { """
        struct SRGBVOut
        {
            float4 position [[ position ]];
        };
            
        struct SRGBFOut
        {
            float4 backBuffer [[ color(0) ]];
        };
        """ }
        
        static var sRGBVertexShaderCode:String { """
        vertex SRGBVOut Lily_Stage_Playground2D_SRGB_Vs( uint vid [[vertex_id]] )
        {
            const float2 vertices[] = {
                float2(-1, -1),
                float2( 3, -1),
                float2(-1,  3)
            };

            SRGBVOut out;
            out.position = float4( vertices[vid], 0.0, 1.0 );
            return out;
        }
        """ }
        
        static var sRGBFragmentShaderCode:String { """
        fragment SRGBFOut Lily_Stage_Playground2D_SRGB_Fs(
            SRGBVOut         in            [[ stage_in ]],
            texture2d<float> resultTexture [[ texture(0) ]]
        )
        {    
            const auto pixelPos = uint2( floor( in.position.xy ) );
            float4 color = resultTexture.read( pixelPos );
            
            color.xyz = pow( color.xyz, float3( 2.2 ) );
            
            SRGBFOut out;
            out.backBuffer = color;
            
            return out;
        }
        """ }

        public let sRGBVertexShader:Lily.Metal.Shader
        public let sRGBFragmentShader:Lily.Metal.Shader
        
        public static func shared( device:MTLDevice ) -> SRGBShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:SRGBShaderString?
        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )
            
            self.sRGBVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.sRGBVertexShaderCode,
                shaderName:"Lily_Stage_Playground2D_SRGB_Vs" 
            )
            
            self.sRGBFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.sRGBFragmentShaderCode,
                shaderName:"Lily_Stage_Playground2D_SRGB_Fs" 
            )
        }
    }
}
