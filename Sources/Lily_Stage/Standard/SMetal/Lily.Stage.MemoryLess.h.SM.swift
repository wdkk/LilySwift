//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal
import simd

extension Lily.Stage
{   
    public static var MemoryLess_h_SMetal:String { """
        #ifndef Lily_Stage_MemoryLess_h
        #define Lily_Stage_MemoryLess_h
        
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        //#import "Lily.Stage.Macro.metal"
        \(Lily.Stage.Macro_SMetal)

        using namespace metal;

        namespace Lily
        {
            namespace Stage 
            {
                namespace MemoryLess
                {
                    #if LILY_MEMORY_LESS
                    float4 float4OfPos( uint2 pos, float4 mem );
                    float depthOfPos( uint2 pos, float mem );
                    #else
                    float4 float4OfPos( uint2 pos, texture2d<float> mem );
                    float depthOfPos( uint2 pos, depth2d<float> mem );
                    #endif
                };
            };
        };
        
        #endif
        """
    }
}

#endif
