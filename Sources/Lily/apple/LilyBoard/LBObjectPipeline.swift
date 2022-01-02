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
import Metal

// オブジェクトパイプラインの基本プロトコル
public protocol LBObjectPipelineProtocol
{
    static func isExist( label:String ) -> Bool

    var compute_pipeline:LLMetalComputePipeline { get }
    var render_pipeline:LLMetalRenderPipeline { get }
    var keyLabel:String { get }
    var layerIndex:Int { get set }

    func compute( _: MTLComputeCommandEncoder )
    func render( _: MTLRenderCommandEncoder )
}

open class LBObjectPipeline< TStorage:LBActorStorage >
: LBObjectPipelineProtocol
{
    public static func isExist( label:String ) -> Bool {
        return LBObjectPipelineManager.shared.pipelines[label] != nil
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
            LLMetalShader( code: """
            #include <metal_stdlib>
            using namespace metal;
            
            struct LBActorParam {
                float4x4 matrix;
                float4 atlasUV;
                float4 color;
                float4 deltaColor;
                float2 position;
                float2 deltaPosition;
                float2 scale;
                float2 deltaScale;
                float angle;
                float deltaAngle;
                float zindex; 
                float array_index;
                float life;
                float deltaLife;
                float enabled;
                float state;    
            };
            
            kernel void LBPanel_delta_\(label) (
                device LBActorParam* params [[ buffer(0) ]],
                uint id [[thread_position_in_grid]]
            )
            {
                params[id].position += params[id].deltaPosition;
                params[id].scale += params[id].deltaScale;
                params[id].angle += params[id].deltaAngle;
                params[id].color += params[id].deltaColor;
                params[id].life += params[id].deltaLife;
            }
            """,
            shaderName: "LBPanel_delta_\(label)" )
        )
    }
    
    deinit {
        // マネージャから削除
        LBObjectPipelineManager.shared.remove( label:self.keyLabel )
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
        self.fragmentShader = shader
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
            $0.computeShader( self.computeShader ?? LLMetalShader() )
        }
        
        render_pipeline.make {
            $0.vertexShader( self.vertexShader ?? LLMetalShader() )
            $0.fragmentShader( self.fragmentShader ?? LLMetalShader() )
            // IMPORTANT: デプステクスチャと一致させる必要がある
            $0.depthAttachmentPixelFormat = .invalid
            $0.stencilAttachmentPixelFormat = .invalid
            //$0.depthAttachmentPixelFormat = .depth32Float_stencil8
            //$0.stencilAttachmentPixelFormat = .depth32Float_stencil8
            $0.colorAttachments[0].composite(type: blendType )
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
