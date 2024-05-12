//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(tvOS) || os(visionOS)

import UIKit

public extension UIWindowScene
{
    func windowMinSizeForCatalyst( _ size:LLSize ) {
        #if targetEnvironment(macCatalyst)
        self.sizeRestrictions?.minimumSize = size.cgSize
        #endif
    }
    
    func windowMaxSizeForCatalyst( _ size:LLSize ) {
        #if targetEnvironment(macCatalyst)
        self.sizeRestrictions?.maximumSize = size.cgSize
        #endif
    }
}

#endif
