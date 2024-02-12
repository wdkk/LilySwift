//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
import UIKit
#endif

extension Lily.Stage.Playground
{ 
    public class PGTouchManager
    {
#if os(iOS) || os(visionOS) || targetEnvironment(macCatalyst)
        public var allTouches = [UITouch]()
#endif
        public var units = [PGTouch]( repeating: .init(), count:20 )
        public var starts = [PGTouch]( repeating: .init(), count:20 )
        
        // タッチに関わる配列
        public var touches:[PGTouch] { units.filter { $0.state == .began || $0.state == .touch || $0.state == .release } }
        // タッチ完了状態に絞った配列
        public var releases:[PGTouch] { units.filter { $0.state == .release } }
        
        public func changeBegansToTouches() {
            for i in 0 ..< units.count { 
                // .beganから.touchへ移行
                if units[i].state == .began { units[i].state = .touch }
            }
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
}
