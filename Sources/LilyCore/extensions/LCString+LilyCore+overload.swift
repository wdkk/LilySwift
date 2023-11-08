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

/// LCDataMake関数の型オーバーロード(Int64 -> Int)
public func LCStringMakeWithBytes( _ bin:LLUInt8Ptr, _ length:LLInt64 ) -> LCStringSmPtr {
    guard let leng = length.i else {
        LLLogWarning( "length(int64)をintに変換できませんでした." )
        return LCStringZero()
    }
    return LCStringMakeWithBytes( bin, leng )
}
