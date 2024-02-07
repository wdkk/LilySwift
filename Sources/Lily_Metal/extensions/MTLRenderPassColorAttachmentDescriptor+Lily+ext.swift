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

extension MTLRenderPassColorAttachmentDescriptor
{
    @discardableResult
    public func clearColor( _ color:MTLClearColor ) -> Self {
        self.clearColor = color
        return self
    }
    
    @discardableResult
    public func clearColor( _ color:LLColor ) -> Self {
        self.clearColor = color.metalColor
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


