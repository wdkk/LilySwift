//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground.Model.Object
{
    public static var Vs_SMetal:String { """
    //#import "Lily.Stage.Playground.Model.Object.h"
    \(Lily.Stage.Playground.Model.Object.h_SMetal)
    
    vertex Model::Object::VOut Lily_Stage_Playground_Model_Object_Vs
    (
        const device Obj::Vertex* in [[ buffer(0) ]],
        const device Model::Object::UnitStatus* statuses [[ buffer(1) ]],
        constant GlobalUniformArray & uniformArray [[ buffer(2) ]],
        constant int& modelIndex [[ buffer(3) ]],
        ushort amp_id [[ amplification_id ]],
        uint vid [[ vertex_id ]],
        uint iid [[ instance_id ]]
    )
    {
        auto uniform = uniformArray.uniforms[amp_id];
        
        int idx = iid;
        
        auto us = statuses[idx];
        
        // 一致しないインスタンスは破棄
        if( us.modelIndex != modelIndex ) { 
            Model::Object::VOut trush_vout;
            trush_vout.position = float4( 0, 0, Model::TOO_FAR, 0 );
            return trush_vout;
        }
        
        float4 base_pos = float4( in[vid].position, 1.0 );
        
        // アフィン変換の作成
        float3 pos = us.position;
        float3 ro = us.rotation;
        float3 sc = us.scale;
        
        float4x4 TRS = affineTransform( pos, sc, ro );
        
        float4 world_pos = TRS * base_pos;
        
        // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
        float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : Model::TOO_FAR;
        
        Model::Object::VOut out;
        out.position = uniform.cameraUniform.viewProjectionMatrix * world_pos;
        out.position.z += visibility_z;
        out.color    = pow( in[vid].color, 1.0 / 2.2 );    // sRGB -> linear変換
        out.normal   = (TRS * float4(in[vid].normal, 0)).xyz;
        return out;
    }

    """
    }
}
