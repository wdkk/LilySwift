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

#import "../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "../../Standard/Shaders/Lily.Stage.StageRenderer.util.metal"

#import "Lily.Stage.Playground2D.h.metal"

using namespace metal;
using namespace Lily::Stage::Shared;


vertex PG2DVOut Lily_Stage_Playground2D_SubBlend_Vs(
    const device PG2DVIn* in [[ buffer(0) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
    constant float4x4 &projMatrix [[ buffer(2) ]],
    const device UnitStatus* statuses [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    UnitStatus us = statuses[iid];
    
    if( us.compositeType != CompositeType::sub ) { 
        PG2DVOut trush_vout;
        trush_vout.pos = float4( 0, 0, -1000000, 0 );
        return trush_vout;
    }
    
    GlobalUniform uniform = uniformArray.uniforms[amp_id];
    PG2DVIn vin = in[vid];
    
    float cosv = cos( us.angle );
    float sinv = sin( us.angle );
    float x = vin.xy.x;
    float y = vin.xy.y;
    float scx = us.scale.x * 0.5;
    float scy = us.scale.y * 0.5;

    float4 atlas_uv = us.atlasUV;

    float min_u = atlas_uv[0];
    float min_v = atlas_uv[1];
    float max_u = atlas_uv[2];
    float max_v = atlas_uv[3];

    float u = vin.texUV[0];
    float iu = 1.0 - u;
    float v = vin.texUV[1];
    float iv = 1.0 - v;

    float2 tex_uv = float2( 
        min_u * iu + max_u * u,
        min_v * iv + max_v * v
    );

    // アフィン変換
    float2 v_coord = float2(
        scx * cosv * x - sinv * scy * y + us.position.x,
        scx * sinv * x + cosv * scy * y + us.position.y 
    );

    // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
    float visibility_z = us.state * us.enabled * us.color[3] - 0.00001;
    
    PG2DVOut vout;
    vout.pos = projMatrix * float4( v_coord, visibility_z, 1 );
    vout.xy = vin.xy;
    vout.texUV = tex_uv;
    vout.uv = vin.uv;
    vout.color = us.color;

    return vout;
}

fragment PG2DResult Lily_Stage_Playground2D_SubBlend_Fs(
    const PG2DVOut in [[ stage_in ]]
)
{
    PG2DResult result;
    result.backBuffer = in.color;
    return result;
}

