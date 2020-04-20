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
    var panels = Set<LBPanel>()

    lazy var deco_circle = LBPanelDecoration.circle()
                
    override func setupBoard() {
        // 背景色の設定
        self.clearColor = .lightGrey
    }
    
    // 設計関数
    override func designBoard() {
    
    }

    // 繰り返し処理関数
    override func updateBoard() {
        for touch in self.touches {
            let p = LBPanel( decoration: deco_circle )
                .position( touch.xy )
                .scale( width:2.0, height:2.0 )
                .color( .random )
                .life( 1.0 )
            panels.insert( p )
        }
        
        for p in panels {            
            p.life { $0.life - 0.005 }
            .width { 20.0 + (1.0 - $0.life) * 120.0 }
            .height { 20.0 + (1.0 - $0.life) * 120.0 }
            .alpha { sin( $0.life * Float.pi ) }
            
            if p.life <= 0.0 {
                panels.remove( p )
            }
        }
    }
}
