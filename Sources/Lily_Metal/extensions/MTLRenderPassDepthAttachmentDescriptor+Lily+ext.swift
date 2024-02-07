//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

extension MTLRenderPassDepthAttachmentDescriptor
{
    @discardableResult
    public func clearDepth( _ depth:Double ) -> Self {
        self.clearDepth = depth
        return self
    }

    @discardableResult
    public func loadAction( _ action:MTLLoadAction ) -> Self {
        self.loadAction = action
        return self
    }

    @discardableResult
    public func storeAction( _ action:MTLStoreAction ) -> Self {
        self.storeAction = action
        return self
    }
    
    @discardableResult
    public func action( load:MTLLoadAction, store:MTLStoreAction ) -> Self {
        self.loadAction = load
        self.storeAction = store
        return self
    }
}
