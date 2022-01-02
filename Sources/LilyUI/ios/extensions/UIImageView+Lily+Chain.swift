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

/// UILabelチェインアクセサ
public extension LLChain where TObj:UIImageView
{
    var image:UIImage? { obj.image }
 
    @discardableResult
    func image( _ img:UIImage? ) -> Self { 
        obj.image = img
        return self
    }
    
    @discardableResult
    func image( _ llimg:LLImage? ) -> Self {
        guard let uiimg = llimg?.uiImage else {
            obj.image = nil 
            return self
        }
        obj.image = uiimg
        return self
    }    
}

#endif
