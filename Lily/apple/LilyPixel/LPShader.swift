//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Metal

open class LPShader
{    
    public var metalComputeShader:LLMetalShader?
    
    public internal(set) var header_code:LLMetalCodable = LLMetalShadingCode.Header()
    
    public internal(set) var struct_codes:[LLMetalCodable] = []
    
    public internal(set) var func_codes:[LLMetalCodable] = []
    
    public internal(set) var comp_code:LLMetalCodable = LLMetalShadingCode.Plane()
    
    public internal(set) var comp_name:String
    
    public init( computeFuncName:String ) {
        self.comp_name = computeFuncName
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
    public func 
    computeFunction( _ f:()->String ) -> Self {
        self.comp_code = LLMetalShadingCode.Plane( f() )
        return self
    }
    
    @discardableResult
    public final func 
    computeFunction( _ f:( LLMetalShadingCode.Function )->LLMetalShadingCode.Function ) -> Self {
        self.comp_code = f(
            defaultComputeFunction
        )        
        return self
    }
    
    public var defaultComputeFunction:LLMetalShadingCode.Function {
        LLMetalShadingCode.Function()
        .prefix( "kernel" )
        .returnType( "void" )
        .name( self.comp_name )
    }
    
    @discardableResult
    public func
    generate() -> Self {
        let compute_code
            = header_code.generate()
            + struct_codes.reduce( "" ) { $0 + $1.generate() }
            + func_codes.reduce( "" ) { $0 + $1.generate() }
            + comp_code.generate()
        
        metalComputeShader = LLMetalShader( 
            code: compute_code, 
            shaderName: self.comp_name )
 
        return self
    }
}

#endif
