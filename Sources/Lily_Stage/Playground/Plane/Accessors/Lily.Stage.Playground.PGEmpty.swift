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
    public class PGEmpty : PGActor
    {        
        @discardableResult
        public override init( storage:PlaneStorage? = PlaneStorage.current ) {
            super.init( storage:storage )
            status?.shapeType = .empty
            status?.compositeType = .none
            self.scale( square:2.0 )
        }
    }
}

#endif
