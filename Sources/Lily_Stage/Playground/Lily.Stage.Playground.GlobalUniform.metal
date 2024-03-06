//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#ifndef Lily_Stage_Shared_GlobalUniform_h
#define Lily_Stage_Shared_GlobalUniform_h

#import <simd/simd.h>
#import "Lily.Stage.Playground.CameraUniform.metal"

namespace Lily
{
    namespace Stage 
    {
        namespace Playground
        {
            struct GlobalUniform
            {
                CameraUniform   cameraUniform;
                CameraUniform   shadowCameraUniforms[3];
                
                simd::float2    invScreenSize;
                float           aspect;
                
                simd::float3    sunDirection;
                float           projectionYScale;
                float           ambientOcclusionContrast;
                float           ambientOcclusionScale;
                float           ambientLightScale;
                
                float           frameTime;
            };
            
            // Vision用のGlobalUniform
            struct GlobalUniformArray
            {
                GlobalUniform uniforms[2];
            };
    
        };
    };
};

#endif
