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
    // 矩形描画
    static func rectangle( label:String = UUID().labelString )
    -> LBPanelDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_rectangle_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBPanelDecoration.isExist( label: lbl ) {
            return .custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .shader( 
            LBPanelShader(
                vertexFuncName: "LBPanel_vertRectangle_\(label)",
                fragmentFuncName: "LBPanel_fragRectangle_\(label)" )
        )
    }
}
