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
        vcm.transition(to: vc )
    }
}

func design() {
    clearColor = .black
    
    PGAddCircle( index:0 )
    .scale( square:200 )
    .position( cx: 0, cy: 100 ) 
    .color( red:0.5, green:0.0, blue:0.0 )

    PGAddCircle( index:0 )
    .scale( square:200 )
    .position( cx: 0, cy: -100 ) 
    .color( red:0.5, green:0.0, blue:0.0 )

    PGAddCircle( index:0 )
    .scale( square:200 )
    .position( cx: 100, cy: 0 ) 
    .color( red:0.5, green:0.0, blue:0.0 )

    PGAddCircle( index:0 )
    .scale( square:200 )
    .position( cx: -100, cy: 0 ) 
    .color( red:0.5, green:0.0, blue:0.0 )

    PGAddRectangle( index:1 )
    .scale( square:200 )
    .color( red:0.0, green:0.0, blue:0.5 )
}
