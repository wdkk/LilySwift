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
        // カラーセットのデフォルト色を決める
        setupDefaultColorStyle()
        
        // trait変更時に適用する関数の登録
        vcm.traitChanged = checkColorMode
        // 初期化時カラーモードのチェック
        checkColorMode()
        
        window?.backgroundColor = LLColorSet["view","background"].uiColor
        
        window?.rootViewController = vcm.root( DevViewController() )
        
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
    
    private func setupDefaultColorStyle() {
        // ボタン
        LLColorSet.set( uikey:"button", key:"background", hexes:( "#FFFFFF", "#212121" ) )
        LLColorSet.set( uikey:"button", key:"text", hexes:( "#00839a", "#00b9da" ) )
        LLColorSet.set( uikey:"button", key:"text-active", hexes:( "#00b9da", "#00839a" ) )
        LLColorSet.set( uikey:"button", key:"border", hexes:( "#00839a", "#00b9da" ) )
        LLColorSet.set( uikey:"button", key:"border-active", hexes:( "#00b9da", "#00839a" ) )
        
        // テキストフィールド
        LLColorSet.set( uikey:"text-field", key:"background", hexes:( "#FFFFFF", "#212121" ) )
        LLColorSet.set( uikey:"text-field", key:"text", hexes:( "#223344", "#DDEEFF" ) )
        LLColorSet.set( uikey:"text-field", key:"border", hexes:( "#667788", "#DDEEFF" ) )
        LLColorSet.set( uikey:"text-field", key:"placeholder", hexes:( "#999999", "#888888" ) )
    }
}
