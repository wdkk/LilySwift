//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#import <metal_stdlib>
#import <TargetConditionals.h>
#import "Lily.Stage.MemoryLess.h.metal"

using namespace metal;

namespace Lily
{
    namespace Stage 
    {
        namespace MemoryLess
        {
            #if LILY_MEMORY_LESS
            float4 float4OfPos( uint2 pos, float4 mem ) { return mem; };
            float depthOfPos( uint2 pos, float mem ) { return mem; };
            #else
            float4 float4OfPos( uint2 pos, texture2d<float> mem ) { return mem.read( pos ); };
            float depthOfPos( uint2 pos, depth2d<float> mem ) { return mem.read( pos ); };
            #endif
        };
    };
};

