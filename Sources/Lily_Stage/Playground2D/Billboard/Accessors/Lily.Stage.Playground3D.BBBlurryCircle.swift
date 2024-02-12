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
    public class BBBlurryCircle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .blurryCircle
            status?.compositeType = .alpha
        }
    }
    
    public class BBAddBlurryCircle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .blurryCircle
            status?.compositeType = .add
        }
    }
    
    public class BBSubBlurryCircle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = Lily.Stage.Playground2D.PGScreen.current?.bbStorage ) {
            super.init( storage:storage )
            status?.shapeType = .blurryCircle
            status?.compositeType = .sub
        }
    }
}
