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
    func vertexShader( _ shader:Lily.Metal.Shader ) {
        self.vertexFunction = shader.function
    }
    
    func fragmentShader( _ shader:Lily.Metal.Shader ) {
        self.fragmentFunction = shader.function
    }
}    
