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

public var vc = PGViewController.shared

class MyViewController : LBViewController
{   
    var sceneDelegate:SceneDelegate { return self.view.window!.windowScene!.delegate as! SceneDelegate }
    var vcm:LLViewControllerManager { return sceneDelegate.vcm }
    
    override func setupBoard() {
        super.setupBoard()
        vc.designBoardHandler = design
        vc.updateBoardHandler = update
        vcm.transition(to: vc )
    }
}

func design() {
   // 背景の色
   clearColor = .darkGrey

   for _ in 0 ..< 100 {
       let a = (0.0...3.0).randomize
       
       if a < 1.0 {
           PGAddCircle()
           .color( .random )
           .scale( square:(20...100).randomize )
           .position( coordRegion.randomPoint )
           .angle( .random )
           .alpha( .random )
       }
       else if a < 2.0 {
           PGAddTriangle()
           .color( .random )
           .scale( square:(20...100).randomize )
           .position( coordRegion.randomPoint )
           .angle( .random )
           .alpha( .random )
       }
       else {
           PGAddRectangle()
           .color( .random )
           .scale( square:(20...100).randomize )
           .position( coordRegion.randomPoint )   
           .angle( .random )
           .alpha( .random )
       }
   }
}

func update() {
    for s in shapes {
        s.angle( s.angle + 0.01 )
    }
}
