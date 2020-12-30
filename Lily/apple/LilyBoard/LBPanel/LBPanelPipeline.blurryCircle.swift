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
        -> LBPanelPipeline {
        // オブジェクトパイプラインのリクエストラベルを作る
        let lbl = "lbpanel_blurry_circle_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってオブジェクトパイプラインを生成する
        return LBPanelPipeline.custom( label: lbl )
        .renderShader( 
            LBPanelRenderShader( 
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
                    c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                    return c;
                """ )
            }
        )
    }
}
