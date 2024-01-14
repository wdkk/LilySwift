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
        public struct ModelGuide
        {
            var modelIndex:Int32
            var meshData:Lily.Stage.Model.Obj?
        }
        
        public var models:[String:ModelGuide] = [:]
        public var statuses:Lily.Metal.Buffer<ModelUnitStatus>
        
        public private(set) var reuseIndice:[Int]

        public private(set) var objCount:Int
        public private(set) var cameraCount:Int
        
        public var capacity:Int { objCount * cameraCount }
        
        public init( 
            device:MTLDevice, 
            objCount:Int,
            cameraCount:Int,
            modelAssets:[String] 
        )
        {
            self.objCount = objCount
            self.cameraCount = cameraCount
            let capacity = self.objCount * self.cameraCount
            
            self.statuses = .init( device:device, count:capacity + 1 )  // 1つ余分に確保
        
            self.reuseIndice = .init( (0..<capacity).reversed() )
            
            for i in 0 ..< modelAssets.count {
                let asset_name = modelAssets[i]
                let obj = loadObj( device:device, assetName:asset_name )
                models[asset_name] = ModelGuide( modelIndex:i.i32!, meshData:obj )
            }
        }
        
        public func loadObj( device:MTLDevice, assetName:String ) -> Lily.Stage.Model.Obj? {
            guard let asset = NSDataAsset( name:assetName ) else { return nil }
            return Lily.Stage.Model.Obj( device:device, data:asset.data )
        }
                
        // パーティクルの確保をリクエストする
        public func request( assetName:String ) -> Int {
            guard let idx = reuseIndice.popLast() else { 
                LLLogWarning( "Playground3D.ModelStorage: ストレージの容量を超えたリクエストです. インデックス=capacityを返します" )
                return capacity
            }
            let model_index = models[assetName]?.modelIndex ?? -1
            statuses.accessor?[idx] = ModelUnitStatus( modelIndex:model_index )
            return idx
        }
    
        public func trush( index idx:Int ) {
            statuses.update( at:idx ) { us in
                us.state = .trush
                us.enabled = false
            }
            reuseIndice.append( idx )
        }
    }
}
