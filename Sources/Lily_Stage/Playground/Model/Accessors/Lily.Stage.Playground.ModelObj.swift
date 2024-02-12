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

extension Lily.Stage.Playground.Model
{
    public class ModelObj : ModelActor
    {
        @discardableResult
        public override init( storage:ModelStorage? = Lily.Stage.Playground.PGScreen.current?.modelStorage, assetName:String ) {
            super.init( storage:storage, assetName:assetName )
        }
    }
}
