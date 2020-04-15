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

open class LBParticleShader : LBShader
{       
    public convenience init() {
        let uid = UUID().labelString
        self.init( vertexFuncName: "LBParticleVertex_" + uid, fragmentFuncName: "LBParticleFragment_" + uid )
    }
    
    public override init( vertexFuncName: String, fragmentFuncName: String ) {
        super.init(vertexFuncName: vertexFuncName, fragmentFuncName: fragmentFuncName )
        
        // 入力頂点情報
        self.addStruct {
            $0
            .name( "LBParticleVertexIn" )
            .add( "float2", "xy" )
            .add( "float2", "tex_uv" )
        }
        
        // 出力頂点情報
        self.addStruct {
            $0
            .name( "LBParticleVertexOut" )
            .add( "float4", "pos [[position]]" )
            .add( "float", "size [[point_size]]" )
            .add( "float2", "xy" )
            .add( "float2", "tex_uv" )
            .add( "float4", "color" )
        }
        
        self.addStruct {
            $0
            .name( "LBParticleParam" )
            .add( "float4x4", "matrix" )
            .add( "float4", "color" )
            .add( "float4", "deltaColor" )
            .add( "float2", "position" )
            .add( "float2", "deltaPosition" )
            .add( "float", "scale" )
            .add( "float", "deltaScale" )
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
        super.defaultFragmentFunction
        .prefix( "vertex" )
        .returnType( "LBParticleVertexOut" )
        .name( self.vert_name )
        .addArgument( "constant float4x4", "&proj_matrix [[ buffer(0) ]]" )
        .addArgument( "constant LBParticleParam", "*param [[ buffer(1) ]]" )
        .addArgument( "constant LBParticleVertexIn", "*vin [[ buffer(2) ]]" )
        .addArgument( "uint", "idx [[ instance_id ]]" )
        .code( """
            // パネルのパラメータインデックス
            uint obj_idx = idx;
            // p = パネルのパラメータ
            LBParticleParam p = param[obj_idx];
            
            float x = vin[idx].xy.x;
            float y = vin[idx].xy.y;

            // アフィン変換
            float2 v_coord = 0.0;
            v_coord.x = x + p.position.x;
            v_coord.y = y + p.position.y;

            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility = 0;
            if( p.state * p.enabled * p.color[3] <= 0.00001 ) { visibility = -0.1; }

            LBParticleVertexOut vout;
            vout.pos = proj_matrix * float4( v_coord, visibility, 1 );
            vout.size = min( 64.0, p.scale );
            vout.xy = vin[idx].xy;
            vout.tex_uv = vin[idx].tex_uv;
            vout.color = p.color;

            return vout;
        """
        )
    }
    
    public override var defaultFragmentFunction: LLMetalShadingCode.Function {
        super.defaultFragmentFunction
        .addArgument( "LBParticleVertexOut", "vout [[ stage_in ]]" )
        .addArgument( "float2", "p_coord [[ point_coord ]]" )
        .code( """
            return vout.color;
        """ )
    }
}
