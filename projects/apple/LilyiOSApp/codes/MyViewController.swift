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
import LilySwift

class MyViewController : LBViewController
{   
    // パネルを格納するセット
    var panels = Set<LBPanel>()
    
    // 四角形デコレーションの用意
    lazy var deco_rect = LBPanelDecoration.rectangle()
     
    // 初期化準備関数
    override func setup() {
        // 背景色の設定
        clearColor = .lightGrey
    }
    
    // 画面更新時の構築処理
    override func buildup() {
        // パネルを四角デコレーションで作成
        let p = LBPanel( decoration: deco_rect )
            .color( .blue )
        // パネルセットに追加
        panels.insert( p )
    }

    // 繰り返し処理関数
    override func loop() {
    
    }
}
