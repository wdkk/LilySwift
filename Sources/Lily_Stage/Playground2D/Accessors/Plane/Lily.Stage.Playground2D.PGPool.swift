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
        public static var shared:PGPool = .init()
        private init() {}
        
        private var actorGroup:[PlaneStorage:Set<PGActor>] = [:]
        
        public func shapes( on storage:PlaneStorage ) -> Set<PGActor> { actorGroup[storage] ?? [] }
        
        public func insert( shape:PGActor, to storage:PlaneStorage ) {
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:PGActor, to storage:PlaneStorage ) { actorGroup[storage]?.remove( shape ) }
        
        public func removeAllShapes( on storage:PlaneStorage ) {  actorGroup[storage]?.forEach { $0.trush() } }
    }
}
