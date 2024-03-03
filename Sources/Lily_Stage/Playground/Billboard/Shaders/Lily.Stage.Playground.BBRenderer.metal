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
    empty        = 0,
    rectangle    = 1,
    triangle     = 2,
    circle       = 3,
    blurryCircle = 4,
    picture      = 101,
    mask         = 102
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
    float3 rotate;
    float3 deltaRotate;
    float life;
    float deltaLife;
    float enabled;
    float state;
    CompositeType compositeType;
    ShapeType shapeType;
    uint  childDepth;
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
     
    GlobalUniform uniform = uniformArray.uniforms[amp_id];
    CameraUniform camera = uniform.cameraUniform;
 
    const int offset = localUniform.drawingOffset;
    BBVIn vin = in[offset + vid];
    
    // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
    float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
    
    // ビルボードの回転
    float3 ro = us.rotate;
    // スケーリング
    float3 sc = float3( us.scale * 0.5, 1.0 );
    // 移動量
    float3 t  = us.position;
    
    // ビルボードのモデル行列
    float4x4 modelMatrix = affineTransform( t, sc, ro );
    // カメラのビュープロジェクション行列
    float4x4 vpMatrix = camera.viewProjectionMatrix;
    // プロジェクション行列
    float4x4 pMatrix = camera.projectionMatrix;
    
    // ビルボードを構成する板ポリゴンのローカル座標
    float4 coord = in[offset + vid].xyzw;
  
    
    //-----------//
    float4 worldPosition = modelMatrix * float4(0, 0, 0, 1);

    // カメラのビュー行列から上方向と右方向のベクトルを取得
    float3 right = normalize(camera.right);
    float3 up = normalize(camera.up);

    // ビルボードの前方向ベクトルを計算（カメラからビルボードへのベクトルとカメラの上方向ベクトルの外積）
    float3 backward = -normalize( camera.direction );

    // ビルボードのスケーリングを適用
    right *= sc.x;
    up *= sc.y;

    // ビルボードのモデル行列を構築（ビューポートに対して平行になるように）
    float4x4 bbModelMatrix = float4x4(
        float4(right, 0.0),
        float4(up, 0.0),
        float4(backward, 0.0),
        float4(worldPosition.xyz, 1.0)
    );

    // 最終的なビルボードの座標
    float4 billboard_pos = vpMatrix * bbModelMatrix * coord;
    //-----------//
    
    
    float2 local_uv = vin.texUV;
    float4 atlas_uv = us.atlasUV;
    float2 tex_uv = {
        atlas_uv[0] * (1.0-local_uv.x) + atlas_uv[2] * local_uv.x,
        atlas_uv[1] * (1.0-local_uv.y) + atlas_uv[3] * local_uv.y
    };

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
        default:
            discard_fragment();
    }
    
    BBResult result;
    result.billboardTexture = color;
    result.backBuffer = color;
    return result;
}
