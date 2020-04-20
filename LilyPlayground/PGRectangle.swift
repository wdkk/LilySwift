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

public class PGRectangle : PGShape
{
    static let deco = LBPanelDecoration.rectangle()
    
    @discardableResult
    public init() {
        super.init( decoration:PGRectangle.deco )
        PGViewController.shared.shapes.insert( self )
    }
}
