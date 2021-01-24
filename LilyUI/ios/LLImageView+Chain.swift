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

/// チェインアクセサ
public extension LLChain where TObj:LLImageView
{
    var image:Any? { obj.image }
    
    @discardableResult
    func image( _ img:Any? ) -> Self { 
        obj.image = img
        return self
    }
}

#endif
