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

import LilySwift

class MyViewController : LBViewController
{   
    // パネルを格納するセット
    var panels = Set<LBPanel>()
    
    // 四角形デコレーションの用意
    lazy var deco_rect = LBPanelDecoration.rectangle()
    
    // 画面が更新された時の構築処理
    override func buildupBoard() {
        super.buildupBoard()
        
        // Metalの背景色の設定
        self.clearColor = .lightGrey
        
        // すでにあるパネルセットを消す
        panels.removeAll()
        
        // パネルを四角で作成
        let p = LBPanel( decoration: deco_rect )
        .color( .blue )
            
        // パネルセットに追加
        panels.insert( p )
    }
}
