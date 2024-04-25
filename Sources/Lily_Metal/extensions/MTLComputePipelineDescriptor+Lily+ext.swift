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

extension MTLComputePipelineDescriptor 
{
    public static var `default`:MTLComputePipelineDescriptor {
        return MTLComputePipelineDescriptor()
    }
    
    public func computeShader( _ shader:Lily.Metal.Shader ) {
        self.computeFunction = shader.function
    }
}    

#endif
