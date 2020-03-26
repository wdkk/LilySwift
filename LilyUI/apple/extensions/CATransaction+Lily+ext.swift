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
import QuartzCore

public extension CATransaction
{
    static func stop( _ f: ()->() ) {
        CATransaction.begin()
        CATransaction.setValue( kCFBooleanTrue, forKey: kCATransactionDisableActions )
        
        f()
        
        CATransaction.commit()
    }
}
