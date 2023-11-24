//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#ifndef Lily_Stage_Model_Obj_h
#define Lily_Stage_Model_Obj_h

#import <simd/simd.h>

namespace Lily
{
    namespace Stage 
    {
        namespace Model
        {
            namespace Obj
            {
                struct Vertex
                {
                    simd::float3 position;
                    simd::float3 normal;
                    simd::float3 color;
                };
            };
        };
    };
};
#endif 
