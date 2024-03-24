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
    public class BBShaderRectangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderRectangle
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBAddShaderRectangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderRectangle
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBSubShaderRectangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderRectangle
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}
