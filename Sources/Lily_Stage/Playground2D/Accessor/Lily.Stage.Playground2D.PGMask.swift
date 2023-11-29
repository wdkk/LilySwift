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

extension Lily.Stage.Playground2D
{
    public class PGMask : PGActor
    {        
        @discardableResult
        public init( _ assetName:String ) {
            super.init()
            status.shapeType = .mask
            status.compositeType = .alpha
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
    
    public class PGAddMask : PGActor
    {        
        @discardableResult
        public init( _ assetName:String ) {
            super.init()
            status.shapeType = .mask
            status.compositeType = .add
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
    
    public class PGSubMask : PGActor
    {        
        @discardableResult
        public init( _ assetName:String ) {
            super.init()
            status.shapeType = .mask
            status.compositeType = .sub
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
}
