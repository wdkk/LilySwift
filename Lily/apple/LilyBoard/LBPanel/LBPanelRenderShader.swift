//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LBPanelRenderShader : LBRenderShader
{       
    public convenience init() {
        let uid = UUID().labelString
        self.init( vertexFuncName: "LBActorVertex_" + uid, fragmentFuncName: "LBPanelFragment_" + uid )
    }
    
    public override init( vertexFuncName: String, fragmentFuncName: String ) {
        super.init(vertexFuncName: vertexFuncName, fragmentFuncName: fragmentFuncName )
        
        // 入力頂点情報
        self.addStruct {
            $0
            .name( "LBActorVertexIn" )
            .add( "float2", "xy" )
            .add( "float2", "uv" )
            .add( "float2", "tex_uv" )
        }
        
        // 出力頂点情報
        self.addStruct {
            $0
            .name( "LBActorVertexOut" )
            .add( "float4", "pos [[position]]" )
            .add( "float2", "xy" )
            .add( "float2", "uv" )
            .add( "float2", "tex_uv" )
            .add( "float4", "color" )
        }
        
        self.addStruct {
            $0
            .name( "LBActorParam" )
            .add( "float4x4", "matrix" )
            .add( "float4", "atlasUV" )
            .add( "float4", "color" )
            .add( "float4", "deltaColor" )
            .add( "float2", "position" )
            .add( "float2", "deltaPosition" )
            .add( "float2", "scale" )
            .add( "float2", "deltaScale" )
            .add( "float", "angle" )
            .add( "float", "deltaAngle" )
            .add( "float", "zindex" )  
            .add( "float", "array_index" )
            .add( "float", "life" )
            .add( "float", "deltaLife" )
            .add( "float", "enabled" )
            .add( "float", "state" )
        }
        
        self.vertexFunction { $0 }
        
        self.fragmentFunction { $0 }
    }
        
    public override var defaultVertexFunction: LLMetalShadingCode.Function {
        super.defaultVertexFunction
        .prefix( "vertex" )
        .returnType( "LBActorVertexOut" )
        .name( self.vert_name )
        .addArgument( "constant float4x4", "&proj_matrix [[ buffer(0) ]]" )
        .addArgument( "constant LBActorParam", "*param [[ buffer(1) ]]" )
        .addArgument( "constant LBActorVertexIn", "*vin_ptr [[ buffer(2) ]]" )
        .addArgument( "uint", "vid [[ vertex_id ]]" )
        .addArgument( "uint", "iid [[ instance_id ]]" )
        .code( """
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
        """
        )
    }
    
    public override var defaultFragmentFunction: LLMetalShadingCode.Function {
        super.defaultFragmentFunction
        .addArgument( "LBActorVertexOut", "vout [[ stage_in ]]" )
        .code( """
            return vout.color;
        """ )
    }
}
