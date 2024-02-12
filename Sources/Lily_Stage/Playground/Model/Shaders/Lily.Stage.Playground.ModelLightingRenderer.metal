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

#import "../../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"

#import "Lily.Stage.Playground.Model.util.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Shared;
using namespace Lily::Stage::Playground;

static float3 getWorldPositionAndViewDirectionFromDepth
(
    uint2 pixelPos,
    float depth,
    GlobalUniform uniform,
    thread float3& outViewDirection
)
{
    float4 ndc;
    ndc.xy = ( float2( pixelPos ) + 0.5) * uniform.invScreenSize;
    ndc.xy = ndc.xy * 2 - 1;
    ndc.y *= -1;

    ndc.z = depth;
    ndc.w = 1;

    float4 worldPosition = uniform.cameraUniform.invViewProjectionMatrix * ndc;
    worldPosition.xyz /= worldPosition.w;

    ndc.z = 1.f;
    float4 viewDir = uniform.cameraUniform.invOrientationProjectionMatrix * ndc;
    viewDir /= viewDir.w;
    outViewDirection = viewDir.xyz;

    return worldPosition.xyz;
}

static float evaluateShadow
(
    GlobalUniform            uniform,
    float3                   worldPosition,
    float                    eyeDepth,
    depth2d_array<float>     shadowMap
)
{
    constexpr sampler sam (min_filter::linear, mag_filter::linear, compare_func::less);

    float4 lightSpacePos;
    int     cascadeIndex = 0;
    float   shadow = 1.0;
    for (cascadeIndex = 0; cascadeIndex < 3; cascadeIndex++)
    {
        lightSpacePos = uniform.shadowCameraUniforms[cascadeIndex].viewProjectionMatrix * float4(worldPosition, 1);
        lightSpacePos /= lightSpacePos.w;
        if( all( lightSpacePos.xyz < 1.0 ) && all( lightSpacePos.xyz > float3(-1,-1,0) ) ) {
            shadow = 0.0f;
            float lightSpaceDepth = lightSpacePos.z;
            float2 shadowUv = lightSpacePos.xy * float2(0.5, -0.5) + 0.5;
      
            for (int j = -1; j <= 1; ++j) {
                for (int i = -1; i <= 1; ++i) {
                    const float depthBias = -0.005; //-0.0001;  // 板ポリの影を消すバイアス
                    float tap = shadowMap.sample_compare(sam, shadowUv, cascadeIndex, lightSpaceDepth + depthBias, int2(i, j));
                    shadow += tap;
                }
            }
            shadow /= 9;
            break;
        }
    }

    /*
    // Cloud shadows
    const float time = 2.2;
    constexpr sampler psamp(min_filter::linear, mag_filter::linear, address::repeat);

    float l0 = smoothstep(0.5, 0.7, perlinMap.sample(psamp, fract(worldPosition.xz/7000.f)-time*0.008, level(0)).x);

    float l1 = smoothstep(0.05, 0.8, perlinMap.sample(psamp, fract(worldPosition.xz/2500.f)-float2(time, time*0.5)*0.03, level(0)).y)*0.2+0.8;

    float l2 = perlinMap.sample(psamp, fract(worldPosition.xz/1000.f)-float2(time*0.5, time)*0.1, level(0)).z *0.15+0.75;

    float cloud = saturate(l0*l1*l2)*0.75;
    cloud = 1.0-cloud;

    shadow = min(shadow, cloud);
    */
    
    return shadow;
}

struct LightingVOut
{
    float4 position [[position]];
};

vertex LightingVOut Lily_Stage_Playground_Model_Lighting_Vs( uint vid [[vertex_id]] )
{
    const float2 vertices[] = {
        float2(-1, -1),
        //float2(-1,  3),
        //float2( 3, -1)
        float2( 3, -1),
        float2(-1,  3)
    };

    LightingVOut out;
    out.position = float4( vertices[vid], 1.0, 1.0 );
    return out;
}

struct LightingFOut
{
    float4 backBuffer [[ color(IDX_OUTPUT) ]];
};

fragment LightingFOut Lily_Stage_Playground_Model_Lighting_Fs
(
    LightingVOut             in          [[ stage_in ]],
    lily_memory_float4       GBuffer0Mem [[ lily_memory(IDX_GBUFFER_0) ]],
    lily_memory_float4       GBuffer1Mem [[ lily_memory(IDX_GBUFFER_1) ]],
    lily_memory_float4       GBuffer2Mem [[ lily_memory(IDX_GBUFFER_2) ]],
    lily_memory_depth        depthMem    [[ lily_memory(IDX_GBUFFER_DEPTH) ]],
    depth2d_array <float>    shadowMap   [[ texture(IDX_SHADOW_MAP) ]],
    texturecube <float>      cubeMap     [[ texture(IDX_CUBE_MAP) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
    ushort amp_id [[ amplification_id ]]
)
{    
    constexpr sampler colorSampler( mip_filter::linear, mag_filter::linear, min_filter::linear );

    const GlobalUniform uniform = uniformArray.uniforms[amp_id];
    
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
    const float3 sunDirection = -uniform.sunDirection;

    const float nDotL = saturate(dot(sunDirection, brdf.normal)) * shadowAmount * 1.2;

    const float3 ambientDirectionUp = float3(0,1,0);
    const float3 ambientDirectionHoriz = normalize(float3(-sunDirection.x, 0.1, -sunDirection.z));
    const float3 ambientDirection = normalize(mix(ambientDirectionHoriz, ambientDirectionUp, brdf.normal.y));
    const float3 ambientColorBase = saturate(cubeMap.sample(colorSampler, ambientDirection, level(0)).xyz * 1.5 + 0.1);
    const float3 ambientColor = ambientColorBase * max(0.05, brdf.normal.y);

    float3 color = brdf.albedo * (ambientColor + float3(nDotL));

    float hazeAmount;
    {
        const float near = 0.992;
        const float far = 1.0;
        const float invFarByNear = 1.0 / (far-near);
        const float approxlinDepth = saturate((depth-near) * invFarByNear);
        hazeAmount = pow(approxlinDepth,10)*0.3;
    }
    const float3 hazeColor = saturate(cubeMap.sample(colorSampler, float3(0,1,0)).xyz * 3.0 + 0.1);
    color = mix(color, hazeColor, float3(hazeAmount));

    LightingFOut res;
    res.backBuffer = float4( color, 1 );
    return res;
}
