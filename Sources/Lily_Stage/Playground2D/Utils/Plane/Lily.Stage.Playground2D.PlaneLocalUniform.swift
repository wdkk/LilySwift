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
    public struct PlaneLocalUniform
    {        
        var projectionMatrix:LLMatrix4x4
        var shaderCompositeType:LLUInt32
        var drawingType:LLUInt32
        var drawingOffset:LLInt32
        
        public init(
            projectionMatrix: LLMatrix4x4 = .identity,
            shaderCompositeType: CompositeType = .none,
            drawingType:DrawingType = .quadrangles
        ) 
        {
            self.projectionMatrix = projectionMatrix
            self.shaderCompositeType = shaderCompositeType.rawValue
            self.drawingType = drawingType.rawValue
            self.drawingOffset = drawingType == .quadrangles ? 0 : 4
        }
    }
}
