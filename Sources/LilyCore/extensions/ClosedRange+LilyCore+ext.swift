//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public extension ClosedRange where Bound:BinaryInteger
{
    var randomize:Bound {
        Bound( LLRandomi( Int32(self.upperBound - self.lowerBound) ) + Int32(self.lowerBound) )
    }
}

public extension ClosedRange where Bound:BinaryFloatingPoint
{
    var randomize:Bound {
        Bound( LLRandomd( Double(self.upperBound - self.lowerBound) ) + Double(self.lowerBound) )
    }
}
