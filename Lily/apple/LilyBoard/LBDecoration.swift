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

// デコレーションの基本プロトコル
public protocol LBDecoratable
{
    var pipeline:LLMetalRenderPipeline { get set }
    var keyLabel:String { get }
    var layerIndex:Int { get set }
    
    func draw( _: MTLRenderCommandEncoder )
    
    static func isExist( label:String ) -> Bool
}

// デコレーションのカスタムプロトコル
public protocol LBDecorationCustomizable
{
    static func custom( label:String ) -> Self
}

open class LBDecoration : LBDecoratable
{
    public var pipeline = LLMetalRenderPipeline()
    public private(set) var keyLabel:String = ""
    public var layerIndex:Int = 0
    
    public var vertexShader:LLMetalShader?
    public var fragmentShader:LLMetalShader?
    public private(set) var ready:Bool = false
    public var blendType:LLMetalBlendType = .alphaBlend
    
    var _draw_f:LLField?
    
    public static func isExist( label:String ) -> Bool {
        return LBDecorationManager.shared.decorations[label] != nil
    }
        
    // 以下メンバ
    init( label:String ) { 
        self.keyLabel = label
    }
    
    deinit {
        // マネージャから削除
        LBDecorationManager.shared.remove( label:self.keyLabel )
    }
    
    @discardableResult
    public func vertexShader( _ shader:LLMetalShader ) -> Self {
        self.vertexShader = shader
        return self
    }
    
    @discardableResult
    public func fragmentShader( _ shader:LLMetalShader ) -> Self {
        self.vertexShader = shader
        return self
    }
    
    // LBShaderでシェーダを指定
    @discardableResult
    public func shader( _ lbshader:LBShader ) -> Self {
        // LBShaderを用いてシェーダを生成する
        lbshader.generate()
        
        self.vertexShader = lbshader.metalVertexShader
        self.fragmentShader = lbshader.metalFragmentShader
        return self
    }
    
    // LLMetalShaderからシェーダを指定
    @discardableResult
    public func shader( vertexShader:LLMetalShader, fragmentShader:LLMetalShader ) -> Self {
        self.vertexShader = vertexShader
        self.fragmentShader = fragmentShader
        return self
    }
    
    // コード文字列と関数名からシェーダを指定
    @discardableResult
    public func shader( vertexCode:(funcName:String, code:String),
                        fragmentCode:(funcName:String, code:String) )
    -> Self {
        let vert_shader = LLMetalShader(code: vertexCode.code, shaderName: vertexCode.funcName )
        let frag_shader = LLMetalShader(code: vertexCode.code, shaderName: vertexCode.funcName )
        
        self.vertexShader = vert_shader
        self.fragmentShader = frag_shader
        return self
    }

    @discardableResult
    public func layer( index:Int ) -> Self {
        self.layerIndex = index
        return self
    }
    
    @discardableResult
    public func blendType( _ type:LLMetalBlendType ) -> Self {
        self.blendType = type
        return self
    }
    
    @discardableResult
    public func make() -> Self {
        if ready { return self }
        ready = true
        
        pipeline.make {
            $0.vertexShader = self.vertexShader ?? LLMetalShader()
            $0.fragmentShader = self.fragmentShader ?? LLMetalShader()
            // LilyBoardはデプスを使わない
            $0.depthState.depthFormat = .invalid
            $0.colorAttachment.composite(type: blendType )
        }
        
        return self
    }
    
    public func draw( _ encoder:MTLRenderCommandEncoder ) {
        _draw_f?.appear( encoder )
    }
}
