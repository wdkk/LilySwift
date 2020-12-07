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
    var sceneDelegate:SceneDelegate { return self.view.window!.windowScene!.delegate as! SceneDelegate }
    var vcm:LLViewControllerManager { return sceneDelegate.vcm }
    
    public var vc = PGViewController.shared
    
    override func setup() {
        super.setup()
        vc.buildupHandler = design
        //vc.loopHandler = update
        vcm.transition(to: vc )
    }
}

func design() {
    clearColor = .darkGrey
    
    for _ in 0 ..< 120 {
        PGAddMask( "supportFiles/images/smoke.png" )
        .color( LLColor( 0.9, 0.4, 0.16, 1.0 ) )
        .position( cx:(-50 ... 50).randomize, cy:(-120 ... -110).randomize )
        .deltaPosition( dx:(-1.0...1.0).randomize, dy:(0.5...4.5).randomize )
        .scale( square: 80.0 )
        .deltaScale( dw: 0.5, dh: 0.5 )
        .angle( .random )
        .deltaAngle( degrees:(-2.0...2.0).randomize )
        .alpha( .random )
        .deltaAlpha( -0.01 )
        .life( .random )
        .deltaLife( -0.01 )
        .iterate {
            $0.deltaAlpha { $0.deltaAlpha - 0.0001 }
        }
        .interval( sec: 0.5 ) {
            $0.color.G += 0.1
        }
        .interval( sec: 1.0 ) {
            $0.color.B += 0.1
        }
        .completion {
            $0
            .position( cx:(-50 ... 50).randomize, cy:(-120 ... -110).randomize )
            .scale( square: 80.0 )
            .alpha( 1.0 )
            .life( 1.0 )
        }
    }
}


