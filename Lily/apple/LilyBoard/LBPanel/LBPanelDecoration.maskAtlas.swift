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

public extension LBPanelDecoration
{
    // アトラスマスクパネルの描画
    static func maskAtlas( label:String = UUID().labelString )
    -> LBPanelDecoration 
    {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_maskatlas_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .renderShader( 
            LBPanelRenderShader( 
                vertexFuncName: "LBPanel_vertMaskTex_\(label)",
                fragmentFuncName: "LBPanel_fragMaskTex_\(label)" )
            .fragmentFunction {
                $0
                .addArgument( "texture2d<float>", "tex [[ texture(0) ]]" )
                .addArgument( "sampler", "sampler [[ sampler(0) ]]" )
                .code( """
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    float4 tex_c = tex.sample( sampler, vout.tex_uv );
                    
                    float4 c = vout.color;
                    c[3] *= tex_c[0];
                    return c;
                """ )
            }
        )
        .renderFieldMySelf { obj in 
            if obj.me.storage.isNoActive { return }
    
            let mtlbuf_params = LLMetalSharedBuffer( amemory:obj.me.storage.params )
           
            let sampler = LLMetalSampler.default
            
            let encoder = obj.args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.setFragmentSamplerState( sampler, index: 0 )
            encoder.setFragmentTexture( obj.me.storage.atlas?.metalTexture, index: 0 )
            encoder.draw( shape:obj.me.storage.metalVertex, index:2, painter: LLMetalQuadranglePainter<LBActorVertex>() )
        }
    }
}
