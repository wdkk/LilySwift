//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LBActor<TDecoration:LBDecoration> : Hashable
{
    // Hashableの実装
    public static func == (lhs: LBActor<TDecoration>, rhs: LBActor<TDecoration>) -> Bool {
        lhs === rhs
    }
    // Hashableの実装
    public func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
    
    public weak var decoration:TDecoration?
    
    public init( decoration deco:TDecoration ) {
        decoration = deco
    }
}
