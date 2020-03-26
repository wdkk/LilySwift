//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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
}

public struct LLMetalDepthState
{
    public var sampleCount:Int = 1
    public var depthFormat:MTLPixelFormat = .depth32Float_stencil8
}

public struct LLMetalRenderSetting
{
    // 深度ステート
    public var depthState = LLMetalDepthState()
    // 頂点シェーダー
    public var vertexShader = LLMetalShader()
    // フラグメントシェーダー
    public var fragmentShader = LLMetalShader()
    // カラーアタッチメント
    public var colorAttachment = MTLRenderPipelineColorAttachmentDescriptor()
    // 頂点ディスクリプタ
    public var vertexDesc:MTLVertexDescriptor? = nil
    
    public init() {
        colorAttachment.pixelFormat = .bgra8Unorm
        colorAttachment.composite(type: .alphaBlend )
    }
}
