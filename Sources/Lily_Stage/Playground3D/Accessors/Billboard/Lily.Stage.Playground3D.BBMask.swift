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

extension Lily.Stage.Playground3D
{
    public class BBMask : BBActor
    {        
        @discardableResult
        public init( pool:BBPool = BBPool.current!, _ assetName:String ) {
            super.init( pool:pool )
            status.shapeType = .mask
            status.compositeType = .alpha
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
    
    public class BBAddMask : BBActor
    {        
        @discardableResult
        public init( pool:BBPool = BBPool.current!, _ assetName:String ) {
            super.init( pool:pool )
            status.shapeType = .mask
            status.compositeType = .add
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
    
    public class BBSubMask : BBActor
    {        
        @discardableResult
        public init( pool:BBPool = BBPool.current!, _ assetName:String ) {
            super.init( pool:pool )
            status.shapeType = .mask
            status.compositeType = .sub
            status.atlasUV = storage.textureAtlas.parts( assetName ).atlasUV
        }
    }
}
