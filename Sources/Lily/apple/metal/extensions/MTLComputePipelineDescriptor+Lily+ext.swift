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

import Foundation
import Metal

public extension MTLComputePipelineDescriptor 
{
    static var `default`:MTLComputePipelineDescriptor {
        return MTLComputePipelineDescriptor()
    }
    
    func computeShader( _ shader:LLMetalShader ) {
        self.computeFunction = shader.function
    }
}    
