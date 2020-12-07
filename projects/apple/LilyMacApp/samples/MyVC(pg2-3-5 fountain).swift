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

class MyViewController : LLViewController
{   
    var app:Application { Application.shared as! Application }
    public var vc = PGViewController.shared
    
    override func buildup() {
        super.buildup()
        vc.vcview.rect = app.wc!.window!.contentBounds.llRect
        vc.buildupHandler = design
        vc.loopHandler = update
        app.wc?.contentViewController = vc
    }
}

func design() {
    clearColor = .darkGrey
    
    for _ in 0 ..< 4000 {
        PGAddBlurryCircle()
        .color( LLColor( 0.16, 0.3, 0.5, 0.8 ) )
        .position( 
            cx:(-10...10).randomize,
            cy:coordMinY - 48.0.randomize
        ) 
        .deltaPosition( 
            dx:(-2.0...2.0).randomize,
            dy:(19.0...20.0).randomize
        )
        .scale( square: 48.0 )
        .life( .random )
        .deltaLife( -0.008 )
        .iterate {
            $0.deltaPosition.y -= 0.35
        }
        .completion {
            $0
            .position(
                cx:(-10...10).randomize,
                cy:coordMinY - 48.0.randomize
            )
            .deltaPosition(
                dx:(-2.0...2.0).randomize,
                dy:(19.0...20.0).randomize 
            )
            .life( 1.0 )
        }
    }
}


func update() {
    LLClock.fps()
}
