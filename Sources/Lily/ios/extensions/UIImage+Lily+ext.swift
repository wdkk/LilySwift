//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

#if os(iOS)

import UIKit

public extension UIImage
{    
    var llImage:LLImage {
        let lcimg = UIImage2LCImage( self )
        return LLImage( lcimg )
    }
}

#endif
