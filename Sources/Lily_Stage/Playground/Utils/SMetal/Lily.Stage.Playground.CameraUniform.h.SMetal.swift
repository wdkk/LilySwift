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

extension Lily.Stage.Playground
{   
    public static var CameraUniform_h_SMetal:String { """
        #ifndef Lily_Stage_Shared_CameraUniform_h
        #define Lily_Stage_Shared_CameraUniform_h
        
        #import <simd/simd.h>

        namespace Lily
        {
            namespace Stage 
            {
                namespace Playground
                {
                    struct CameraUniform
                    {
                        simd::float4x4 viewMatrix;
                        simd::float4x4 projectionMatrix;
                        simd::float4x4 viewProjectionMatrix;
                        simd::float4x4 invOrientationProjectionMatrix;
                        simd::float4x4 invViewProjectionMatrix;
                        simd::float4x4 invProjectionMatrix;
                        simd::float4x4 invViewMatrix;
                        simd::float4   frustumPlanes[6];
                        simd::float3   position;
                        simd::float3   up;
                        simd::float3   right;
                        simd::float3   direction;
                    };
             
                }
            };
        };
        
        #endif
        """
    }
}
