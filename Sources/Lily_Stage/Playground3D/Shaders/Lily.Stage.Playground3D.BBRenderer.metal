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
#import "../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"

#import "../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "../../Standard/Shaders/Lily.Stage.StageRenderer.util.metal"

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
    
struct PG3DVIn
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
    float  _reserved;
    float3 deltaPosition;
    float  _reserved2;
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

struct PG3DVOut
{
    float4 pos [[ position ]];
    float2 xy;
    float2 uv;
    float2 texUV;
    float4 color;
    float  shapeType;
};

struct PG3DResult 
{
    float4 particleTexture [[ color(0) ]];
};

/*
struct SRGBVOut
{
    float4 position [[ position ]];
};
    
struct SRGBFOut
{
    float4 backBuffer [[ color(1) ]];
};
*/

vertex PG3DVOut Lily_Stage_Playground3D_Billboard_Vs(
    const device PG3DVIn* in [[ buffer(0) ]],
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
        PG3DVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;
    }

    // 三角形が指定されているが, 描画が三角形でない場合
    if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
        PG3DVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;    
    }
    
    // 三角形以外が指定されているが、描画が三角形である場合
    if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
        PG3DVOut trush_vout;
        trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
        return trush_vout;    
    }
    
    const int offset = localUniform.drawingOffset;
        
    GlobalUniform uniform = uniformArray.uniforms[amp_id];
    float4x4 vpMatrix = uniform.cameraUniform.viewProjectionMatrix;
    float4x4 mvpMatrix = vpMatrix;  // TODO: 今の所モデルマトリクスはない
    
    PG3DVIn vin = in[offset + vid];
    
    float cosv = cos( us.angle );
    float sinv = sin( us.angle );
    float x = vin.xyzw.x;
    float y = vin.xyzw.y;
    float scx = us.scale.x * 0.5;
    float scy = us.scale.y * 0.5;
    
    float4 pos1 = mvpMatrix * in[iid * 4 + 0].xyzw;
    float4 pos2 = mvpMatrix * in[iid * 4 + 1].xyzw;
    float4 pos3 = mvpMatrix * in[iid * 4 + 2].xyzw;
    float4 pos4 = mvpMatrix * in[iid * 4 + 3].xyzw;
    
    float4 center_pos = (pos1 + pos2 + pos3 + pos4) / 4.0;

    constexpr float3 square_vertices[] = { 
        float3( -1.0, -1.0, 0.0 ),
        float3(  1.0, -1.0, 0.0 ),
        float3( -1.0,  1.0, 0.0 ),
        float3(  1.0,  1.0, 0.0 )
    };
    
    float4 atlas_uv = us.atlasUV;

    float min_u = atlas_uv[0];
    float min_v = atlas_uv[1];
    float max_u = atlas_uv[2];
    float max_v = atlas_uv[3];

    float u = vin.texUV.x;
    float v = vin.texUV.y;

    float2 tex_uv = float2( 
        min_u * (1.0-u) + max_u * u,
        min_v * (1.0-v) + max_v * v
    );

    // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
    float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
        
    float xx = square_vertices[vid].x;
    float yy = square_vertices[vid].y;
    
    float4 billboard_pos = float4(
        center_pos.x + (scx * cosv * xx - sinv * scy * yy) / uniform.aspect,
        center_pos.y + (scx * sinv * xx + cosv * scy * yy),
        center_pos.z + visibility_z,
        center_pos.w
    );
    
    PG3DVOut vout;
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
        namespace Playground3D
        {
            float4 drawPlane( PG3DVOut in ) {
                return in.color;
            }
            
            float4 drawCircle( PG3DVOut in ) {
                float x = in.xy.x;
                float y = in.xy.y;
                float r = x * x + y * y;
                if( r > 1.0 ) { discard_fragment(); }
                return in.color;
            } 
            
            float4 drawBlurryCircle( PG3DVOut in ) {
                float x = in.xy.x;
                float y = in.xy.y;
                float r = sqrt( x * x + y * y );
                if( r > 1.0 ) { discard_fragment(); }
                
                float4 c = in.color;
                c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                return c;
            } 
            
            float4 drawPicture( PG3DVOut in, texture2d<float> tex ) {
                constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                
                if( is_null_texture( tex ) ) { discard_fragment(); }
                
                float4 tex_c = tex.sample( sampler, in.texUV );
                float4 c = in.color;
                tex_c[3] *= c[3];
                return tex_c;
            } 
            
            float4 drawMask( PG3DVOut in, texture2d<float> tex ) {
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

fragment PG3DResult Lily_Stage_Playground3D_Billboard_Fs(
    const PG3DVOut in [[ stage_in ]],
    texture2d<float> tex [[ texture(1) ]]
)
{
    ShapeType type = ShapeType( in.shapeType );
    float4 color = float4( 0 );
    switch( type ) {
        case rectangle:
            color = Lily::Stage::Playground3D::drawPlane( in );
            break;
        case triangle:
            color = Lily::Stage::Playground3D::drawPlane( in );
            break;
        case circle:
            color = Lily::Stage::Playground3D::drawCircle( in );
            break;
        case blurryCircle:
            color = Lily::Stage::Playground3D::drawBlurryCircle( in );
            break;
        case picture:
            color = Lily::Stage::Playground3D::drawPicture( in, tex );
            break;
        case mask:
            color = Lily::Stage::Playground3D::drawMask( in, tex );
            break;
    }
    
    PG3DResult result;
    result.particleTexture = color;
    return result;
}

/*
vertex SRGBVOut Lily_Stage_Playground3D_SRGB_Vs( uint vid [[vertex_id]] )
{
    const float2 vertices[] = {
        float2(-1, -1),
        float2( 3, -1),
        float2(-1,  3)
    };

    SRGBVOut out;
    out.position = float4( vertices[vid], 0.0, 1.0 );
    return out;
}

fragment SRGBFOut Lily_Stage_Playground3D_SRGB_Fs(
    SRGBVOut                 in               [[ stage_in ]],
    lily_memory_float4       particleTexture  [[ lily_memory(0) ]]
)
{    
    const auto pixelPos = uint2( floor( in.position.xy ) );

    float4 color = MemoryLess::float4OfPos( pixelPos, particleTexture );
    color.xyz = pow( color.xyz, float3( 2.2 ) );

    SRGBFOut out;
    out.backBuffer = color;
    
    return out;
}
*/
