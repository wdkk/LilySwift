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

/// UIScrollViewチェインアクセサ : メソッド
public extension LLChain where TObj:UIScrollView
{
    @discardableResult
    func setContentOffset( _ pt:CGPoint, animated:Bool ) 
    -> Self
    {
        obj.setContentOffset( pt, animated:animated )
        return self
    }
}

#endif
