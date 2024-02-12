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
        
        public func shapes( on storage:BBStorage? ) -> Set<BBActor> { 
            guard let storage = storage else { return [] }
            return actorGroup[storage] ?? [] 
        }
        
        public func insert( shape:BBActor, to storage:BBStorage? ) {
            guard let storage = storage else { return }
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:BBActor, to storage:BBStorage? ) {
            guard let storage = storage else { return }
            actorGroup[storage]?.remove( shape )
        }
        
        public func removeAllShapes( on storage:BBStorage? ) { 
            guard let storage = storage else { return }
            actorGroup[storage]?.forEach { $0.trush() } 
        }
    }
}
