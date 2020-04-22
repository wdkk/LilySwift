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
    // 単品画像の描画
    static func texture( label:String = UUID().labelString )
    -> LBPanelDecoration 
    {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_texture_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBPanelDecoration.isExist( label:lbl ) {
            return LBPanelDecoration.custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .shader( 
            LBPanelShader( 
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
        .drawField { obj in 
            if obj.me.storage.params.count == 0 { return }
            
            // delta値の加算
            // TODO: コンピュートシェーダに写し変えたい
            obj.me.updateDeltaParams( &(obj.me.storage.params),
                                      &(obj.me.storage.steps),
                                      count:obj.me.storage.params.count )
    
            guard let mtlbuf_params = LLMetalManager.device?.makeBuffer(
                bytes: &obj.me.storage.params,
                length: MemoryLayout<LBPanelParam>.stride * obj.me.storage.params.count ) else { return }
            
            let sampler = LLMetalSampler.default
            
            let encoder = obj.args
            
            encoder.setVertexBuffer( mtlbuf_params, index:1 )
            encoder.setFragmentSamplerState( sampler, index: 0 )
            encoder.setFragmentTexture( obj.me.storage.texture, index: 0 )
            encoder.drawShape( obj.me.storage.quads, index:2 )
        }
    }
}