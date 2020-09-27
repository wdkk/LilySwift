//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !LILY_FULL

import UIKit
import PlaygroundSupport

public func setupPG() -> PGViewController {
    let vc = PGViewController.shared
    PlaygroundPage.current.liveView = vc
    return vc
}

public var clearColor:LLColor {
    get { PGViewController.shared.clearColor }
    set { PGViewController.shared.clearColor = newValue }
}

public var coordRegion:LLRegion { PGViewController.shared.coordRegion }
public var coordMinX:LLDouble { PGViewController.shared.coordMinX }
public var coordMinY:LLDouble { PGViewController.shared.coordMinY }
public var coordMaxX:LLDouble { PGViewController.shared.coordMaxX }
public var coordMaxY:LLDouble { PGViewController.shared.coordMaxY }

public var screenSize:LLSizeFloat { PGViewController.shared.screenSize }
public var screenWidth:LLDouble { PGViewController.shared.width }
public var screenHeight:LLDouble { PGViewController.shared.height }

public var touches:[LBTouch] { return PGViewController.shared.touches }
public var releases:[LBTouch] { return PGViewController.shared.releases }

public var shapes:Set<LBActor> { PGViewController.shared.shapes }

public var elapsedTime:Double { PGViewController.shared.elapsedTime }

#endif
