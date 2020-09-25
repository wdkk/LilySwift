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
import CoreGraphics

public protocol LLUILifeEvent
{
    /// UIの準備サイクル
    func preSetup()
    func setup()
    func postSetup()
    
    /// UIの構築/再構築サイクル
    func preBuildup()
    func buildup()
    func postBuildup()
    
    /// UIの取り壊しサイクル
    func teardown()
    
    /// buildupを直接コールせずrebuildを呼ぶ
    func rebuild()
}
