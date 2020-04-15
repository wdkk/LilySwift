//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LPTexIO : LPActor
{       
    public var inTexture:MTLTexture?
    public var outTexture:MTLTexture?
    public var flex = LPFlexibleFloat16()

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
    
    @discardableResult
    public func flex( _ f:(inout LPFlexibleFloat16)->Void ) -> Self {
        var ff = self.flex
        f( &ff ) 
        self.flex = ff
        return self
    }
}
