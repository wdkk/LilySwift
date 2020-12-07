//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Metal

public enum LLMetalBlendType : Int
{
    case none
    case alphaBlend
    case add
    case sub
    case max
    case min
}

public struct LLMetalDepthState
{
    public var sampleCount:Int = 1
    public var depthFormat:MTLPixelFormat = .depth32Float_stencil8
}

public struct LLMetalRenderSetting
{
    // 深度ステート
    public var depthState:LLMetalDepthState = LLMetalDepthState()
    // 頂点シェーダー
    public var vertexShader:LLMetalShader = LLMetalShader()
    // フラグメントシェーダー
    public var fragmentShader:LLMetalShader = LLMetalShader()
    // カラーアタッチメント
    public var colorAttachment:MTLRenderPipelineColorAttachmentDescriptor = MTLRenderPipelineColorAttachmentDescriptor()
    // 頂点ディスクリプタ
    public var vertexDesc:MTLVertexDescriptor? = nil
    
    public init() {
        colorAttachment.pixelFormat = .bgra8Unorm
        colorAttachment.composite(type: .alphaBlend )
    }
}
