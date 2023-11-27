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

vertex PG2DVOut Lily_Stage_Playground2D_Vs(
    const device PG2DVIn* in [[ buffer(0) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
    constant LocalUniform &localUniform [[ buffer(2) ]],
    const device UnitStatus* statuses [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    UnitStatus us = statuses[iid];
    
    if( us.compositeType != localUniform.shaderCompositeType ) { 
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
    vout.pos = localUniform.projectionMatrix * float4( v_coord, visibility_z, 1 );
    vout.xy = vin.xy;
    vout.texUV = tex_uv;
    vout.uv = vin.uv;
    vout.color = us.color;
    vout.shapeType = float( us.shapeType );

    return vout;
}

namespace Lily
{
    namespace Stage 
    {
        namespace Playground2D
        {
            float4 drawRectangle( PG2DVOut in ) {
                return in.color;
            }
            
            float4 drawCircle( PG2DVOut in ) {
                float x = in.xy.x;
                float y = in.xy.y;
                float r = x * x + y * y;
                if( r > 1.0 ) { discard_fragment(); }
                return in.color;
            } 
        }
    }
}

fragment PG2DResult Lily_Stage_Playground2D_Fs(
    const PG2DVOut in [[ stage_in ]]
)
{
    ShapeType type = ShapeType( in.shapeType );
    float4 color = float4( 0 );
    switch( type ) {
        case rectangle:
            color = Lily::Stage::Playground2D::drawRectangle( in );
            break;
        case triangle:
            break;
        case circle:
            color = Lily::Stage::Playground2D::drawCircle( in );
            break;
        case blurryCircle:
            break;
        case picture:
            break;
        case mask:
            break;
    }
    
    PG2DResult result;
    result.backBuffer = color;
    return result;
}


