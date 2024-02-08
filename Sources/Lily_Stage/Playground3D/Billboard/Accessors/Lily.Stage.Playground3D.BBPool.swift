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

extension Lily.Stage.Playground3D.Billboard
{   
    open class BBPool
    {   
        public static var shared:BBPool = .init()
        private init() {}
        
        private var actorGroup:[BBStorage:Set<BBActor>] = [:]
        
        public func shapes( on storage:BBStorage ) -> Set<BBActor> { actorGroup[storage] ?? [] }
        
        public func insert( shape:BBActor, to storage:BBStorage ) {
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:BBActor, to storage:BBStorage ) { actorGroup[storage]?.remove( shape ) }
        
        public func removeAllShapes( on storage:BBStorage ) { actorGroup[storage]?.forEach { $0.trush() } }
    }
}
