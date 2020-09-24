//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

public protocol LLMetalCodable
{
    func generate() -> String
}

open class LLMetalShadingCode
{
    open class Plane : LLMetalCodable
    {
        public var code = ""
        public init( _ c:String = "" ) { code = c }
        
        public func generate() -> String { return code }
    }
    
    open class Header : LLMetalCodable
    {
        public var headers = [String]()
        
        public init() {
            headers.append( "#include <metal_stdlib>" )
            headers.append( "using namespace metal;" )
        }
        
        public func add( _ code:String ) -> Self {
            headers.append( code )
            return self
        }
        
        public func generate() -> String {
            var composited_code = ""
            for header in headers { composited_code += "    " + header + "\n" }
            return composited_code + "\n"
        }
    }
    
    open class Struct : LLMetalCodable
    {
        public var name = ""
        public var variables = [String]()
        
        public func name( _ v:String ) -> Self {
            name = v
            return self
        }
        
        public func add( _ type:String, _ name:String ) -> Self {
            variables.append( type + " " + name )
            return self
        }
        
        public func generate() -> String {
            var composited_code = ""
            composited_code += "struct " + name + " {\n"
            for v in variables { composited_code += "    " + v + ";\n" }
            composited_code += "};\n"
            
            return composited_code + "\n"
        }
    }
    
    open class Function : LLMetalCodable
    {
        public var prefix:String = ""
        public var returnType:String = ""
        public var name:String = "noname"
        public var arguments = [String]()
        public var code = ""
        
        public func prefix( _ v:String ) -> Self {
            prefix = v
            return self
        }
        
        public func name( _ v:String ) -> Self {
            name = v
            return self
        }

        public func returnType( _ v:String ) -> Self {
            returnType = v
            return self
        }
        
        public func addArgument( _ type:String, _ name:String ) -> Self {
            arguments.append( type + " " + name )
            return self
        }
        
        public func code( _ c:String ) -> Self {
            code = c
            return self
        }
        
        public func generate() -> String {
            // 関数の接頭辞
            var composited_code = ""
            if !prefix.isEmpty { composited_code += prefix + " " }
            composited_code += returnType + "\n"
            composited_code += name + "(\n"
            
            // 引数群
            for arg in arguments { composited_code += "    " + arg + ",\n" }
            // 最後の不要な(,\n)の削除
            if arguments.count > 0 {
                composited_code.remove(at: composited_code.index( composited_code.endIndex, offsetBy: -1 ) )
                composited_code.remove(at: composited_code.index( composited_code.endIndex, offsetBy: -1 ) )
            }
            composited_code += ")\n"
            
            // 処理ブロック
            composited_code += "{\n"
            composited_code += "    " + code + "\n"
            composited_code += "}\n"
            
            return composited_code + "\n"
        }
    }
}
