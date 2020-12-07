//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation
import Metal

open class LPTexIO : LPActor
{       
    public var inTexture:MTLTexture?
    public var outTexture:MTLTexture?

    @discardableResult
    public func input( texture:MTLTexture? ) -> Self {
        inTexture = texture
        return self
    }
    
    @discardableResult
    public func input( texture:LLMetalTexture? ) -> Self {
        inTexture = texture?.metalTexture
        return self
    }
    
    @discardableResult
    public func output( texture:MTLTexture? ) -> Self {
        outTexture = texture
        return self
    }
    
    @discardableResult
    public func output( texture:LLMetalTexture? ) -> Self {
        outTexture = texture?.metalTexture
        return self
    }
}

#endif
