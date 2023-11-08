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

/// UUID拡張
public extension UUID
{    
    var labelString:String {
        return uuidString.replace( old: "-", new: "_" )
    }
}
