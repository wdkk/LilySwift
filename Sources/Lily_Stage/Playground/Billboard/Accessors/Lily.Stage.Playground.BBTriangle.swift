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

extension Lily.Stage.Playground.Billboard
{
    public class BBTriangle : BBActor
    {         
        @discardableResult
        public override init( storage:BBStorage? = BBStorage.current ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .alpha
        }
    }
    
    public class BBAddTriangle : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = BBStorage.current ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .add
        }
    }
    
    public class BBSubTriangle : BBActor
    {         
        @discardableResult
        public override init( storage:BBStorage? = BBStorage.current ) {
            super.init( storage:storage )
            status?.shapeType = .triangle
            status?.compositeType = .sub
        }
    }
}

#endif
