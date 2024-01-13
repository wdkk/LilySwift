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
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.Stage.Playground3D
{
    open class ModelStorage
    {
        public var models:[String:Lily.Stage.Model.Obj?] = [:]
        public var statuses:Lily.Metal.Buffer<ModelUnitStatus>
        
        public var reuseIndice:[Int]

        public var capacity:Int
        
        public init( device:MTLDevice, capacity:Int, models:[String] ) {
            self.capacity = capacity
        
            self.statuses = .init( device:device, count:capacity + 1 )  // 1つ余分に確保
        
            self.reuseIndice = .init( (0..<capacity).reversed() )
        }
        
        public func loadModel( device:MTLDevice, assetName:String ) -> Lily.Stage.Model.Obj? {
            guard let asset = NSDataAsset( name:assetName ) else { return nil }
            return Lily.Stage.Model.Obj( device:device, data:asset.data )
        }
                
        // パーティクルの確保をリクエストする
        public func request( name:String ) -> Int {
            guard let idx = reuseIndice.popLast() else { 
                LLLogWarning( "Playground3D.ModelStorage: ストレージの容量を超えたリクエストです. インデックス=capacityを返します" )
                return capacity
            }
            statuses.accessor?[idx] = ModelUnitStatus( key:name )
            return idx
        }
        

        public func trush( index idx:Int ) {

        }
    }
}
