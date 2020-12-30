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
    // 単品画像の描画
    static func texture( label:String = UUID().labelString )
    -> LBPanelPipeline 
    {
        // オブジェクトパイプラインのリクエストラベルを作る
        let lbl = "lbpanel_texture_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってオブジェクトパイプラインを生成する
        return LBPanelPipeline.custom( label: lbl )
        .renderShader( 
            LBPanelRenderShader( 
                vertexFuncName: "LBPanel_vertTexture_\(label)",
                fragmentFuncName: "LBPanel_fragTexture_\(label)" )
            .fragmentFunction {
                $0
                .addArgument( "texture2d<float>", "tex [[ texture(0) ]]" )
                .addArgument( "sampler", "sampler [[ sampler(0) ]]" )
                .code( """
                    if( is_null_texture( tex ) ) { discard_fragment(); }
                    float4 c = tex.sample( sampler, vout.tex_uv );
                    c[3] *= vout.color[3];
                    return c;
                """ )
            }
        )
        .renderFieldMySelf { caller, me, args in 
            if me.storage.isNoActive { return }
            
            let mtlbuf_params = LLMetalStandardBuffer( amemory:me.storage.params )
            
            let sampler = LLMetalSampler.default
            
            let encoder = args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.setFragmentSamplerState( sampler, index: 0 )
            encoder.setFragmentTexture( me.storage.texture, index: 0 )
            encoder.draw( shape:me.storage.metalVertex, index:2, painter: LLMetalQuadranglePainter<LBActorVertex>() )
        }
    }
}
