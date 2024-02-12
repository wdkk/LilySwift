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

extension Lily.Stage.Playground3D.Billboard
{
    public class BBTriangle : BBActor
    {         
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .alpha
        }
    }
    
    public class BBAddTriangle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .add
        }
    }
    
    public class BBSubTriangle : BBActor
    {         
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .sub
        }
    }
}
