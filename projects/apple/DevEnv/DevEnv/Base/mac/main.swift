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
import AppKit

autoreleasepool
{
    let app = Application.shared as! Application
    app.delegate = app
    app.setActivationPolicy( .regular )
    app.run()
}

exit(0)
