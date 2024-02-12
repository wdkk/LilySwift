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

extension Lily.Stage.Playground.Billboard
{
    public class BBPicture : BBActor
    {          
        @discardableResult
        public init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBAddPicture : BBActor
    {            
        @discardableResult
        public init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBSubPicture : BBActor
    {         
        @discardableResult
        public init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage, _ assetName:String ) {
            super.init( storage:storage )
            status?.shapeType = .picture
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}
