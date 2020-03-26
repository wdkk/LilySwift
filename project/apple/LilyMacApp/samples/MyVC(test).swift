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
    var particles = Set<LBParticle>()
    
    let img_lily = LLMetalTexture( named: "supportFiles/images/lena647x681.png" )
    let img_out = LLMetalTexture( named: "supportFiles/images/lena647x681.png" )
    
    lazy var deco_particle = LBParticleDecoration.plane()
        .layer(index: 4 )
        
    override func setupBoard() {
        // 背景色の設定
        self.clearColor = .white
    }
    
    // 設計関数
    override func designBoard() {
        for _ in 0 ..< 100 {
            let px = self.width.randomize
            let py = self.height.randomize
            
            // パーティクルの作成
            let p = LBParticle( decoration: deco_particle )
                .texture( img_out )
                .position( cx:px, cy:py )
                .scale( 200.randomize )
                .color( .random )
                .life( .random )
            particles.insert( p )
        }
    }

    // 繰り返し処理関数
    override func updateBoard() {
        for p in particles {
            p.life { $0.life - 0.0025 }
            .alpha { sin( $0.life * Float.pi ) }
            
            if p.life <= 0.0 {
                let px = self.width.randomize
                let py = self.height.randomize
                
                // パーティクルの作成
                p.position( cx:px, cy:py )
                .scale( 200.randomize )
                .color( .random )
                .alpha( 0.0 )
                .life( 1.0 )
            }
        }
    }
}
