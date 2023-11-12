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
        // TODO: カラーセットの処理はSwiftUIに合わせて見直し
        // カラーセットのデフォルト色を決める
        //setupDefaultColorStyle()
        
        // trait変更時に適用する関数の登録
        vcm.traitChanged = checkColorMode
        // 初期化時カラーモードのチェック
        checkColorMode()
        
        // TODO: カラーセットの処理はSwiftUIに合わせて見直し
        //window?.backgroundColor = Lily.View.ColorSet.shared["view","background"].uiColor
        
        window?.rootViewController = vcm.root( DevViewController() )
        
        window?.makeKeyAndVisible()
    }
    
    static func manager( of view:UIView ) -> Lily.View.VCManager? {
        guard let d = view.window?.windowScene?.delegate as? SceneDelegate else { return nil }
        return d.pageController.vcm
    }
        
    private func checkColorMode() {
        // TODO: カラーセットの処理はSwiftUIに合わせて見直し
        /*
        // カラーセットのライトモード/ダークモードの切り替え
        switch UITraitCollection.current.userInterfaceStyle {
        case .dark: Lily.View.ColorSet.shared.type = .dark
        case .light: Lily.View.ColorSet.shared.type = .light
        case .unspecified: Lily.View.ColorSet.shared.type = .light
        @unknown default: Lily.View.ColorSet.shared.type = .light
        }
        */
        
        // 現在のビューコントローラがLily配属のオブジェクトの場合、再描画
        (vcm.current as? Lily.View.ViewController)?.rebuild()
         
        // TODO: カラーセットの処理はSwiftUIに合わせて見直し
        //vcm.view?.backgroundColor = Lily.View.ColorSet.shared["view","background"].uiColor
    }
    
    /*
    private func setupDefaultColorStyle() {
        // TODO: カラーセットの処理はSwiftUIに合わせて見直し
        // ボタン
        Lily.View.ColorSet.shared.set( uikey:"button", key:"background", hexes:( "#FFFFFF", "#212121" ) )
        Lily.View.ColorSet.shared.set( uikey:"button", key:"text", hexes:( "#00839a", "#00b9da" ) )
        Lily.View.ColorSet.shared.set( uikey:"button", key:"text-active", hexes:( "#00b9da", "#00839a" ) )
        Lily.View.ColorSet.shared.set( uikey:"button", key:"border", hexes:( "#00839a", "#00b9da" ) )
        Lily.View.ColorSet.shared.set( uikey:"button", key:"border-active", hexes:( "#00b9da", "#00839a" ) )
        
        // テキストフィールド
        Lily.View.ColorSet.shared.set( uikey:"text-field", key:"background", hexes:( "#FFFFFF", "#212121" ) )
        Lily.View.ColorSet.shared.set( uikey:"text-field", key:"text", hexes:( "#223344", "#DDEEFF" ) )
        Lily.View.ColorSet.shared.set( uikey:"text-field", key:"border", hexes:( "#667788", "#DDEEFF" ) )
        Lily.View.ColorSet.shared.set( uikey:"text-field", key:"placeholder", hexes:( "#999999", "#888888" ) )
    }
    */
}
