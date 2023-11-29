//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground2D
{   
    open class PGPool
    {   
        public static var current:PGPool? = nil
        public init() {}
        
        public private(set) var shapes:Set<PGActor> = []
        public var storage:Storage?
        
        public func insertShape( _ shape:PGActor ) { shapes.insert( shape ) }
        public func removeShape( _ shape:PGActor ) { shapes.remove( shape ) }
    }
}
