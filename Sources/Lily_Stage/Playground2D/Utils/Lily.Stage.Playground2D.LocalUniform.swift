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

extension Lily.Stage.Playground2D
{    
    public struct LocalUniform
    {
        var projectionMatrix:LLMatrix4x4
        var shaderCompositeType:LLUInt32
        
        public init(projectionMatrix: LLMatrix4x4 = .identity, shaderCompositeType: UnitStatus.CompositeType = .none ) {
            self.projectionMatrix = projectionMatrix
            self.shaderCompositeType = shaderCompositeType.rawValue
        }
    }
}
