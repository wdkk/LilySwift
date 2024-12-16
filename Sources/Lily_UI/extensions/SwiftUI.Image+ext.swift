//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import SwiftUI


extension SwiftUI.Image
{
    public init( llImage:LLImage ) {
        #if os(macOS)
        self.init( nsImage:llImage.nsImage! )
        #else
        self.init( uiImage:llImage.uiImage! )
        #endif
    }
}
