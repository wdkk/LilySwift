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

open class LBRenderShader
{    
    public var metalVertexShader:LLMetalShader?
    public var metalFragmentShader:LLMetalShader?
    
    public internal(set) var header_code:LLMetalCodable = LLMetalShadingCode.Header()
    
    public internal(set) var struct_codes = [LLMetalCodable]()
    
    public internal(set) var func_codes = [LLMetalCodable]()
    
    public internal(set) var vert_code:LLMetalCodable = LLMetalShadingCode.Plane()
    
    public internal(set) var frag_code:LLMetalCodable = LLMetalShadingCode.Plane()
    
    public internal(set) var vert_name:String
    public internal(set) var frag_name:String
    
    public init( vertexFuncName:String, fragmentFuncName:String ) 
    {
        self.vert_name = vertexFuncName
        self.frag_name = fragmentFuncName
    }

    @discardableResult
    public func 
    header( _ f:()->String ) -> Self {
        self.header_code = LLMetalShadingCode.Plane( f() )
        return self
    }
    
    @discardableResult
    public func 
    header( _ f:( LLMetalShadingCode.Header )->LLMetalShadingCode.Header ) -> Self {
        self.header_code = f( LLMetalShadingCode.Header() )
        return self
    }

    @discardableResult
    public func 
    addStruct( _ f:()->String ) -> Self {
        self.struct_codes.append( LLMetalShadingCode.Plane( f() ) )
        return self
    }
    
    @discardableResult
    public func 
    addStruct( _ f:( LLMetalShadingCode.Struct )->LLMetalShadingCode.Struct ) -> Self {
        self.struct_codes.append( 
            f( LLMetalShadingCode.Struct() )
        )
        return self
    }
    
    @discardableResult
    public func 
    addFunction( _ f:()->String ) -> Self {
        self.func_codes.append( LLMetalShadingCode.Plane( f() ) )
        return self
    }
    
    @discardableResult
    public func 
    addFunction( _ f:( LLMetalShadingCode.Function )->LLMetalShadingCode.Function ) -> Self {
        self.func_codes.append( f( LLMetalShadingCode.Function() ) )
        return self
    }
    
    @discardableResult
    public final func 
    vertexFunction( _ f:()->String ) -> Self {
        self.vert_code = LLMetalShadingCode.Plane( f() )
        return self
    }
    
    @discardableResult
    public final func 
    vertexFunction( _ f:( LLMetalShadingCode.Function )->LLMetalShadingCode.Function ) -> Self {
        self.vert_code = f( defaultVertexFunction )

        return self
    }
    
    @discardableResult
    public final func 
    fragmentFunction( _ f:()->String ) -> Self {
        self.frag_code = LLMetalShadingCode.Plane( f() )
        return self
    }
    
    @discardableResult
    public final func 
    fragmentFunction( _ f:( LLMetalShadingCode.Function )->LLMetalShadingCode.Function ) -> Self {
        self.frag_code = f( defaultFragmentFunction )
    
        return self
    }
    
    public var defaultVertexFunction:LLMetalShadingCode.Function {
        LLMetalShadingCode.Function()
        .prefix( "vertex" )
        .name( self.vert_name )
    }
    
    public var defaultFragmentFunction:LLMetalShadingCode.Function {
        LLMetalShadingCode.Function()
        .prefix( "fragment" )
        .returnType( "float4" )
        .name( self.frag_name ) 
    }
    
    @discardableResult
    public func
    generate() -> Self {
        let vertex_code 
            = header_code.generate()
            + struct_codes.reduce( "" ) { $0 + $1.generate() }
            + func_codes.reduce( "" ) { $0 + $1.generate() }
            + vert_code.generate()
        
        let fragment_code
            = header_code.generate()
            + struct_codes.reduce( "" ) { $0 + $1.generate() }
            + func_codes.reduce( "" ) { $0 + $1.generate() }
            + frag_code.generate()
                        
        metalVertexShader = LLMetalShader( 
            code: vertex_code, 
            shaderName: self.vert_name )
        
        metalFragmentShader = LLMetalShader(
            code: fragment_code,
            shaderName: self.frag_name )
        
        return self
    }
}
