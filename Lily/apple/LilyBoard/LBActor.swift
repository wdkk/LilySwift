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
    public let uuid = UUID().hashValue
    // Hashableの実装
    public static func == (lhs: LBActor<TDecoration>, rhs: LBActor<TDecoration>) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    // Hashableの実装
    public func hash(into hasher: inout Hasher) {
        hasher.combine( uuid )
    }
    
    public weak var decoration:TDecoration?
    
    public init( decoration deco:TDecoration ) {
        decoration = deco
    }
}
