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
    public enum DrawingType : LLUInt32
    {
        case quadrangles = 0
        case triangles   = 1
    }

    public enum LifeState : Float
    {
        case active = 1.0
        case trush  = 0.0
    }
    
    public enum CompositeType : LLUInt32
    {
        case none  = 0
        case alpha = 1
        case add   = 2
        case sub   = 3
    }
    
    public enum ShapeType : LLUInt32
    {
        case empty        = 0
        case rectangle    = 1
        case triangle     = 2
        case circle       = 3
        case blurryCircle = 4
        case picture      = 101
        case mask         = 102
    }
}
