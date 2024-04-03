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
    public class BBShader
    {
        public struct BBFunctionSet
        {
            public var function:BBFunction
            public private(set) var index:LLInt32
            
            static private var sharedIndex:LLInt32 = 0
            
            public init( function:BBFunction ) {
                self.function = function
                self.index = BBFunctionSet.sharedIndex
                BBFunctionSet.sharedIndex += 1
            }
        }
        
        public static let shared = BBShader()
        private init() {}
        
        private(set) var logged = false
        
        public func ready( device:MTLDevice ) { BBShader.shared.make( device:device, name:"BBShaderReadyFunc", code:"return p.color;" ) }
        
        public private(set) var functionSet:[String:BBFunctionSet] = [:]
        
        public func make( device:MTLDevice, name:String, code:String ) {
            if !device.supportsFamily( .apple6 ) {
                if logged == false { LLLog( "このデバイスはBBShader~~~に対応していないため描画されません" ); logged = true }
            }
                        
            functionSet[name] = .init( function:.init( device:device, name:name, code:code ) )
        }
        
        public func getFuncIndex( name:String ) -> LLInt32 {
            return functionSet[name]?.index ?? -1
        }
        
        public var functions:[BBFunction] {
            functionSet
            .sorted { $0.value.index < $1.value.index }
            .map { $0.value.function }
        }
    }
}
