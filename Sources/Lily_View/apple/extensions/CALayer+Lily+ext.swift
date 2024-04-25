//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if canImport(QuartzCore)
import QuartzCore
#endif

#if canImport(QuartzCore)
extension CALayer 
: LLUIRectControllable
{
    public var center: CGPoint {
        get { return self.position }
        set { self.position = newValue }
    }
    
    public var ownFrame:CGRect {
        get { return self.bounds }
        set { self.bounds = newValue }
    }
}
#endif
