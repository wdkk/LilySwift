//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation

/// UserDefault拡張
public extension UserDefaults
{    
    /// Int64型の保存
    /// - Parameters:
    ///   - value: 書き込む値
    ///   - key: 対象キー
    func set( _ value:Int64, key:String ) {
        let num = NSNumber( value: value )
        self.set( num, forKey: key )
    }
    
    /// Int64型での取得
    /// - Parameter key: 対象キー
    func int64( _ key:String ) -> Int64 {
        guard let num = self.object( forKey: key ) as? NSNumber else { return 0 }
        return num.int64Value
    }
}

#endif
