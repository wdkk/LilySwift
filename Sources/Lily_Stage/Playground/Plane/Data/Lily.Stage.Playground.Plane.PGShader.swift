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
    public class PGShader
    {
        public struct PGFunctionSet
        {
            public var function:PGFunction
            public private(set) var index:LLInt32
            
            static private var sharedIndex:LLInt32 = 0
            
            public init( function:PGFunction ) {
                self.function = function
                self.index = PGFunctionSet.sharedIndex
                PGFunctionSet.sharedIndex += 1
            }
        }
        
        public static let shared = PGShader()
        private init() {}
        
        public func ready( device:MTLDevice ) { PGShader.shared.make( device:device, name:"PGShaderReadyFunc", code:"return p.color;" ) }
        
        public private(set) var functionSet:[String:PGFunctionSet] = [:]
        
        public func make( device:MTLDevice, name:String, code:String ) {
            functionSet[name] = .init( function:PGFunction( device:device, name:name, code:code ) )
        }
        
        public func getFuncIndex( name:String ) -> LLInt32 {
            return functionSet[name]?.index ?? -1
        }
        
        public var functions:[PGFunction] {
            functionSet
            .sorted { $0.value.index < $1.value.index }
            .map { $0.value.function }
        }
    }
}
