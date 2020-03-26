//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import QuartzCore

extension CALayer : LLUIRectControllable
{
    public var ourCenter: CGPoint {
        get { return self.position }
        set { self.position = newValue }
    }
    
    public var ourBounds: CGRect {
        get { return self.bounds }
        set { self.bounds = newValue }
    }
}
