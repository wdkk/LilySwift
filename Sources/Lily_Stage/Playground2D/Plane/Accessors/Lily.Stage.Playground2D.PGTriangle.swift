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
    public class PGTriangle : PGActor
    {        
        @discardableResult
        public override init( storage:PlaneStorage = PGScreen.current!.planeStorage ) {
            super.init( storage:storage )
            status.shapeType = .triangle
            status.compositeType = .alpha
        }
    }
    
    public class PGAddTriangle : PGActor
    {        
        @discardableResult
        public override init( storage:PlaneStorage = PGScreen.current!.planeStorage ) {
            super.init( storage:storage )
            status.shapeType = .triangle
            status.compositeType = .add
        }
    }
    
    public class PGSubTriangle : PGActor
    {        
        @discardableResult
        public override init( storage:PlaneStorage = PGScreen.current!.planeStorage ) {
            super.init( storage:storage )
            status.shapeType = .triangle
            status.compositeType = .sub
        }
    }
}
