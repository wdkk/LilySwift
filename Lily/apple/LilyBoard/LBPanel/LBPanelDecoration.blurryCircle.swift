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
    // ぼやけた円描画
    static func blurryCircle( label:String = UUID().labelString )
        -> LBPanelDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_blurry_circle_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBPanelDecoration.isExist( label: lbl ) {
            return .custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .shader( 
            LBPanelShader( 
                vertexFuncName: "LBPanel_vertBlurryCircle_\(label)",
                fragmentFuncName: "LBPanel_fragBlurryCircle_\(label)" )
            .fragmentFunction {
                $0
                .code( """
                    float x = vout.xy.x;
                    float y = vout.xy.y;
                    float r = sqrt( x * x + y * y );
                    if( r > 1.0 ) { discard_fragment(); }
                    
                    float4 c = vout.color;
                    c[3] = c[3] * (1.0 + cos( r * M_PI_F )) * 0.5;

                    return c;
                """ )
            }
        )
    }
}