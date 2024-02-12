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

#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"
#import "../../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"

using namespace metal;
using namespace Lily::Stage::Shared;

namespace Lily
{
    namespace Stage 
    {
        namespace Playground
        {
            constant int IDX_OUTPUT = 0;
            constant int IDX_GBUFFER_0 = 1;
            constant int IDX_GBUFFER_1 = 2;
            constant int IDX_GBUFFER_2 = 3;
            constant int IDX_GBUFFER_DEPTH = 4;
            constant int IDX_SHADOW_MAP = 5;
            constant int IDX_CUBE_MAP = 6;
            
            struct GBufferFOut 
            {
                float4 GBuffer0 [[ color(IDX_GBUFFER_0) ]];
                float4 GBuffer1 [[ color(IDX_GBUFFER_1) ]];
                float4 GBuffer2 [[ color(IDX_GBUFFER_2) ]];
                float  GBufferDepth [[ color(IDX_GBUFFER_DEPTH) ]];
            };
            
            struct BRDFSet 
            {
                float3 albedo;
                float3 normal;
                float specIntensity;
                float specPower;
                float ao;
                float shadow;
            };
            
            inline GBufferFOut BRDFToGBuffers( thread BRDFSet &brdf ) {
                GBufferFOut fout;
                
                fout.GBuffer0 = float4( brdf.albedo, 0.0 );
                fout.GBuffer1 = float4( brdf.normal, 0.0 );
                fout.GBuffer2 = float4( brdf.specIntensity, brdf.specPower, brdf.shadow, brdf.ao );
                
                return fout;
            };
            
            inline BRDFSet GBuffersToBRDF( float4 GBuffer0, float4 GBuffer1, float4 GBuffer2 ) {
                BRDFSet brdf;
                
                brdf.albedo = GBuffer0.xyz;
                brdf.normal = GBuffer1.xyz;
                brdf.specIntensity = GBuffer2.x;
                brdf.specPower = GBuffer2.y;
                brdf.shadow = GBuffer2.z;
                brdf.ao = GBuffer2.w;
                
                return brdf;
            };
        };
    };
};
