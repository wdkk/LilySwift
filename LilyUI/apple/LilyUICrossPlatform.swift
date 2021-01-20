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

#if os(iOS)
import UIKit
public typealias OSView = UIView

#elseif os(macOS)
import AppKit
public typealias OSView = LLView

#endif
