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

public class LBTouchManager
{
    public var units = [LBTouch]( repeating: LBTouch(), count: 20 )

    public var touches:[LBTouch] {
        return (units.filter { $0.state == .touch })
    }
    
    public var releases:[LBTouch] {
        return (units.filter { $0.state == .release })
    }
    
    public func clear() { 
        for i in 0 ..< units.count { 
            units[i].xy = .zero
            units[i].state = .release
        } 
    }
}
