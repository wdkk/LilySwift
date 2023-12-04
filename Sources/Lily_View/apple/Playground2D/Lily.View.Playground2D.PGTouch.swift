//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

extension Lily.View.Playground2D
{ 
    public struct PGTouch
    {
        public enum State : Int
        {
            case began
            case touch
            case release
            case none
        }
        
        public var startPos:LLPointFloat = .zero
        
        public var xy:LLPointFloat = .zero
        public var uv:LLPointFloat = .zero
        public var state:State = .none
        
        public var x:LLFloat { xy.x }
        public var y:LLFloat { xy.y }
        
        public var u:LLFloat { uv.x }
        public var v:LLFloat { uv.y }
        
        public init(
            xy:LLPointFloat = .zero,
            uv:LLPointFloat = .zero,
            state:State = .none
        )
        {
            self.xy = xy
            self.uv = uv
            self.state = state
        }
        
        public var isBegan:Bool { self.state == .began }
        public var isReleased:Bool { self.state == .release }
    }
    
    #if os(macOS)
    public enum MacOSMousePhase 
    {
        case began
        case moved
        case stationary
        case ended
        case cancelled
    }
    #endif
}
