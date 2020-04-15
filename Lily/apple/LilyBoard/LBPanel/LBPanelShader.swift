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

open class LBPanelShader : LBShader
{       
    public convenience init() {
        let uid = UUID().labelString
        self.init( vertexFuncName: "LBPanelVertex_" + uid, fragmentFuncName: "LBPanelFragment_" + uid )
    }
    
    public override init( vertexFuncName: String, fragmentFuncName: String ) {
        super.init(vertexFuncName: vertexFuncName, fragmentFuncName: fragmentFuncName )
        
        // 入力頂点情報
        self.addStruct {
            $0
            .name( "LBPanelVertexIn" )
            .add( "float2", "xy" )
            .add( "float2", "uv" )
            .add( "float2", "tex_uv" )
        }
        
        // 出力頂点情報
        self.addStruct {
            $0
            .name( "LBPanelVertexOut" )
            .add( "float4", "pos [[position]]" )
            .add( "float2", "xy" )
            .add( "float2", "uv" )
            .add( "float2", "tex_uv" )
            .add( "float4", "color" )
        }
        
        self.addStruct {
            $0
            .name( "LBPanelParam" )
            .add( "float4x4", "matrix" )
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
        super.defaultFragmentFunction
        .prefix( "vertex" )
        .returnType( "LBPanelVertexOut" )
        .name( self.vert_name )
        .addArgument( "constant float4x4", "&proj_matrix [[ buffer(0) ]]" )
        .addArgument( "constant LBPanelParam", "*param [[ buffer(1) ]]" )
        .addArgument( "constant LBPanelVertexIn", "*vin [[ buffer(2) ]]" )
        .addArgument( "uint", "idx [[ vertex_id ]]" )
        .code( """
            // パネルのパラメータインデックス
            uint obj_idx = idx / 4;
            // p = パネルのパラメータ
            LBPanelParam p = param[obj_idx];
            
            float cosv = cos( p.angle );
            float sinv = sin( p.angle );
            float x = vin[idx].xy.x;
            float y = vin[idx].xy.y;
            float scx = p.scale.x * 0.5;
            float scy = p.scale.y * 0.5;

            // アフィン変換
            float2 v_coord = 0.0;
            v_coord.x = scx * cosv * x - sinv * scy * y + p.position.x;
            v_coord.y = scx * sinv * x + cosv * scy * y + p.position.y;

            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility = p.state * p.enabled * p.color[3] - 0.00001;

            LBPanelVertexOut vout;
            vout.pos = proj_matrix * float4( v_coord, visibility, 1 );
            vout.xy = vin[idx].xy;
            vout.tex_uv = vin[idx].tex_uv;
            vout.uv = vin[idx].uv;
            vout.color = p.color;

            return vout;
        """
        )
    }
    
    public override var defaultFragmentFunction: LLMetalShadingCode.Function {
        super.defaultFragmentFunction
        .addArgument( "LBPanelVertexOut", "vout [[ stage_in ]]" )
        .code( """
            return vout.color;
        """ )
    }
}
