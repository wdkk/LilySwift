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
    public class BBRectangle : BBActor
    {        
        @discardableResult
        public override init( pool:BBPool = BBPool.current! ) {
            super.init( pool:pool )
            status.shapeType = .rectangle
            status.compositeType = .alpha
        }
    }
    
    public class BBAddRectangle : BBActor
    {        
        @discardableResult
        public override init( pool:BBPool = BBPool.current! ) {
            super.init( pool:pool )
            status.shapeType = .rectangle
            status.compositeType = .add
        }
    }
    
    public class BBSubRectangle : BBActor
    {        
        @discardableResult
        public override init( pool:BBPool = BBPool.current! ) {
            super.init( pool:pool )
            status.shapeType = .rectangle
            status.compositeType = .sub
        }
    }
}
