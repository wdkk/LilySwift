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
#import "../../Shaders/Lily.Stage.MemoryLess.h.metal"

#import "../../Shared/Lily.Stage.Shared.Const.metal"
#import "../../Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "../../Shaders/Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage::Shared;

struct ParticleVIn
{
    float4 pos;
    float2 texUV;
};

struct UnitStatus
{
    float4x4 matrix;
    float4 atlasUV;
    float4 color;
    float4 deltaColor;
    float2 position;
    float2 deltaPosition;
    float2 scale;
    float2 deltaScale;
    float angle;
    float deltaAngle;
    float zindex; 
    float array_index;
    float life;
    float deltaLife;
    float enabled;
    float state;    
};

struct ParticleVOut
{
    float4 position [[ position ]];
    float4 color;
};

struct ParticleResult 
{
    float4 backBuffer [[ color(0) ]];
};

vertex ParticleVOut Lily_Stage_Playground2DVs(
    const device ParticleVIn* in [[ buffer(0) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
    const device float4x4* modelMatrices [[ buffer(2) ]],
    const device UnitStatus* statuses [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    GlobalUniform uniform = uniformArray.uniforms[amp_id];
    float4x4 vpMatrix = uniform.cameraUniform.viewProjectionMatrix;
    float4x4 mvpMatrix = vpMatrix * modelMatrices[iid];
    UnitStatus status = statuses[vid];
        
    float4 pos1 = mvpMatrix * in[iid * 4 + 0].pos;
    float4 pos2 = mvpMatrix * in[iid * 4 + 1].pos;
    float4 pos3 = mvpMatrix * in[iid * 4 + 2].pos;
    float4 pos4 = mvpMatrix * in[iid * 4 + 3].pos;
    
    float4 center_pos = (pos1 + pos2 + pos3 + pos4) / 4.0;

    constexpr float3 square_vertices[] = { 
        float3( -0.5, -0.5 , 0.0 ),
        float3(  0.5, -0.5 , 0.0 ),
        float3( -0.5,  0.5 , 0.0 ),
        float3(  0.5,  0.5 , 0.0 )
    };
        
    float4 billboard_pos = float4(
        center_pos.x + square_vertices[vid].x * status.scale.x / uniform.aspect,
        center_pos.y + square_vertices[vid].y * status.scale.y,
        center_pos.z,
        center_pos.w
    );
    
    ParticleVOut out;
    out.position = billboard_pos;
    out.color = status.color;

    return out;
}

fragment ParticleResult Lily_Stage_Playground2DFs(
    const ParticleVOut in [[ stage_in ]]
)
{
    ParticleResult result;
    result.backBuffer = in.color;
    return result;
}

