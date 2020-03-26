//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
import CoreVideo
#endif

#if os(iOS)
public typealias OSEvent = UIEvent
#elseif os(macOS)
public typealias OSEvent = NSEvent
#endif
