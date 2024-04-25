//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import simd

extension Lily.Stage.Playground
{
    public struct ActorInterval<TField>
    {
        var sec:Double = 1.0
        var prev:Double = 0.0
        var field:TField
        
        public init(
            sec:Double,
            prev:Double, 
            field:TField
        ) 
        {
            self.sec = sec
            self.prev = prev
            self.field = field
        }
    }
}

#endif
