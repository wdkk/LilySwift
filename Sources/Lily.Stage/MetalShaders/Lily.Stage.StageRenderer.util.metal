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
#import "./Lily.Stage.MemoryLess.h.metal"

#import "../Shared/Lily.Stage.Shared.GlobalUniform.metal"

using namespace metal;
using namespace Lily::Stage::Shared;

// G-BufferのFragmentの出力構造体
struct GBufferFOut 
{
    float4 GBuffer0 [[ color(0) ]];
    float4 GBuffer1 [[ color(1) ]];
    float4 GBuffer2 [[ color(2) ]];
    float  GBufferDepth [[ color(3) ]];
};

// BRDF: Bidirectional Reflectance Distribution Function (双方向反射率分布関数)
// 不透明な表面で光がどのように反射するかを定義
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
