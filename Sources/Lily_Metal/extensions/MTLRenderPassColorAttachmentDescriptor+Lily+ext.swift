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

public extension MTLRenderPassColorAttachmentDescriptor
{
    @discardableResult
    func clearColor( _ color:MTLClearColor ) -> Self {
        self.clearColor = color
        return self
    }
    
    @discardableResult
    func clearColor( _ color:LLColor ) -> Self {
        self.clearColor = color.metalColor
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


