//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Metal

// Metalライブラリでコードを読み込むのを簡単にするための拡張
public extension MTLLibrary
{
    static func make( with code:String ) -> MTLLibrary? {
        do {
            return try LLMetalManager.device?.makeLibrary( source: code, options:nil )
        }
        catch {
            return nil
        }
    }
}
