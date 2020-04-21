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
    
    override func setupBoard() {
        super.setupBoard()
        vc.designBoardHandler = design
        vcm.transition(to: vc )
    }
    
    func design() {
        PGRectangle()
        .color( .blue )
        .scale( width:200, height:200 )
        .angle( degrees: 45.0 )
    }
}


