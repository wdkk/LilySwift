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

extension Lily.Stage.Playground.Model
{
    public class MDObj : MDActor
    {
        @discardableResult
        public override init( storage:ModelStorage? = ModelStorage.current, assetName:String ) {
            super.init( storage:storage, assetName:assetName )
        }
    }
}

#endif
