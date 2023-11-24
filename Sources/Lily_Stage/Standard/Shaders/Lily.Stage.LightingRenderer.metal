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

#import "../Shared/Lily.Stage.Shared.Const.metal"
#import "../Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Shared;

static float3 getWorldPositionAndViewDirectionFromDepth(
    uint2 pixelPos,
    float depth,
    GlobalUniform uniform,
    thread float3& outViewDirection
)
{
    float4 ndc;
    ndc.xy = ( float2( pixelPos ) + 0.5 ) * uniform.invScreenSize;
    ndc.xy = ndc.xy * 2 - 1;
    ndc.y *= -1;

    ndc.z = depth;
    ndc.w = 1.f;

    float4 worldPosition = uniform.cameraUniform.invViewProjectionMatrix * ndc;
    worldPosition.xyz /= worldPosition.w;

    ndc.z = 1.f;
    float4 viewDir = uniform.cameraUniform.invOrientationProjectionMatrix * ndc;
    viewDir /= viewDir.w;
    outViewDirection = viewDir.xyz;

    return worldPosition.xyz;
}

static float evaluateShadow(
    GlobalUniform            uniform,
    float3                   worldPosition,
    float                    eyeDepth,
    depth2d_array<float>     shadowMap
)
{
    constexpr sampler sam( min_filter::linear, mag_filter::linear, compare_func::less );

    float4 lightSpacePos;
    int c_idx = 0;
    float shadow = 1.0;
    
    // カスケードシャドウの計算
    for( c_idx = 0; c_idx < Const::shadowCascadesCount; c_idx++ ) {
        // ライトの位置
        lightSpacePos = uniform.shadowCameraUniforms[c_idx].viewProjectionMatrix * float4(worldPosition, 1);
        lightSpacePos /= lightSpacePos.w;
        // xyzについて全て条件がtrueの時trueになる(= all)
        if( all(lightSpacePos.xyz < 1.0) && all( lightSpacePos.xyz > float3( -1, -1, 0 ) ) ) {
            shadow = 0.0f;
            float lightSpaceDepth = lightSpacePos.z;
            float2 shadowUv = lightSpacePos.xy * float2(0.5, -0.5) + 0.5;
            // 3x3の平滑化
            for( int j = -1; j <= 1; ++j ) {
                for( int i = -1; i <= 1; ++i ) {
                    const float depthBias = -0.0001;   // 同じ平面上にあるものを少しずらすことで同じに扱わないようにする
                    float tap = shadowMap.sample_compare( sam, shadowUv, c_idx, lightSpaceDepth + depthBias, int2(i, j) );
                    shadow += tap;
                }
            }
            shadow /= 9;
            break;
        }
    }
        
    return shadow;
}

struct LightingVOut
{
    float4 position [[position]];
};

vertex LightingVOut Lily_Stage_LightingVs( uint vid [[vertex_id]] )
{
    const float2 vertices[] = {
        float2(-1, -1),
        float2( 3, -1),
        float2(-1,  3)
    };

    LightingVOut out;
    out.position = float4( vertices[vid], 1.0, 1.0 );
    return out;
}

struct LightingFOut
{
    float4 backBuffer [[ color(4) ]];
};

fragment LightingFOut Lily_Stage_LightingFs(
    LightingVOut             in        [[ stage_in ]],
    lily_memory_float4       GBuffer0Mem [[ lily_memory(0) ]],
    lily_memory_float4       GBuffer1Mem [[ lily_memory(1) ]],
    lily_memory_float4       GBuffer2Mem [[ lily_memory(2) ]],
    lily_memory_depth        depthMem    [[ lily_memory(3) ]],
    depth2d_array <float>    shadowMap [[ texture(5) ]],
    texturecube <float>      cubeMap   [[ texture(6) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(0) ]]
)
{    
    const GlobalUniform uniform = uniformArray.uniforms[0];
    
    constexpr sampler colorSampler( mip_filter::linear, mag_filter::linear, min_filter::linear );

    const auto pixelPos = uint2( floor( in.position.xy ) );
    
    const float depth = MemoryLess::depthOfPos( pixelPos, depthMem );

    float3 viewDirection;
    const float3 worldPosition = getWorldPositionAndViewDirectionFromDepth( pixelPos, depth, uniform, viewDirection );
    
    // デプス = 1の時はキューブマップから値をとって適用
    if( depth == 1 ) {
        float3 cubeMapColor = cubeMap.sample( colorSampler, viewDirection, level(0) ).xyz;
        LightingFOut res;
        res.backBuffer = float4( cubeMapColor, 1 );
        return res;
    }
    
    const float4 GBuffer0 = MemoryLess::float4OfPos( pixelPos, GBuffer0Mem );
    const float4 GBuffer1 = MemoryLess::float4OfPos( pixelPos, GBuffer1Mem );
    const float4 GBuffer2 = MemoryLess::float4OfPos( pixelPos, GBuffer2Mem );

    BRDFSet brdf = GBuffersToBRDF( GBuffer0, GBuffer1, GBuffer2 );
    
    // 影の量
    const float shadowAmount = evaluateShadow( uniform, worldPosition, depth, shadowMap );
    // 太陽の入射方向
    const float3 sunDirection = uniform.sunDirection;

    float3 color;
    
    // 現在のフラグメントが受ける照明の量. 法線と影の有無に依存する
    const float nDotL = saturate( dot( sunDirection, brdf.normal ) ) * shadowAmount * 1.2;
        
    // 環境カラーについては、キューブマップをサンプリング。ただ放射照度マップを使用する方法もある (霞や散乱で、高度0ではテクスチャが白くなるため)
    const float3 ambientDirectionUp = float3( 0, 1, 0 );
    const float3 ambientDirectionHoriz = normalize( float3( -sunDirection.x, 0.1, -sunDirection.z ) );
    const float3 ambientDirection = normalize( mix( ambientDirectionHoriz, ambientDirectionUp, brdf.normal.y ) );
    const float3 ambientColorBase = saturate( cubeMap.sample( colorSampler, ambientDirection, level(0)).xyz * 1.5 + 0.1 );
    const float3 ambientColor = ambientColorBase * max( 0.05, brdf.normal.y );
    color = brdf.albedo * ( ambientColor + float3( nDotL ) );

    // かすみの量. atmospherics blendの追加. 恣意的な値なので適宜調整
    const float haze_near = 0.6;
    const float haze_far = 1.0;
    const float invFarByNear = 1.0 / ( haze_far - haze_near );
    const float approxlinDepth = saturate( ( depth - haze_near ) * invFarByNear );
    float hazeAmount = pow( approxlinDepth, 10 ) * 0.3;
    // かすみの色
    const float3 hazeColor = saturate( cubeMap.sample( colorSampler, float3( 0, 1, 0 ) ).xyz * 3.0 + 0.1 );
    
    // colorとhazeColorの線形補間値(hazeAmountでのアルファブレンド)
    color = mix( color, hazeColor, float3( hazeAmount ) );

    LightingFOut res;
    res.backBuffer = float4( color, 1 );
    return res;
}
