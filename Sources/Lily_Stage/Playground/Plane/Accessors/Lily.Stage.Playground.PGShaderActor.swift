//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal
import simd

extension Lily.Stage.Playground.Plane
{   
    open class PGShaderActor : PGActor
    {        

        public init( storage:PlaneStorage?, shaderName:String ) {                        
            super.init( storage:storage )
            status?.shaderIndex = PGShader.shared.getFuncIndex( name:shaderName )
        }
    }
}

#endif
