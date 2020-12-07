//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation

/// LCDataMake関数の型オーバーロード
public func LCDataMakeWithBytes( _ bin:LLUInt8Ptr, _ length:Int ) -> LCDataSmPtr {
    return LCDataMakeWithBytes( bin, length.i64 )
}

#endif
