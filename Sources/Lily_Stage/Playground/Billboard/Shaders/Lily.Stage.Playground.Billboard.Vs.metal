//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#import "Lily.Stage.Playground.Billboard.h"

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
    
    // スケーリング
    float3 sc = us.scale;
    float ang = us.comboAngle * M_PI_F / 180.0;
    // ビルボード回転書く
    float  cosv = cos( ang );
    float  sinv = sin( ang );
    
    // ビルボードのモデル行列
    float4x4 modelMatrix = us.matrix;
    float4x4 vpMatrix = camera.viewProjectionMatrix;
    float4x4 vMatrix = camera.viewMatrix;
    
    // ビルボードを構成する板ポリゴンのローカル座標
    float4 coord = in[offset + vid].xyzw;
    
    //-----------//
    // ビルボード中央座標のワールド座標
    float4 worldPosition = modelMatrix * float4(0, 0, 0, 1);
    // カメラup = ビルボードupで、そのワールド座標
    float3 worldUp = float3( vMatrix[0][1], vMatrix[1][1], vMatrix[2][1] );
    
    // カメラの視線方向を正面方向とする
    float3 forward = normalize( -camera.direction );
    float3 up = normalize( worldUp );
    float3 right = cross( up, forward );

    // ビルボードのスケーリングを適用
    right *= sc.x;
    up *= sc.y;

    // ビルボードのモデル行列を再構築
    float4x4 bbModelMatrix = {
        float4(right, 0.0),
        float4(up, 0.0),
        float4(forward, 0.0),
        float4(worldPosition.xyz, 1.0)
    };
    
    float4x4 angModelMatrix = {
        float4( cosv,-sinv, 0, 0 ),
        float4( sinv, cosv, 0, 0 ),
        float4(    0,    0, 1, 0 ),
        float4(    0,    0, 0, 1 )
    };
    
    // 最終的なビルボードの座標
    float4 billboard_pos = vpMatrix * bbModelMatrix * angModelMatrix * coord;
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
