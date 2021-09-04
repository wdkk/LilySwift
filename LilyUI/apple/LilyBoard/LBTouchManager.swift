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
   
    public var starts = [LBTouch]( repeating: LBTouch(), count: 20 )

    // タッチに関わる配列
    public var touches:[LBTouch] {
        return (units.filter {
            $0.state == .began ||
            $0.state == .touch ||
            $0.state == .release 
        })
    }
    
    // タッチ完了状態に絞って配列
    public var releases:[LBTouch] {
        return (units.filter { $0.state == .release })
    }
    
    public func resetReleases() {
        for i in 0 ..< units.count { 
            if units[i].state == .release {
                // リリース情報のクリア
                units[i].xy = .zero
                units[i].state = .none
                // スタート位置の座標のクリア
                starts[i].xy = .zero
                starts[i].state = .none
            }
        }
    }
        
    public func clear() { 
        for i in 0 ..< units.count { 
            units[i].xy = .zero
            units[i].state = .none
        }
    }
}
