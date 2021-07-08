//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import UIKit
import LilySwift

class PageController 
{
    var vcm = LLViewControllerManager()
    
    func start( on window:UIWindow? ) {
        window?.backgroundColor = .white
        window?.rootViewController = vcm.root( MyViewController() )
        window?.makeKeyAndVisible()
    }
    
    static func manager( of view:UIView ) -> LLViewControllerManager? {
        guard let d = view.window?.windowScene?.delegate as? SceneDelegate else { return nil }
        return d.pageController.vcm
    }
}
