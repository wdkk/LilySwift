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

open class LPImpIO : LPActor
{       
    public var inImage:LLImage?
    public var outImage:LLImage?
    public var flex = LPFlexibleFloat16()
    
    @discardableResult
    public func input( image:LLImage? ) -> Self {
        inImage = image
        return self
    }
        
    @discardableResult
    public func output( image:LLImage? ) -> Self {
        outImage = image
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
