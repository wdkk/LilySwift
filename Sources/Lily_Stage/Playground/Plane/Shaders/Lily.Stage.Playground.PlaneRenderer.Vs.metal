//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//
  
#import "Lily.Stage.Playground.PlaneRenderer.h"

vertex PlaneVOut Lily_Stage_Playground_Plane_Vs
(
    const device PlaneVIn* in [[ buffer(0) ]],
    constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
    constant LocalUniform &localUniform [[ buffer(2) ]],
    const device PlaneUnitStatus* statuses [[ buffer(3) ]],
    ushort amp_id [[ amplification_id ]],
    uint vid [[ vertex_id ]],
    uint iid [[ instance_id ]]
)
{
    auto us = statuses[iid];
    
    if( us.compositeType != localUniform.shaderCompositeType ) { 
        PlaneVOut trush_vout;
        trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
        return trush_vout;
    }

    // 三角形が指定されているが, 描画が三角形でない場合
    if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
        PlaneVOut trush_vout;
        trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
        return trush_vout;    
    }
    
    // 三角形以外が指定されているが、描画が三角形である場合
    if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
        PlaneVOut trush_vout;
        trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
        return trush_vout;    
    }
        
    //GlobalUniform uniform = uniformArray.uniforms[amp_id];
    
    const int offset = localUniform.drawingOffset;
    PlaneVIn vin = in[offset + vid];
    
    float z = (Z_INDEX_MAX - us.zIndex) / Z_INDEX_MAX;
    float4 coord = float4( vin.xy, z, 1 );
    
    float2 local_uv = vin.texUV;
    float4 atlas_uv = us.atlasUV;
    float2 tex_uv = {
        atlas_uv[0] * (1.0-local_uv.x) + atlas_uv[2] * local_uv.x,
        atlas_uv[1] * (1.0-local_uv.y) + atlas_uv[3] * local_uv.y
    };

    PlaneVOut vout;
    vout.pos = localUniform.projectionMatrix * us.matrix * coord;
    vout.xy = vin.xy;
    vout.texUV = tex_uv;
    vout.uv = vin.uv;
    vout.color = us.color;
    vout.shapeType = float( us.shapeType );

    return vout;
}
