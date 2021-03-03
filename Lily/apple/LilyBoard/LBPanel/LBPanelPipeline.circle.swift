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
    // 円描画
    static func circle( label:String = UUID().labelString )
        -> LBPanelPipeline {
        // オブジェクトパイプラインのリクエストラベルを作る
        let lbl = "lbpanel_circle_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってオブジェクトパイプラインを生成する
        return LBPanelPipeline.custom( label: lbl )
        .renderShader( 
            LBPanelRenderShader( 
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