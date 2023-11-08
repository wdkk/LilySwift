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

/// 丸め誤差100億倍した値(小数点以下10位)をint64で返す
func roundDouble( _ num:Double ) -> Int64 {
    return Int64( ( num * 10000000000.0 ) )
}

/// 対象の値が誤差±内に収まっているかをboolで返す
extension Double {
    func withinRange( of value:Double, plus_or_minus:Double ) -> Bool {
        let minv = (value - plus_or_minus)
        let maxv = (value + plus_or_minus)
        return (minv <= self) && (self <= maxv) 
    }
}
