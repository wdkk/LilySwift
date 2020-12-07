//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import UIKit
import LilySwift

class SceneDelegate : UIResponder, UIWindowSceneDelegate 
{    
    var window: UIWindow?
    var session:UISceneSession?
    var vcm = LLViewControllerManager()
    var vc = MyViewController()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions )
    {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow( windowScene: scene )
        self.session = session
        
        scene.windowMinSizeForCatalyst( LLSize( 768, 1044 ) )
        scene.windowMaxSizeForCatalyst( LLSize( 768, 1044 ) )
    
        /*
        // trait変更時に適用する関数の登録
        vcm.traitChanged = checkColorMode
        // 初期化時カラーモードのチェック
        checkColorMode()
        */
        
        window?.rootViewController = vcm.root( vc )
        window?.makeKeyAndVisible()
    }
        
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return scene.userActivity
    }

    /*
    private func checkColorMode() {

    }
    */
    
    func sceneWillResignActive(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {

    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }
}
