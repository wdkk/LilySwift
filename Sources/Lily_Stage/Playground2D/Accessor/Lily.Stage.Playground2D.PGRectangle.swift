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

extension Lily.Stage.Playground2D
{
    public class PGRectangle : PGActor
    {        
        @discardableResult
        public override init() {
            super.init()
            status.shapeType = .rectangle
            status.compositeType = .alpha
        }
    }
}
