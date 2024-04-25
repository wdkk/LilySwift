//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal

extension Lily.Stage.Playground.Plane
{
    public class PGShaderTriangle : PGShaderActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .alpha
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGAddShaderTriangle : PGShaderActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .add
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
    
    public class PGSubShaderTriangle : PGShaderActor
    {        
        @discardableResult
        public init( storage:PlaneStorage? = PlaneStorage.current, assetName:String = "", shaderName:String ) {
            super.init( storage:storage, shaderName:shaderName )
            status?.shapeType = .shaderTriangle
            status?.compositeType = .sub
            status?.atlasUV = storage?.textureAtlas.parts( assetName ).atlasUV ?? .zero
        }
    }
}

#endif
