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
        public override init( storage:ModelStorage? = ModelStorage.current, assetName:String ) {
            super.init( storage:storage, assetName:assetName )
        }
    }
    
    public class Sphere : ModelActor
    {
        @discardableResult
        public init( storage:ModelStorage? = ModelStorage.current ) {
            super.init( storage:storage, assetName:"sphere" )
        }
    }
}
