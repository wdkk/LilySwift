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

extension Lily.Stage.Playground3D.Model
{   
    open class ModelPool
    {   
        public static var shared:ModelPool = .init()
        private init() {}
        
        private var actorGroup:[ModelStorage:Set<ModelActor>] = [:]
        
        public func shapes( on storage:ModelStorage ) -> Set<ModelActor> { actorGroup[storage] ?? [] }
        
        public func insert( shape:ModelActor, to storage:ModelStorage ) {
            if actorGroup[storage] == nil { actorGroup[storage] = [] }
            actorGroup[storage]?.insert( shape ) 
        }
        public func remove( shape:ModelActor, to storage:ModelStorage ) { actorGroup[storage]?.remove( shape ) }
        
        public func removeAllShapes( on storage:ModelStorage ) {  actorGroup[storage]?.forEach { $0.trush() } }
    }
}
