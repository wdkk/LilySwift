//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import UIKit

public class PGCircle : PGShape
{
    static let deco = LBPanelDecoration.circle()
    
    @discardableResult
    public init() {
        super.init( decoration:PGCircle.deco )
        PGViewController.shared.shapes.insert( self )
    }
}
