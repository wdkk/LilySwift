//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !LILY

import UIKit
import PlaygroundSupport

public func setupPG() -> PGViewController {
    let vc = PGViewController.shared
    PlaygroundPage.current.liveView = vc
    return vc
}

#endif
