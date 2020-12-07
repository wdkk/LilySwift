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

open class LLMetalComputer
{    
    @discardableResult
    public static func compute( 
        commandBuffer:MTLCommandBuffer,
        compute:( _ computeEncoder:MTLComputeCommandEncoder )->() ) 
    -> Bool 
    {        
        guard let encoder = commandBuffer.makeComputeCommandEncoder() else {
            LLLogWarning( "コマンドエンコーダの生成に失敗しました." )
            return false
        }
                
        compute( encoder )
        
        encoder.endEncoding()
        
        return true
    }
}
