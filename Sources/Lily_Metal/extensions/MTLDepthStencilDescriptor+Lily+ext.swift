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

import Foundation
import Metal

extension MTLDepthStencilDescriptor
{
    public static func make( setupFunction:( inout MTLDepthStencilDescriptor )->Void ) -> MTLDepthStencilDescriptor {
        var desc = MTLDepthStencilDescriptor()
        setupFunction( &desc )
        return desc
    }
    
    @discardableResult
    public func depthCompare( _ function:MTLCompareFunction ) -> Self {
        self.depthCompareFunction = function
        return self
    }
    
    @discardableResult
    public func depthWriteEnabled( _ enabled:Bool ) -> Self {
        self.isDepthWriteEnabled = enabled
        return self
    }
}

#endif
