//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import LilySwift

func setupPG() -> PGViewController {
    let vc = PGViewController.shared
    return vc
}

var clearColor:LLColor {
    get { PGViewController.shared.clearColor }
    set { PGViewController.shared.clearColor = newValue }
}

var coordRegion:LLRegion { PGViewController.shared.coordRegion }
var coordMinX:LLDouble { PGViewController.shared.coordMinX }
var coordMinY:LLDouble { PGViewController.shared.coordMinY }
var coordMaxX:LLDouble { PGViewController.shared.coordMaxX }
var coordMaxY:LLDouble { PGViewController.shared.coordMaxY }

var screenSize:LLSizeFloat { PGViewController.shared.screenSize }
var screenWidth:LLDouble { PGViewController.shared.width }
var screenHeight:LLDouble { PGViewController.shared.height }

var touches:[LBTouch] { return PGViewController.shared.touches }
var releases:[LBTouch] { return PGViewController.shared.releases }

var shapes:Set<LBActor> { PGViewController.shared.shapes }

var elapsedTime:Double { PGViewController.shared.elapsedTime }
