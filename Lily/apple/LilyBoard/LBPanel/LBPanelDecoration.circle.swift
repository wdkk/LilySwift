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
    // 円描画
    static func circle( label:String = UUID().labelString )
        -> LBPanelDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_circle_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBPanelDecoration.isExist( label: lbl ) {
            return .custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .shader( 
            LBPanelShader( 
                vertexFuncName: "LBPanel_vertCircle_\(label)",
                fragmentFuncName: "LBPanel_fragCircle_\(label)" )
            .fragmentFunction {
                $0
                .code( """
                    float x = vout.xy.x;
                    float y = vout.xy.y;
                    float r = x * x + y * y;
                    if( r > 1.0 ) { discard_fragment(); }
                    return vout.color;
                """ )
            }
        )
    }
}
