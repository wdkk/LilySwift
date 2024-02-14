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

#import "../../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"

#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"
#import "../../../Standard/Shaders/Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Shared;

//// マクロ定義 ////
#define TOO_FAR 999999.0

//// 列挙子 ////
enum CompositeType : uint
{
    none  = 0,
    alpha = 1,
    add   = 2,
    sub   = 3
};
    
enum ShapeType : uint
{
    rectangle    = 0,
    triangle     = 1,
    circle       = 2,
    blurryCircle = 3,
    picture      = 100,
    mask         = 101
};
    
enum DrawingType : uint
{
    quadrangles = 0,
    triangles   = 1
};        

//// 構造体 ////
    
struct BBVIn
{
    float4 xyzw;
    float2 uv;
    float2 texUV;
};

struct BBUnitStatus
{
    float4x4 matrix;
    float4 atlasUV;
    float4 color;
    float4 deltaColor;
    float3 position;
    float3 deltaPosition;
    float2 scale;
    float2 deltaScale;
    float angle;
    float deltaAngle;
    float life;
    float deltaLife;
    float enabled;
    float state;
    CompositeType compositeType;
    ShapeType shapeType;
};
    
struct BBLocalUniform
{
    CompositeType shaderCompositeType;
    DrawingType   drawingType;
    int           drawingOffset;
};        

struct BBVOut
{
    float4 pos [[ position ]];
    float2 xy;
    float2 uv;
    float2 texUV;
    float4 color;
    float  shapeType;
};

struct BBResult 
{
    float4 billboardTexture [[ color(0) ]];
    float4 backBuffer [[ color(1) ]];
};

vertex BBVOut Lily_Stage_Playground_Billboard_Vs(
    const device BBVIn* in [[ buffer(0) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
    constant BBLocalUniform &localUniform [[ buffer(2) ]],
    const device BBUnitStatus* statuses [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    BBUnitStatus us = statuses[iid];
    
    if( us.compositeType != localUniform.shaderCompositeType ) { 
        BBVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;
    }

    // 三角形が指定されているが, 描画が三角形でない場合
    if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
        BBVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;    
    }
    
    // 三角形以外が指定されているが、描画が三角形である場合
    if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
        BBVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;    
    }
    
    const int offset = localUniform.drawingOffset;
        
    GlobalUniform uniform = uniformArray.uniforms[amp_id];
    
    BBVIn vin = in[offset + vid];
        
    float4x4 modelMatrix = float4x4(
        float4( 1, 0, 0, 0 ),
        float4( 0, 1, 0, 0 ),
        float4( 0, 0, 1, 0 ),
        float4( us.position, 1 )
    );
    
    float4x4 vpMatrix = uniform.cameraUniform.viewProjectionMatrix;
    float4x4 mvpMatrix = vpMatrix * modelMatrix;
    
    float4 pos1 = mvpMatrix * in[offset + 0].xyzw;
    float4 pos2 = mvpMatrix * in[offset + 1].xyzw;
    float4 pos3 = mvpMatrix * in[offset + 2].xyzw;
    float4 pos4 = mvpMatrix * in[offset + 3].xyzw;
    
    float4 center_pos = (pos1 + pos2 + pos3 + pos4) / 4.0;

    constexpr float2 square_vertices[] = { 
        float2( -1.0, -1.0 ),
        float2(  1.0, -1.0 ),
        float2( -1.0,  1.0 ),
        float2(  1.0,  1.0 )
    };
    
    constexpr float2 triangle_vertices[] = { 
        float2(  0.0,  1.15470053838 ),
        float2( -1.0, -0.57735026919 ),
        float2(  1.0, -0.57735026919 ),
        float2(  0.0,  0.0 )
    };
    
    float4 atlas_uv = us.atlasUV;

    float2 min_uv = atlas_uv.xy;
    float2 max_uv = atlas_uv.zw;

    float u = vin.texUV.x;
    float v = vin.texUV.y;
    
    float cosv = cos( us.angle );
    float sinv = sin( us.angle );
    float scx = us.scale.x * 0.5;
    float scy = us.scale.y * 0.5;

    float2 tex_uv = float2( 
        min_uv[0] * (1.0-u) + max_uv[0] * u,
        min_uv[1] * (1.0-v) + max_uv[1] * v
    );

    // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
    float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
        
    // ビルボード内ローカル座標
    float2 loc_pos = us.shapeType == ShapeType::triangle ? triangle_vertices[vid] : square_vertices[vid];
    
    float4 billboard_pos = float4(
        center_pos.x + (scx * cosv * loc_pos.x - sinv * scy * loc_pos.y) / uniform.aspect,
        center_pos.y + (scx * sinv * loc_pos.x + cosv * scy * loc_pos.y),
        center_pos.z + visibility_z,
        center_pos.w
    );

    BBVOut vout;
    vout.pos = billboard_pos;
    vout.xy = vin.xyzw.xy;
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
        namespace Playground
        {
            float4 drawPlane( BBVOut in ) {
                return in.color;
            }
            
            float4 drawCircle( BBVOut in ) {
                float x = in.xy.x;
                float y = in.xy.y;
                float r = x * x + y * y;
                if( r > 1.0 ) { discard_fragment(); }
                return in.color;
            } 
            
            float4 drawBlurryCircle( BBVOut in ) {
                float x = in.xy.x;
                float y = in.xy.y;
                float r = sqrt( x * x + y * y );
                if( r > 1.0 ) { discard_fragment(); }
                
                float4 c = in.color;
                c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                return c;
            } 
            
            float4 drawPicture( BBVOut in, texture2d<float> tex ) {
                constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                
                if( is_null_texture( tex ) ) { discard_fragment(); }
                
                float4 tex_c = tex.sample( sampler, in.texUV );
                float4 c = in.color;
                tex_c[3] *= c[3];
                return tex_c;
            } 
            
            float4 drawMask( BBVOut in, texture2d<float> tex ) {
                constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                
                if( is_null_texture( tex ) ) { discard_fragment(); }
                
                float4 tex_c = tex.sample( sampler, in.texUV );
                float4 c = in.color;
                c[3] *= tex_c[0];
                return c;
            } 
        }
    }
}

fragment BBResult Lily_Stage_Playground_Billboard_Fs(
    const BBVOut in [[ stage_in ]],
    texture2d<float> tex [[ texture(1) ]]
)
{
    ShapeType type = ShapeType( in.shapeType );
    float4 color = float4( 0 );
    switch( type ) {
        case rectangle:
            color = Lily::Stage::Playground::drawPlane( in );
            break;
        case triangle:
            color = Lily::Stage::Playground::drawPlane( in );
            break;
        case circle:
            color = Lily::Stage::Playground::drawCircle( in );
            break;
        case blurryCircle:
            color = Lily::Stage::Playground::drawBlurryCircle( in );
            break;
        case picture:
            color = Lily::Stage::Playground::drawPicture( in, tex );
            break;
        case mask:
            color = Lily::Stage::Playground::drawMask( in, tex );
            break;
    }
    
    BBResult result;
    result.billboardTexture = color;
    result.backBuffer = color;
    return result;
}
