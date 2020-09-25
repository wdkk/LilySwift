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
    static func isExist( label:String ) -> Bool

    var compute_pipeline:LLMetalComputePipeline { get }
    var render_pipeline:LLMetalRenderPipeline { get }
    var keyLabel:String { get }
    var layerIndex:Int { get set }

    func compute( _: MTLComputeCommandEncoder )
    func render( _: MTLRenderCommandEncoder )
}

open class LBDecoration< TStorage:LBActorStorage > : LBDecoratable
{

    public static func isExist( label:String ) -> Bool {
        return LBDecorationManager.shared.decorations[label] != nil
    }
    
    public private(set) var compute_pipeline = LLMetalComputePipeline()
    public private(set) var render_pipeline = LLMetalRenderPipeline()
    public private(set) var keyLabel:String = ""
    public var layerIndex:Int = 0
    
    public var computeShader:LLMetalShader?
    public var vertexShader:LLMetalShader?
    public var fragmentShader:LLMetalShader?
    public private(set) var ready:Bool = false
    public var blendType:LLMetalBlendType = .alphaBlend
    
    var _compute_f:LLField?
    var _render_f:LLField?
    
    public var storage = TStorage()
    
    init( label:String ) { 
        self.keyLabel = label
        
        self.computeShader(
            LBComputeShader( computeFuncName: "LBPanel_delta_\(label)" )
            .addStruct {
                $0
                .name( "LBActorParam" )
                .add( "float4x4", "matrix" )
                .add( "float4", "atlasUV" )
                .add( "float4", "color" )
                .add( "float4", "deltaColor" )
                .add( "float2", "position" )
                .add( "float2", "deltaPosition" )
                .add( "float2", "scale" )
                .add( "float2", "deltaScale" )
                .add( "float", "angle" )
                .add( "float", "deltaAngle" )
                .add( "float", "zindex" )  
                .add( "float", "array_index" )
                .add( "float", "life" )
                .add( "float", "deltaLife" )
                .add( "float", "enabled" )
                .add( "float", "state" )            
            }      
            .computeFunction {
                $0
                .addArgument( "device LBActorParam", "* params [[ buffer(0) ]]" )
                .addArgument( "uint", "id [[thread_position_in_grid]]" )
                /*
                .addArgument( "uint", "group_pos [[ threadgroup_position_in_grid ]]" )
                .addArgument( "uint", "thread_pos [[ thread_position_in_threadgroup ]]" )
                .addArgument( "uint", "threads_per_threadgroup [[ threads_per_threadgroup ]]" )
                */
                .code( """
                    //uint id = (group_pos * threads_per_threadgroup + thread_pos);
                    params[id].position += params[id].deltaPosition;
                    params[id].scale += params[id].deltaScale;
                    params[id].angle += params[id].deltaAngle;
                    params[id].color += params[id].deltaColor;
                    params[id].life += params[id].deltaLife;
                """ )
            }
        )
    }
    
    deinit {
        // マネージャから削除
        LBDecorationManager.shared.remove( label:self.keyLabel )
    }

    @discardableResult
    public func computeShader( _ shader:LLMetalShader ) -> Self {
        self.computeShader = shader
        return self
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
    
    // コード文字列と関数名からシェーダを指定
    @discardableResult
    public func computeShader( _ computeCode:(funcName:String, code:String) )
    -> Self {
        self.computeShader = LLMetalShader(code: computeCode.code, shaderName: computeCode.funcName )
        return self
    }

    @discardableResult
    public func computeShader( _ shader:LBComputeShader ) -> Self {
        shader.generate()
        self.computeShader = shader.metalComputeShader
        return self
    }
    
    // LBRenderShaderでシェーダを指定
    @discardableResult
    public func renderShader( _ lbshader:LBRenderShader ) -> Self {
        // LBShaderを用いてシェーダを生成する
        lbshader.generate()
        
        self.vertexShader = lbshader.metalVertexShader
        self.fragmentShader = lbshader.metalFragmentShader
        return self
    }
    
    // LLMetalShaderからシェーダを指定
    @discardableResult
    public func renderShader( vertexShader:LLMetalShader, fragmentShader:LLMetalShader ) -> Self {
        self.vertexShader = vertexShader
        self.fragmentShader = fragmentShader
        return self
    }
    
    // コード文字列と関数名からシェーダを指定
    @discardableResult
    public func renderShader( vertexCode:(funcName:String, code:String),
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
        
        compute_pipeline.make {
            $0.computeShader = self.computeShader ?? LLMetalShader()
        }
        
        render_pipeline.make {
            $0.vertexShader = self.vertexShader ?? LLMetalShader()
            $0.fragmentShader = self.fragmentShader ?? LLMetalShader()
            // LilyBoardはデプスを使わない
            $0.depthState.depthFormat = .invalid
            $0.colorAttachment.composite(type: blendType )
        }
        
        return self
    }

    public func compute( _ encoder:MTLComputeCommandEncoder ) {
        _compute_f?.appear( encoder )
    }
    
    public func render( _ encoder:MTLRenderCommandEncoder ) {
        _render_f?.appear( encoder )
    }
}
