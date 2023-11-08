//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(visionOS)

import UIKit

extension Lily.View
{
    open class VCManager
    : UIViewController
    {
        fileprivate var extraObjects = [String:Any]()
        
        open private(set) var current:UIViewController?
        open private(set) var preview:UIViewController?
        
        public required init?( coder aDecoder: NSCoder ) { super.init( coder:aDecoder ) }
        public init() {
            super.init( nibName: nil, bundle: nil )
            self.view.backgroundColor = .white
        }
        
        open override func viewDidAppear( _ animated:Bool ) {
            super.viewDidAppear( animated )
            
            updateRect( of:current )
            
            self.readyNotificationByOrientation()
        }
        
        private func updateRect( of vc:UIViewController? ) {
            vc?.view.rect = LLRect( 0, 0, self.width, self.height )
        }
    }
}
// MARK: - ステータスバー
public extension Lily.View.VCManager
{
    override var prefersStatusBarHidden:Bool {
        return !statusBarVisible
    }
    
    var statusBarVisible:Bool { 
        get {
            guard let visible = self.extraObjects["statusBarVisible"] as? Bool else { return true }
            return visible
        }
        set {
            self.extraObjects["statusBarVisible"] = newValue
            // TODO: visionOS無効対応
#if os(iOS)
            setNeedsStatusBarAppearanceUpdate() 
#endif
        } 
    }
}

// MARK: - オリエンテーション
public extension Lily.View.VCManager
{
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask { return .all }
    
    func readyNotificationByOrientation() {
        // TODO: visionOS無効対応
#if os(iOS)
        NotificationCenter.default.addObserver( self, 
                                                selector: #selector( Self.changeOrientation(notification:) ),
                                                name: UIDevice.orientationDidChangeNotification,
                                                object: nil )
#endif
    }
    
    @objc func changeOrientation( notification: NSNotification ) {
        updateRect( of: current )
    }
}

// MARK: - デバイス回転制御
public extension Lily.View.VCManager
{
    override var shouldAutorotate:Bool { return _autorotated }
    
    private var _autorotated:Bool {
        get {
            guard let rotated = self.extraObjects["autorotated"] as? Bool else { return true }
            return rotated
        }
        set {
            self.extraObjects["autorotated"] = newValue
        } 
    }
}

// MARK: - Trait制御
public extension Lily.View.VCManager
{
    override func traitCollectionDidChange( _ previousTraitCollection: UITraitCollection? ) {
        super.traitCollectionDidChange( previousTraitCollection )
        traitChanged?()
    }

    var traitChanged:(()->())? {
        get {
            self.extraObjects["traitChanged"] as? (()->())
        }
        set {
            self.extraObjects["traitChanged"] = newValue
        } 
    }
}


// MARK: - トランジション
public extension Lily.View.VCManager
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
                    start:@escaping Lily.View.TransitionFunction = { _,_ in },
                    end:@escaping Lily.View.TransitionFunction = { _,_ in },
                    completion:@escaping Lily.View.TransitionFunction = { _,_ in } ) 
    {  
        if let current = self.current {
            // lock rotation
            _autorotated = false
            
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
                
                self?.current?.willMove( toParent: nil )
                self?.current?.removeFromParent()
                vc.didMove( toParent: self )
                
                self?.preview = self?.current
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
    func transition( to vc:UIViewController, animator:Lily.View.TransitionAnimator ) {
        self.transition(to: vc, 
                        duration: animator.duration, 
                        options: animator.options,
                        start: animator.start, 
                        end: animator.end, 
                        completion: animator.completion )
    }
}

#endif
