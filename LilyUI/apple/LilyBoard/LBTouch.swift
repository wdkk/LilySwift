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

public struct LBTouch
{
    public enum State : Int
    {
        case touch
        case release
    }
    
    public var xy:LLPointFloat = .zero
    public var uv:LLPointFloat = .zero
    public var state:State = .release
}
