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
    public class BBShaderTriangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBAddShaderTriangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class BBSubShaderTriangle : BBShaderActor
    {        
        @discardableResult
        public init( storage:BBStorage? = .current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}
