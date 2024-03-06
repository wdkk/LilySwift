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
    open class ViewController
    : UIViewController
    {        
        public private(set) var already:Bool = false
        private var _display_link:CADisplayLink?
        private var lastFrameTimestamp: CFTimeInterval = 0
        lazy var frameRate: Double = 60.0
        lazy var frameInterval: Double = 1.0 / frameRate
        
        /// コンストラクタ
        required public init?( coder aDecoder: NSCoder ) { super.init( coder:aDecoder ) }
        public init() { 
            super.init( nibName: nil, bundle: nil )
        }
        
        /// デストラクタ
        deinit {
            already = false
            self.view = nil
        }
        
        open override func viewDidLoad() {
            super.viewDidLoad()
            self.view = BaseView()
        }
        
        fileprivate var _old_size:LLSize = .zero
        
        open override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            
            if !already {
                self.callSetupPhase()
            }
            else if _old_size.width != self.width || _old_size.height != self.height {
                _old_size = LLSize( self.width, self.height )
                rebuild()
            }
            
            self.view.layoutIfNeeded()
        }
        
        open override func viewDidDisappear( _ animated: Bool ) {
            self.endLooping()
            super.viewDidDisappear( animated )
            self.callTeardownPhase()
        }
        // MARK: - Display Linkでのポーリング処理
        @objc
        private func _viewLoop( _ displayLink:CADisplayLink ) { 
            if !self.already { return }
            
            func now() -> Double {
                var now_time = timeval()
                var tzp = timezone()
                gettimeofday( &now_time, &tzp )
                return Double( LLInt64( now_time.tv_sec * 1_000_000 ) + LLInt64( now_time.tv_usec ) ) / 1_000_000.0
            }
            
            while true {
                let currentTimestamp = now()
                let elapsedTime = currentTimestamp - lastFrameTimestamp

                if elapsedTime >= frameInterval { 
                    lastFrameTimestamp = currentTimestamp
                    break
                }
                
                Thread.sleep( forTimeInterval: 1.0 / 10_000.0 )
            }
            
            loop() 
        }
        
        open func loop() {}
        
        open func startLooping() {
            if _display_link != nil {
                _display_link?.isPaused = false
                return
            }
            
            _display_link = CADisplayLink(
                target: self, 
                selector: #selector( ViewController._viewLoop(_:) ) 
            )
        
            _display_link?.preferredFramesPerSecond = 60
            _display_link?.add( to: .current, forMode: .default )
        }

        open func pauseLooping() {
            if _display_link == nil { return }
            _display_link?.isPaused = true
        }
        
        open func endLooping() {
            if _display_link == nil { return }
            _display_link?.remove( from:.current, forMode:.default )
            _display_link = nil
        }
        
        private var _mutex = RecursiveMutex()
        
        open func rebuild() { self.callBuildupPhase() }
        
        open func setup() {}
        
        open func buildup() {}
        
        open func teardown() {}
        
        final public func callSetupPhase() {
            self.setup()
            CATransaction.stop { self.rebuild() }
            already = true
        }
        
        final public func callBuildupPhase() {
            // viewが出来上がっていないときはbuildしない
            guard let v = self.view else { return }
            if v.width == 0.0 || v.height == 0.0 { return }
            already = true
            
            _mutex.lock {
                self.buildup()
                (self.view as? LLUILifeEvent)?.rebuild()
            }
        }
        
        final public func callTeardownPhase() {
            (self.view as? LLUILifeEvent)?.callTeardownPhase()
            teardown()
            already = false 
        }
    }
}

public extension Lily.View.ViewController
{
    func addSubview( _ v:UIView ) {
        self.view?.addSubview( v )
    }
}

#endif
