//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation

public extension String 
{
    func pixelSize( attr textAttr:LLTextAttribute ) -> LLSize { 
        return self.pixelSize( attr: textAttr.lcAttr )
   }   
}
