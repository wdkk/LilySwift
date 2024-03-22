//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

// TODO: PGFuncrtions
extension Lily.Stage.Playground.Plane
{
    public class PGCustom : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .custom
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGAddCustom : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .custom
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGSubCustom : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .custom
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}
