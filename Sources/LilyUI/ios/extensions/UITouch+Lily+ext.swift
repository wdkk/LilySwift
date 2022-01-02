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

public extension UITouch
{
    func locationPixel(in view:UIView?=nil) -> LLPoint {
        let pt:CGPoint = self.location(in: view)
        let scale = LLSystem.retinaScale
        return LLPoint( x:(pt.x.d * scale), y:(pt.y.d * scale) )
    }
}

#endif
