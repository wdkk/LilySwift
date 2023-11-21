//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#ifndef Lily_Stage_Shared_CameraUniform_h
#define Lily_Stage_Shared_CameraUniform_h

#import <simd/simd.h>

namespace Lily
{
    namespace Stage 
    {
        namespace Shared
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
            };
        };
    };
};

#endif 
