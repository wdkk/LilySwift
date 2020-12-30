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

public extension LBTrianglePipeline
{
    // 三角形描画
    static func plane( label:String = UUID().labelString )
    -> LBTrianglePipeline {
        // オブジェクトパイプラインのリクエストラベルを作る
        let lbl = "lbtriangle_normal_\(label)"
        
        // 同一ラベルがある場合、再利用
        if Self.isExist( label:lbl ) { return Self.custom( label: lbl ) }
        
        // リクエストがなかった場合、各種設定を行なってオブジェクトパイプラインを生成する
        return LBTrianglePipeline.custom( label: lbl )
        .renderShader( 
            LBTrianglelRenderShader(
                vertexFuncName: "LBTriangle_vertPlane_\(label)",
                fragmentFuncName: "LBTriangle_fragPlane_\(label)" )
        )
    }
}
