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

public extension LBPanelDecoration
{
    // 矩形描画
    static func rectangle( label:String = UUID().labelString )
    -> LBPanelDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbpanel_rectangle_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBPanelDecoration.custom( label: lbl )
        .renderShader( 
            LBPanelRenderShader(
                vertexFuncName: "LBPanel_vertRectangle_\(label)",
                fragmentFuncName: "LBPanel_fragRectangle_\(label)" )
        )
    }
}
