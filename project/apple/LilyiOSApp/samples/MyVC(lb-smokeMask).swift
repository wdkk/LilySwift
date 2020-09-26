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
        
        for _ in 0 ..< 200 {
            // パネルを四角形デコレーションで作成
            let p = LBPanel( decoration: deco_rect )

            let px = (-150...150).randomize
            let py = (-150...150).randomize

            p
            .position( cx: px, cy: py )
            .angle( .random )
            .life( .random )
            .color( LLColor(R: 0.5, G: 0.5, B: 0.5, A: 1.0) )
            .texture( tex_smoke )
            
            // セットに追加
            panels.insert( p )
        }
    }

    // 繰り返し処理関数
    override func loop() {
        for p in panels {            
            p.life { $0.life - 0.01 }
            .width { 60.0 + (1.0 - $0.life) * 90.0 }
            .height { 60.0 + (1.0 - $0.life) * 90.0 }
            .alpha { sin( $0.life * Float.pi ) * 0.75 }
            
            if p.life <= 0.0 {
                let px = (-150...150).randomize
                let py = (-150...150).randomize
                
                p.position( cx: px, cy: py )
                .scale( .zero )
                .angle( .random )
                .life( 1.0 )
            }
        }
    }
}
