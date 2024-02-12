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

extension Lily.Stage.Playground.Model
{   
    open class ModelPool
    {   
        public static var shared:ModelPool = .init()
        private init() {}
        
        private var actorGroup:[ModelStorage:Set<ModelActor>] = [:]
        
        public func shapes( on storage:ModelStorage? ) -> Set<ModelActor> {
            guard let storage = storage else { return [] }
            return actorGroup[storage] ?? []
        }
        
        public func insert( shape:ModelActor, to storage:ModelStorage? ) {
            guard let storage = storage else { return }
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:ModelActor, to storage:ModelStorage? ) { 
            guard let storage = storage else { return }
            actorGroup[storage]?.remove( shape ) 
        }
        
        public func removeAllShapes( on storage:ModelStorage? ) { 
            guard let storage = storage else { return }
            actorGroup[storage]?.forEach { $0.trush() }
        }
    }
}
