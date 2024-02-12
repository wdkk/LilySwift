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
    public class BBRectangle : BBActor
    {     
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .rectangle
            status?.compositeType = .alpha
        }
    }
    
    public class BBAddRectangle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .rectangle
            status?.compositeType = .add
        }
    }
    
    public class BBSubRectangle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .rectangle
            status?.compositeType = .sub
        }
    }
}
