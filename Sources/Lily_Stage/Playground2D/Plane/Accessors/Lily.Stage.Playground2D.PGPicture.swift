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

extension Lily.Stage.Playground2D.Plane
{
    public class PGPicture : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PGScreen.current?.planeStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGAddPicture : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PGScreen.current?.planeStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGSubPicture : PGActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PGScreen.current?.planeStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}
