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

public extension LBParticleDecoration
{
    // 点描画
    static func plane( label:String = UUID().labelString )
    -> LBParticleDecoration {
        // デコレーションのリクエストラベルを作る
        let lbl = "lbparticle_normal_\(label)"
        
        // すでに同ラベルのpictureデコレーションがある場合はこれを用いる
        if LBParticleDecoration.isExist( label: lbl ) {
            return .custom( label: lbl )
        }
        
        // リクエストがなかった場合、各種設定を行なってデコレーションを生成する
        return LBParticleDecoration.custom( label: lbl )
        .shader( 
            LBParticleShader(
                vertexFuncName: "LBParticle_vertPlane_\(label)",
                fragmentFuncName: "LBParticle_fragPlane_\(label)" )
        )
    }
}
