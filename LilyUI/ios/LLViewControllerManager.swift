//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

open class LLViewControllerManager : UIViewController
{
    fileprivate var ext_objects = [String:Any]()
    
    open private(set) weak var current:UIViewController?
    
    public required init?( coder aDecoder: NSCoder ) { super.init( coder:aDecoder ) }
    public init() {
        super.init( nibName: nil, bundle: nil )
        self.view.backgroundColor = .white
    }
    
    open override func viewDidAppear( _ animated:Bool ) {
        super.viewDidAppear( animated )
        
        updateRect( of: current )
        
        self.readyNotificationByOrientation()
    }
        
    private func updateRect( of vc:UIViewController? ) {
        guard let target_vc = vc else { return }
        target_vc.view.rect = LLRect( 0, 0, self.width, self.height )
    }
}

// MARK: - ステータスバー
public extension LLViewControllerManager
{
    override var prefersStatusBarHidden:Bool {
        return !statusBarVisible
    }
    
    var statusBarVisible:Bool { 
        get {
            guard let visible = self.ext_objects["statusBarVisible"] as? Bool else { return true }
            return visible
        }
        set {
            self.ext_objects["statusBarVisible"] = newValue
            setNeedsStatusBarAppearanceUpdate() 
        } 
    }
}

// MARK: - オリエンテーション
public extension LLViewControllerManager
{
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask { return .all }
    
    func readyNotificationByOrientation() {
        NotificationCenter.default.addObserver( self, 
            selector: #selector( LLViewControllerManager.changeOrientation(notification:) ),
                                 name: UIDevice.orientationDidChangeNotification,
                                 object: nil )
    }
    
    @objc func changeOrientation( notification: NSNotification ) {
        updateRect( of: current )
    }
}

// MARK: - デバイス回転制御
public extension LLViewControllerManager
{
    override var shouldAutorotate:Bool { return _autorotated }
    
    private var _autorotated:Bool {
        get {
            guard let rotated = self.ext_objects["autorotated"] as? Bool else { return true }
            return rotated
        }
        set {
            self.ext_objects["autorotated"] = newValue
        } 
    }
}

// MARK: - Trait制御
public extension LLViewControllerManager
{
    override func traitCollectionDidChange( _ previousTraitCollection: UITraitCollection? ) {
        super.traitCollectionDidChange( previousTraitCollection )
        traitChanged?()
    }
    
    var traitChanged:(()->())? {
        get {
            guard let visible = self.ext_objects["traitChanged"] as? (()->()) else { return nil }
            return visible
        }
        set {
            self.ext_objects["traitChanged"] = newValue
        } 
    }
}

// MARK: - トランジション
public extension LLViewControllerManager
{
    /// Transitionイベント関数のオーバーライド
    override func viewWillTransition( to size:CGSize, with coordinator:UIViewControllerTransitionCoordinator ) {
        super.viewWillTransition( to: size, with: coordinator )

        // マルチタスキングでのサイズ変更を拾いつつ、回転などでのサイズ変更もVCへ通知する
        coordinator.animate(
            alongsideTransition: { _ in
                if let current = self.current { self.updateRect( of: current ) }
            },
            completion: { _ in
                
            } 
        )
    }
    
    func root( _ vc:UIViewController ) -> Self {
        current = vc
        self.addChild( vc )
        self.view.addSubview( vc.view )
        vc.didMove( toParent: vc )
        return self
    }
    
    func transition(to vc:UIViewController,
                         duration dtime:Float = 0.5,
                         options opts:UIView.AnimationOptions = [],
                         start:@escaping LLTransitionFunction = { _,_ in },
                         end:@escaping LLTransitionFunction = { _,_ in },
                         completion:@escaping LLTransitionFunction = { _,_ in } ) 
    {  
        if let current = self.current {
            // lock rotation
            _autorotated = false

            current.willMove( toParent: nil )
            self.addChild( vc )

            start( current, vc ) 
        
            // View Transition Process
            self.transition( from: current, to: vc, duration: dtime.d, options: opts,
            animations: { [weak self] in 
                // 重要: updateRectはこの位置で決まり. 回転とトランジションを両立させるため
                self?.updateRect( of: vc )
                end( current, vc )
            },
            completion: { [weak self] _ in
                completion( current, vc )
                                
                self?.current?.removeFromParent()
                vc.didMove( toParent: self )
                
                self?.current = vc
                // unlock rotation
                self?._autorotated = true
            })
        }
    }
    
    /// ViewControllerを遷移する
    /// - Parameters:
    ///  - vc: 遷移先のViewController
    ///  - animator: 遷移中のアニメーションオブジェクト
    func transition( to vc:UIViewController, animator:LLTransitionAnimator ) {
        self.transition(to: vc, 
                        duration: animator.duration, 
                        options: animator.options,
                        start: animator.start, 
                        end: animator.end, 
                        completion: animator.completion )
    }
}

#endif
