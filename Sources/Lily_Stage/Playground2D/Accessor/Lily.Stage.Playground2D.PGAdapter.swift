//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground2D
{   
    open class PGAdapter
    {   
        public static var current:PGAdapter? = nil

        public var storage:Storage?
        
        public init() {}
    }
}
