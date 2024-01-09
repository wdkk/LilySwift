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

extension Lily.Stage.Playground3D
{   
    open class BBPool
    {   
        public static var current:BBPool? = nil
        public init() {}
        
        public private(set) var shapes:Set<BBActor> = []
        public var storage:BBStorage?
        
        public func insertShape( _ shape:BBActor ) { shapes.insert( shape ) }
        public func removeShape( _ shape:BBActor ) { shapes.remove( shape ) }
        
        func removeAllShapes() {
            shapes.forEach { $0.trush() }
        }
    }
}
