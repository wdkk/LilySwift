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
#import "../Models/Lily.Stage.Model.Obj.metal"
#import "Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage::Shared;
using namespace Lily::Stage::Model;

// vertexからfragmentへ渡す値
struct ObjectVOut
{
    float4 position [[ position ]];
    float3 color;
    float3 normal;
};

vertex ObjectVOut objectVs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device float4x4* instances [[ buffer(1) ]],
    constant GlobalUniformArray & uniformArray [[ buffer(2) ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]],
    constant float4x4& depthOnlyMatrix[[ buffer(6) ]]
)
{
    GlobalUniform uniform = uniformArray.uniforms[0];
  
    float4 position = float4( in[vid].position, 1.0 );
    int idx = iid * 4;  // カメラの数 + レンダラ = 4つ
    float4 world_pos = instances[idx] * position;
    
    ObjectVOut out;
    out.position = uniform.cameraUniform.viewProjectionMatrix * world_pos;
    out.color = in[vid].color;
    out.normal = (instances[idx] * float4(in[vid].normal, 0)).xyz;

    return out;
}

// フラグメントシェーダ
fragment GBufferFOut objectFs(
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

vertex ObjectVOut objectShadowVs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device float4x4* modelMatrices [[ buffer(1) ]],
    const device uint* cascadeIndex [[ buffer(2) ]],
    constant float4x4& vpMatrix[[ buffer(3) ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    float4 position = float4( in[vid].position, 1.0 );
    int idx = iid * 4 + (*cascadeIndex);
    float4 world_pos = modelMatrices[idx] * position;
   
    ObjectVOut out;
    out.position = vpMatrix * world_pos;

    return out;
}
