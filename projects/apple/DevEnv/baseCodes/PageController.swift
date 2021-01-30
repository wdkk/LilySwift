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
        // trait変更時に適用する関数の登録
        vcm.traitChanged = checkColorMode
        // 初期化時カラーモードのチェック
        checkColorMode()
        
        window?.backgroundColor = LLColorSet["view","background"].uiColor
        window?.rootViewController = vcm.root( MyViewController() )
        window?.makeKeyAndVisible()
    }
    
    static func manager( of view:UIView ) -> LLViewControllerManager? {
        #if IOS11_LEGACY
        guard let d = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return d.pageController.vcm
        #else
        guard let d = view.window?.windowScene?.delegate as? SceneDelegate else { return nil }
        return d.pageController.vcm
        #endif
    }
    
    private func checkColorMode() {
        // カラーセットのライトモード/ダークモードの切り替え
        #if swift(>=5.1)
        if #available(iOS 13, *) {
            switch UITraitCollection.current.userInterfaceStyle {
            case .dark:  LLColorSet.type = .dark
            case .light: LLColorSet.type = .light
            case .unspecified: LLColorSet.type = .light
            @unknown default: LLColorSet.type = .light
            }
        }
        else {
            LLColorSet.type = .light
        }
        #else
        LLColorSet.type = .light
        #endif
        
        // 現在のビューコントローラがLily配属のオブジェクトの場合、再描画
        if let vc = vcm.current as? LLViewController {
            vc.rebuild()
        }
        
        vcm.view?.backgroundColor = LLColorSet["view","background"].uiColor
    }
}
