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
import QuartzCore
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension CGImage
{
    public static func load( assetName:String ) -> CGImage? {
        #if os(macOS)
        return NSImage( named:assetName )?.cgImage
        #else
        return UIImage( named:assetName )?.cgImage
        #endif
    }
}
