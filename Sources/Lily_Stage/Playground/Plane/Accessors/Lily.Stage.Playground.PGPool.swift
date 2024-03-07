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

extension Lily.Stage.Playground.Plane
{   
    open class PGPool
    {   
        public static var shared:PGPool = .init()
        private init() {}
        
        private var actorGroup:[Storage:Set<PGActor>] = [:]
        
        public func shapes( on storage:Storage? ) -> Set<PGActor> { 
            guard let storage = storage else { return [] }
            return actorGroup[storage] ?? [] 
        }
        
        public func insert( shape:PGActor, to storage:Storage? ) {
            guard let storage = storage else { return }
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:PGActor, to storage:Storage? ) {
            guard let storage = storage else { return }
            actorGroup[storage]?.remove( shape )
        }
        
        public func removeAllShapes( on storage:Storage? ) {
            guard let storage = storage else { return }
            actorGroup[storage]?.forEach { $0.trush() }
        }
    }
}
