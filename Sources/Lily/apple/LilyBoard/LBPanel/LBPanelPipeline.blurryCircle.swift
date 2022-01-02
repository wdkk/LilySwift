//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public extension LBPanelPipeline
{
    // ぼやけた円描画
    static func blurryCircle( label:String = UUID().labelString )
    -> LBPanelPipeline
    {
        // オブジェクトパイプラインのリクエストラベルを作る
        let lbl = "lbpanel_blurry_circle_\(label)"
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        let str_struct = """
            #include <metal_stdlib>
            using namespace metal;
            
            // 入力頂点情報
            struct LBActorVertexIn {
                float2 xy;
                float2 uv;
                float2 tex_uv;
            };

            // 出力頂点情報
            struct LBActorVertexOut {
                float4 pos [[position]];
                float2 xy;
                float2 uv;
                float2 tex_uv;
                float4 color;
            };
            
            struct LBActorParam {
                float4x4 matrix;
                float4 atlasUV;
                float4 color;
                float4 deltaColor;
                float2 position;
                float2 deltaPosition;
                float2 scale;
                float2 deltaScale;
                float angle;
                float deltaAngle;
                float zindex; 
                float array_index;
                float life;
                float deltaLife;
                float enabled;
                float state;    
            };
        """   
        
        // リクエストがなかった場合、各種設定を行なってオブジェクトパイプラインを生成する
        return LBPanelPipeline
        .custom( label: lbl )
        .vertexShader(
            LLMetalShader(
            code: str_struct +                
            """
            vertex
            LBActorVertexOut 
            LBPanelVertexBlurryCircle_\(label)(
                constant float4x4 &proj_matrix [[ buffer(0) ]],
                constant LBActorParam *param [[ buffer(1) ]],
                constant LBActorVertexIn *vin_ptr [[ buffer(2) ]],
                uint vid [[ vertex_id ]],
                uint iid [[ instance_id ]]
            )
            {
                LBActorVertexIn vin = vin_ptr[vid];
                // p = パネルのパラメータ
                LBActorParam p = param[iid];

                float cosv = cos( p.angle );
                float sinv = sin( p.angle );
                float x = vin.xy.x;
                float y = vin.xy.y;
                float scx = p.scale.x * 0.5;
                float scy = p.scale.y * 0.5;

                float4 atlas_uv = p.atlasUV;

                float min_u = atlas_uv[0];
                float min_v = atlas_uv[1];
                float max_u = atlas_uv[2];
                float max_v = atlas_uv[3];

                float u = vin.tex_uv[0];
                float iu = 1.0 - u;
                float v = vin.tex_uv[1];
                float iv = 1.0 - v;

                float2 tex_uv = float2( min_u * iu + max_u * u, 
                                        min_v * iv + max_v * v );

                // アフィン変換
                float2 v_coord = 0.0;
                v_coord.x = scx * cosv * x - sinv * scy * y + p.position.x;
                v_coord.y = scx * sinv * x + cosv * scy * y + p.position.y;

                // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
                float visibility = p.state * p.enabled * p.color[3] - 0.00001;

                LBActorVertexOut vout;
                vout.pos = proj_matrix * float4( v_coord, visibility, 1 );
                vout.xy = vin.xy;
                vout.tex_uv = tex_uv;
                vout.uv = vin.uv;
                vout.color = p.color;

                return vout;
            };
            """,
            shaderName:"LBPanelVertexBlurryCircle_\(label)" )
        )
        .fragmentShader(
            LLMetalShader( 
            code: str_struct +
            """
            fragment
            float4
            LBPanelFragmentBlurryCircle_\(label)(
                LBActorVertexOut vout [[ stage_in ]]
            )
            {
                float x = vout.xy.x;
                float y = vout.xy.y;
                float r = sqrt( x * x + y * y );
                if( r > 1.0 ) { discard_fragment(); }
                
                float4 c = vout.color;
                c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                return c;
            };            
            """,
            shaderName:"LBPanelFragmentBlurryCircle_\(label)" )
        )
    }
}
