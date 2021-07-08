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

class SceneDelegate : UIResponder, UIWindowSceneDelegate 
{    
    var window: UIWindow?
    var session:UISceneSession?
    var pageController = PageController()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, 
               options connectionOptions: UIScene.ConnectionOptions )
    {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        self.window = UIWindow( windowScene: scene )
        self.session = session
        
        scene.windowMinSizeForCatalyst( LLSize( 768, 1044 ) )
        scene.windowMaxSizeForCatalyst( LLSize( 768, 1044 ) )
    
        pageController.start( on:window )
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
