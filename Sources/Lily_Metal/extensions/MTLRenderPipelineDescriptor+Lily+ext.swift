//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

/// コメント未済

import Foundation
import Metal

extension MTLRenderPipelineDescriptor 
{
    public func vertexShader( _ shader:Lily.Metal.Shader ) {
        self.vertexFunction = shader.function
    }
    
    public func fragmentShader( _ shader:Lily.Metal.Shader ) {
        self.fragmentFunction = shader.function
    }
}    

#endif
