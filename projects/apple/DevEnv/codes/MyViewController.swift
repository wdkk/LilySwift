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
import UIKit

class MyViewController : LLViewController
{   
    lazy var red_view = LLView().chain
    .setup.add( with:self ) {
        $1.backgroundColor = .green
    }
    .buildup.add( with:self ) {
        $1.rect = LLRect( 20, 150, 140, 140 )
    }
    
    override func setup() {        
        super.setup()
        self.view.addSubview( red_view )
    }
}
