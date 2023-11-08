//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

public extension MTLRenderPipelineDescriptor 
{
    static var `default`:MTLRenderPipelineDescriptor {
        let desc = MTLRenderPipelineDescriptor()
        desc.colorAttachments[0].pixelFormat = .bgra8Unorm
        desc.colorAttachments[0].composite(type: .alphaBlend )  // Lilyのコンポジット用関数
        desc.depthAttachmentPixelFormat = .depth32Float_stencil8
        desc.stencilAttachmentPixelFormat = .depth32Float_stencil8
        #if !os(visionOS)
        desc.sampleCount = 1
        #endif
        return desc
    }
    
    func vertexShader( _ shader:Lily.Metal.Shader ) {
        self.vertexFunction = shader.function
    }
    
    func fragmentShader( _ shader:Lily.Metal.Shader ) {
        self.fragmentFunction = shader.function
    }
}    
