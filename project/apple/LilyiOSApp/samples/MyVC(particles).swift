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
    var particles = Set<LBParticle>()
    
    let tex_lily = LLMetalTexture( named: "supportFiles/images/Lily.png" )

    lazy var deco_particle_tex = LBParticleDecoration.texture()
 
    override func setupBoard() {
        // 背景色の設定
        self.clearColor = .white
    }
    
    // 設計関数
    override func designBoard() {
        particles.removeAll()
                
        for _ in 0 ..< 100 {
            let p = LBParticle( decoration: deco_particle_tex )
            particles.insert( p )
        }

        // パネルの位置や色を設定
        for p in particles {
            let px = (coordMinX...coordMaxX).randomize
            let py = (coordMinY...coordMaxY).randomize
            let size = 20.0 + ( 40.0 ).randomize

            p
            .position( cx: px, cy: py )
            .scale( size )
            .life( .random )
            .texture( tex_lily )
        }
    }

    // 繰り返し処理関数
    override func updateBoard() {
        
        for p in particles {            
            p.life { $0.life - 0.005 }
            .alpha { sin( $0.life * Float.pi ) * 0.75 }
            
            if p.life <= 0.0 {
                let px = (coordMinX...coordMaxX).randomize
                let py = (coordMinY...coordMaxY).randomize
                
                p.position( cx: px, cy: py )
                .scale( 20.0 + 140.0.randomize )
                .life( 1.0 )
                .texture( tex_lily )
            }
        }
    }
}
