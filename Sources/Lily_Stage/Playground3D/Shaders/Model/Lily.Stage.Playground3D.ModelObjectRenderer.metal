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

#import "../../../Standard/Models/Lily.Stage.Model.Obj.metal"

#import "Lily.Stage.Playground3D.Model.util.metal"

using namespace metal;
using namespace Lily::Stage::Shared;
using namespace Lily::Stage::Model;
using namespace Lily::Stage::Playground3D;

// vertexからfragmentへ渡す値
struct ObjectVOut
{
    float4 position [[ position ]];
    float3 color;
    float3 normal;
};

struct ModelUnitStatus
{
    float4x4 matrix;
    int      modelIndex;
    float    _reserved1;
    float    _reserved2;
    float    _reserved3;
    float    life;
    float    deltaLife;
    float    enabled;
    float    state;
};

vertex ObjectVOut Lily_Stage_Playground3D_Model_Object_Vs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device ModelUnitStatus* statuses [[ buffer(1) ]],
    constant GlobalUniformArray & uniformArray [[ buffer(2) ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]],
    constant float4x4& depthOnlyMatrix[[ buffer(6) ]]
)
{
    GlobalUniform uniform = uniformArray.uniforms[0];
  
    float4 position = float4( in[vid].position, 1.0 );
    int idx = iid * 4;  // カメラの数 + レンダラ = 4つ
    
    auto s = statuses[idx];
    
    float4 world_pos = s.matrix * position;
    
    ObjectVOut out;
    out.position = uniform.cameraUniform.viewProjectionMatrix * world_pos;
    out.color = pow( in[vid].color, 1.0 / 2.2 );    // sRGB -> linear変換
    out.normal = (s.matrix * float4(in[vid].normal, 0)).xyz;

    return out;
}

// フラグメントシェーダ
fragment GBufferFOut Lily_Stage_Playground3D_Model_Object_Fs(
    const ObjectVOut in [[ stage_in ]]
)
{
    BRDFSet brdf;
    brdf.albedo = saturate( in.color );
    brdf.normal = in.normal;
    brdf.specIntensity = 1.f;
    brdf.specPower = 1.f;
    brdf.ao = 0.f;
    brdf.shadow = 0.f;

    GBufferFOut output = BRDFToGBuffers( brdf );
    output.GBufferDepth = in.position.z;
    return output;
}

vertex ObjectVOut Lily_Stage_Playground3D_Model_Object_Shadow_Vs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device ModelUnitStatus* statuses [[ buffer(1) ]],
    const device uint* cascadeIndex [[ buffer(2) ]],
    constant float4x4& vpMatrix[[ buffer(3) ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    float4 position = float4( in[vid].position, 1.0 );
    int idx = iid * 4 + (*cascadeIndex);
    
    auto s = statuses[idx];
    float4 world_pos = s.matrix * position;
   
    ObjectVOut out;
    out.position = vpMatrix * world_pos;

    return out;
}
