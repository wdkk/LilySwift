//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

public extension LLChain where TObj:UIControl, TObj:LLUILifeEvent
{
    @discardableResult
    func isEnabled( _ torf:Bool ) -> Self { 
        obj.isEnabled = torf
        obj.isUserInteractionEnabled = torf
        obj.rebuild()
        return self
    }
    
    var isEnabled:Bool { obj.isEnabled }
}

#endif
