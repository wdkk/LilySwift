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
        .blendType( .add )
         
    // 初期化準備関数
    override func setup() {
        // 背景色の設定
        self.clearColor = .darkGrey
    }
    
    // 画面更新時の構築処理
    override func buildup() {
        panels.removeAll()
        
        for _ in 0 ..< 100 {
            // パネルを円デコレーションで作成
            let p = LBPanel( decoration: deco_rect )
            panels.insert( p )
        }
                
        // パネルを四角形デコレーションで作成
        for p in panels {
            let size = 40.0 + ( 120.0 ).randomize

            p
            .position( coordRegion.randomPoint )
            .scale( width:size, height:size )
            .angle( .random )
            .life( .random )
            .color( .random )
            
            // セットに追加
            panels.insert( p )
        }
    }

    // 繰り返し処理関数
    override func loop() {
        for p in panels {            
            p.life { $0.life - 0.005 }
            .width { 80.0 + (1.0 - $0.life) * 120.0 }
            .height { 80.0 + (1.0 - $0.life) * 120.0 }
            .angle { $0.angle + 0.005 * Double.pi }
            .alpha { sin( $0.life * Float.pi ) * 0.75 }
            
            if p.life <= 0.0 {
                p
                .position( coordRegion.randomPoint )
                .scale( .zero )
                .angle( .random )
                .life( 1.0 )
                .color( .random )
            }
        }
    }
}
