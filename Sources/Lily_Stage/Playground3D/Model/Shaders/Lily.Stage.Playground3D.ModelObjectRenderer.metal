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

#import "../../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"

#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"

#import "../../../Standard/Models/Lily.Stage.Model.Obj.metal"

#import "Lily.Stage.Playground3D.Model.util.metal"

using namespace metal;
using namespace Lily::Stage::Shared;
using namespace Lily::Stage::Model;
using namespace Lily::Stage::Playground3D;

//// マクロ定義 ////
#define TOO_FAR 999999.0

// vertexからfragmentへ渡す値
struct ModelVOut
{
    float4 position [[ position ]];
    float3 color;
    float3 normal;
};

struct ModelUnitStatus
{
    float4x4 matrix;
    float4   atlasUV;
    float4   color;
    float4   deltaColor;
    float3   position;
    float3   deltaPosition;
    float3   scale;
    float3   deltaScale;
    float3   angle;
    float3   deltaAngle;
    float    life;
    float    deltaLife;
    float    enabled;
    float    state;
    int      modelIndex;
};

vertex ModelVOut Lily_Stage_Playground3D_Model_Object_Vs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device ModelUnitStatus* statuses [[ buffer(1) ]],
    constant GlobalUniformArray & uniformArray [[ buffer(2) ]],
    constant int& modelIndex [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    auto uniform = uniformArray.uniforms[amp_id];
    int idx = iid * 4;  // カメラの数 + レンダラ = 4つ
    
    auto us = statuses[idx];
    
    // 一致しないインスタンスは破棄
    if( us.modelIndex != modelIndex ) { 
        ModelVOut trush_vout;
        trush_vout.position = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;
    }
    
    float4 base_pos = float4( in[vid].position, 1.0 );
    
    // アフィン変換の作成
    // TODO: 別関数にまとめる
    // TODO: シャドウの方にも入れる必要あり
    float3 pos = us.position;
    float3 ang = us.angle;
    float3 sc = us.scale;
    
    float4x4 T = float4x4( 
        float4( 1, 0, 0, 0 ),
        float4( 0, 1, 0, 0 ),
        float4( 0, 0, 1, 0 ),
        float4( pos, 1 )
    );
        
    float4x4 Rz = float4x4(
        float4( cos( ang.z ), -sin( ang.z ), 0, 0 ),
        float4( sin( ang.z ),  cos( ang.z ), 0, 0 ),
        float4( 0, 0, 1, 0 ),
        float4( 0, 0, 0, 1 )
    );
    
    float4x4 Ry = float4x4(
        float4( cos( ang.y ), 0, sin( ang.y ), 0 ),
        float4( 0, 1, 0, 0 ),
        float4( -sin( ang.y ), 0, cos( ang.y ), 0 ),
        float4( 0, 0, 0, 1 )
    );
    
    float4x4 Rx = float4x4(
        float4( 1, 0, 0, 0 ),
        float4( 0, cos( ang.x ), -sin( ang.x ), 0 ),
        float4( 0, sin( ang.x ),  cos( ang.x ), 0 ),
        float4( 0, 0, 0, 1 )
    );
    
    float4x4 R = Rz * Ry * Rx;
        
    float4x4 S = float4x4(
        float4( sc.x, 0, 0, 0 ),
        float4( 0, sc.y, 0, 0 ),
        float4( 0, 0, sc.z, 0 ),
        float4( 0, 0, 0, 1 )
    );
    
    float4x4 TRS = T * R * S;
    
    float4 world_pos = TRS * base_pos;
    
    ModelVOut out;
    out.position = uniform.cameraUniform.viewProjectionMatrix * world_pos;
    out.color = pow( in[vid].color, 1.0 / 2.2 );    // sRGB -> linear変換
    out.normal = (us.matrix * float4(in[vid].normal, 0)).xyz;

    return out;
}

// フラグメントシェーダ
fragment GBufferFOut Lily_Stage_Playground3D_Model_Object_Fs(
    const ModelVOut in [[ stage_in ]]
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

vertex ModelVOut Lily_Stage_Playground3D_Model_Object_Shadow_Vs(
    const device Obj::Vertex* in [[ buffer(0) ]],
    const device ModelUnitStatus* statuses [[ buffer(1) ]],
    const device uint& cascadeIndex [[ buffer(2) ]],
    constant int& modelIndex [[ buffer(3) ]],
    constant float4x4* shadowCameraVPMatrix[[ buffer(6) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    int idx = iid * 4 + cascadeIndex;
    
    auto us = statuses[idx];
    
    // 一致しないインスタンスは破棄
    if( us.modelIndex != modelIndex ) { 
        ModelVOut trush_vout;
        trush_vout.position = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;
    }
    
    float4 position = float4( in[vid].position, 1.0 );
    float4 world_pos = us.matrix * position;
   
    ModelVOut out;
    out.position = shadowCameraVPMatrix[amp_id] * world_pos;

    return out;
}