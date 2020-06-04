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
    public var params = [LBActorParam]()
    
    public required init() { }
    
    public func draw( encoder:MTLRenderCommandEncoder, index:Int ) { }

    public func reuse() -> Int? { return nil }
    
    public func request() -> Int { return 0 }
}
