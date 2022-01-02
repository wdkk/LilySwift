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

/// LCDataSmPtr拡張
public extension LCDataSmPtr
{
    /// Data型への変換(別メモリとして確保して返す)
    var data:Data {
        guard let ptr = LCDataPointer( self ) else { return Data() }
        guard let length = LCDataLength( self ).i else { return Data() }
        return Data( bytes: ptr, count: length )
    }
}
