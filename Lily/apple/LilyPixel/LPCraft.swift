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

// クラフトの基本プロトコル
public protocol LPCraftable
{
    var pipeline:LLMetalComputePipeline { get set }
    
    func fire( using: MTLComputeCommandEncoder )
}

// クラフトのカスタムプロトコル
public protocol LPCraftCustomizable
{
    static func custom() -> Self
}

open class LPCraft : LPCraftable
{
    public var pipeline = LLMetalComputePipeline()
    public var computeShader:LLMetalShader?
    public private(set) var ready:Bool = false
    
    var _fire_f:LLField?
     
    init() {}

    @discardableResult
    public func shader( _ shader:LPShader ) -> Self {
        // LPShaderを用いてシェーダを生成する
        shader.generate()
        
        self.computeShader = shader.metalComputeShader

        return self
    }
    
    // LLMetalShaderからシェーダを指定
    @discardableResult
    public func shader( computeShader:LLMetalShader )
    -> Self {
        self.computeShader = computeShader
        return self
    }
    
    // コード文字列と関数名からシェーダを指定
    @discardableResult
    public func shader( computeCode:(funcName:String, code:String) )
    -> Self {
        let comp_shader = LLMetalShader(code: computeCode.code, shaderName: computeCode.funcName )
        self.computeShader = comp_shader
        return self
    }
    
    @discardableResult
    public func make()
    -> Self {
        if ready { return self }
        ready = true
        
        pipeline.make {
            $0.computeShader = self.computeShader ?? LLMetalShader()
        }
        
        return self
    }
    
    public func fire( using encoder:MTLComputeCommandEncoder ) {
        // makeされていなかった場合実行する
        self.make()
        
        encoder.use( self.pipeline ) { 
            _fire_f?.appear( $0 )
        }
    }
}

#endif
