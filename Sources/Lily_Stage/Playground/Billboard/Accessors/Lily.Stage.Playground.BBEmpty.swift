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
    public class BBEmpty : BBActor
    {        
        @discardableResult
        public override init( storage:BBStorage? = BBStorage.current ) {
            super.init( storage:storage )
            status?.shapeType = .empty
            status?.compositeType = .none
        }
    }
}
