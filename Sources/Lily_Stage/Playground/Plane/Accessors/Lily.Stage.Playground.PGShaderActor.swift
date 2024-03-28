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

extension Lily.Stage.Playground.Plane
{   
    open class PGShaderActor : PGActor
    {        
        static private(set) var logged = false
        
        public init( storage:PlaneStorage?, shaderName:String ) {
            #if targetEnvironment(simulator)
            if Self.logged == false { LLLog( "PGShader~~~はシミュレータに対応していないため描画されません" ); Self.logged = true }
            #endif
                        
            super.init( storage:storage )
            status?.shaderIndex = PGShader.shared.getFuncIndex( name:shaderName )
        }
    }
}
