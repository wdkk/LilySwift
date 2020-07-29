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

open class LBActorStorage
{
    public var params = LLAlignedMemory4096<LBActorParam>()
    
    public required init() { }
    
    public func request() -> Int { return 0 }
    
    public func reuse() -> Int? {
        for i in 0 ..< params.count {
            guard let p = params.accessor?[i] else { return nil }
            if p.state == .trush { return p.arrayIndex }
        }
        return nil
    }
    
    public var isNoActive : Bool {
        for i in 0 ..< params.count {
            guard let state = params.accessor?[i].state else { continue }
            if state == .active { return false }
        }
        return true
    }
}
