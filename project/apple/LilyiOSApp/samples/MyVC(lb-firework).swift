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
    lazy var deco_rect = LBPanelDecoration.maskTex()
        .blendType( .add )
    
    let tex_smoke = LLMetalTexture( named: "supportFiles/images/smoke.png" )

    // 初期化準備関数
    override func setup() {
        // 背景色の設定
        self.clearColor = .darkGrey
    }
    
    // 画面更新時の構築処理
    override func buildup() {
        panels.removeAll()
                        
        // パネルを四角形デコレーションで作成
        for _ in 0 ..< 200 {
            let p = LBPanel( decoration: deco_rect )
            
            let px = (-50...50).randomize
            let py = (-20...20).randomize

            p
            .position( cx: px, cy: py )
            .angle( .random )
            .life( .random )
            .color( LLColor( 0.9, 0.4, 0.16, 1.0 ) )
            .deltaPosition( dx:-1.0 + 2.0.randomize, dy:0.5 + 3.0.randomize )
            .texture( tex_smoke )
            
            // セットに追加
            panels.insert( p )
        }
    }

    // 繰り返し処理関数
    override func loop() {
        for p in panels {            
            p.life { $0.life - 0.01 }
            .width { 60.0 + (1.0 - $0.life) * 40.0 }
            .height { 60.0 + (1.0 - $0.life) * 40.0 }
            .alpha { sin( $0.life * Float.pi ) * 0.5 }
            
            if p.life <= 0.0 {
                let px = (-50...50).randomize
                let py = (-20...20).randomize
                
                p.position( cx: px, cy: py )
                .scale( .zero )
                .angle( .random )
                .life( 1.0 )
                .deltaPosition( dx:-1.0 + 2.0.randomize, dy:0.5 + 3.0.randomize )
            }
        }
    }
}
