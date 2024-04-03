//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import simd

extension Lily.Stage.Playground.Billboard
{   
    open class BBShaderActor : BBActor
    {        
        public init( storage:BBStorage?, shaderName:String ) {            
            super.init( storage:storage )
            status?.shaderIndex = BBShader.shared.getFuncIndex( name:shaderName )
        }
    }
}
