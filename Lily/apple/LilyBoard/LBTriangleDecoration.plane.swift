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

public extension LBTriangleDecoration
{
    // 三角形描画
    static func plane( label:String = UUID().labelString )
    -> LBTriangleDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbtriangle_normal_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBTriangleDecoration.isExist( label: lbl ) {
            return .custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBTriangleDecoration.custom( label: lbl )
        .shader( 
            LBTriangleShader(
                vertexFuncName: "LBTriangle_vertPlane_\(label)",
                fragmentFuncName: "LBTriangle_fragPlane_\(label)" )
        )
    }
}
