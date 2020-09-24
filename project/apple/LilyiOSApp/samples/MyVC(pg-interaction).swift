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
    var sceneDelegate:SceneDelegate { return self.view.window!.windowScene!.delegate as! SceneDelegate }
    var vcm:LLViewControllerManager { return sceneDelegate.vcm }
    
    public var vc = PGViewController.shared
    
    override func setup() {
        super.setup()
        vc.designHandler = design
        vc.updateHandler = update
        vcm.transition(to: vc )
    }
}

func design() {
   clearColor = .darkGrey
}

func update() {
    for touch in touches {
        genSpark( touch: touch )
    }
}

func genSpark( touch:LBTouch ) {
    for _ in 0 ..< 8 {
        let speed = (2.0...4.0).randomize
        let rad  = (0.0...2.0 * Double.pi).randomize
        
        PGAddBlurryCircle()
        .color( LLColor( 0.4, 0.6, 0.95, 1.0 ) )
        .position( touch.xy )
        .deltaPosition( dx:speed * cos( rad ), dy: speed * sin( rad ) )
        .scale( width:(5.0...40.0).randomize, height:(5.0...40.0).randomize )
        .angle( .random )
        .deltaAngle( degrees: (-2.0...2.0).randomize )
        .life( 1.0 )
        .deltaLife( -0.016 )
        .alpha( 1.0 )
        .deltaAlpha( -0.016 )
    }
}
