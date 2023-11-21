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

public extension MTLRenderPassDepthAttachmentDescriptor
{
    @discardableResult
    func clearDepth( _ depth:Double ) -> Self {
        self.clearDepth = depth
        return self
    }

    @discardableResult
    func loadAction( _ action:MTLLoadAction ) -> Self {
        self.loadAction = action
        return self
    }

    @discardableResult
    func storeAction( _ action:MTLStoreAction ) -> Self {
        self.storeAction = action
        return self
    }
    
    @discardableResult
    func action( load:MTLLoadAction, store:MTLStoreAction ) -> Self {
        self.loadAction = load
        self.storeAction = store
        return self
    }
}
