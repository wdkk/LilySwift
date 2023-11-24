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
import Metal

extension Lily.Stage
{
    public static var bundle:Bundle? {
        Bundle( path:LLPath.bundle() + "/LilySwift_LilySwift.bundle" )
    }
    
    public static func metalLibrary( of device:MTLDevice ) throws -> MTLLibrary {
        guard let bundle = bundle else { throw NSError( domain:"LilySwiftのバンドルが取得できませんでした", code:1 ) }
        return try device.makeDefaultLibrary( bundle:bundle )
    }
}
