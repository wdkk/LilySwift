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
import Lily

class MyViewController : LBViewController
{   
    // パネルを格納するセット
    var triangles = Set<LBTriangle>()
    
    // 三角形のプレーンデコレーションの用意
    lazy var deco_tri = LBTriangleDecoration.plane()
     
    // 初期化準備関数
    override func setupBoard() {
        // 背景色の設定
        self.clearColor = .lightGrey
    }
    
    // 設計関数
    override func designBoard() {
        // 三角形をデコレーションで作成
        let t = LBTriangle( decoration: deco_tri )
            .color( .red )
        // パネルセットに追加
        triangles.insert( t )
    }

    // 繰り返し処理関数
    override func updateBoard() {
    
    }
}
