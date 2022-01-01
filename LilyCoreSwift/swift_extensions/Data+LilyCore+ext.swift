//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// Data型拡張
public extension Data
{
    /// LCDataSmPtrを用いた実体化
    /// - Parameter lcdata: データ
    init( _ lcdata:LCDataSmPtr ) {
        self.init()
        guard let ptr = LCDataPointer( lcdata ) else { return }
        guard let length = LCDataLength( lcdata ).i else { return }
        self.append( ptr, count: length )
    }
    /// LCDataSmPtrへの変換(別メモリとして確保して返す)
    var lcdata:LCDataSmPtr {
        let lcd = LCDataMakeWithSize( self.count.i64 )
        guard let ptr = LCDataPointer( lcd ) else { return LCDataMake() }
        self.copyBytes(to: ptr, count: self.count )
        return lcd
    }
}
