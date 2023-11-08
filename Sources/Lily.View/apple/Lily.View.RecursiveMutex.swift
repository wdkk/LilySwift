//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

// コメント未着手

import Foundation

extension Lily.View
{
    open class RecursiveMutex
    {
        private var _count:Int = 0
        private(set) var locking:Bool = false
        
        public init() { }
        
        open func lock( _ f:@escaping ()->() ) {
            _count += 1
            if _count == 1 && !locking {
                locking = true
                f()
            }
            _count -= 1
            if _count == 0 { locking = false }
        }
    }
}
