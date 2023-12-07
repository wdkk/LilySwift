//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import UIKit
import LilySwift

class PageController 
{
    var vcm = Lily.View.VCManager()
    
    func start( on window:UIWindow? ) {
        // trait変更時に適用する関数の登録
        vcm.traitChanged = checkColorMode
        // 初期化時カラーモードのチェック
        checkColorMode()
           
        window?.rootViewController = vcm.root( DevViewController() )
        
        window?.makeKeyAndVisible()
    }
    
    static func manager( of view:UIView ) -> Lily.View.VCManager? {
        guard let d = view.window?.windowScene?.delegate as? SceneDelegate else { return nil }
        return d.pageController.vcm
    }
        
    private func checkColorMode() {        
        // 現在のビューコントローラがLily配属のオブジェクトの場合、再描画
        (vcm.current as? Lily.View.ViewController)?.rebuild()
    }
}
