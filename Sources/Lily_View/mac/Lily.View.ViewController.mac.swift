//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import AppKit
import QuartzCore

extension Lily.View
{
    open class ViewController
    : NSViewController
    {
        public private(set) var already:Bool = false
        private var _dlink = DisplayLink()
        
        public init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        public required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        deinit {
            already = false
        }
        
        open var vcview:VCView { return self.view as! VCView }
        
        var _mutex = Lily.View.RecursiveMutex()
        
        override open func loadView() {
            self.view = VCView( vc:self )
        }
        
        override open func viewDidLoad() {
            callSetupPhase()
        }
        
        override open func viewWillLayout() {
            if isViewLoaded {
                already = true
                rebuild()
            }
        }
        
        override open func viewDidAppear() {
            
        }
        
        override open func viewWillDisappear() {
            
        }
        
        // NSView用
        open func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode = .above, relativeTo otherView: NSView? = nil ) {
            (view as? LLUILifeEvent)?.callSetupPhase()
            vcview.addSubview( view, positioned: place, relativeTo: otherView )
        }   
        
        open func addSubview<TView:NSControl>(_ view:TView ) {
            (view as? LLUILifeEvent)?.callSetupPhase()
            vcview.addSubview( view )
        }
        
        // CALayerベースBaseView用
        open func addSubview<TView:BaseView>(_ lilyView:TView ) {
            vcview.addSubview( lilyView )
        }
        
        // MARK: - Override Pretty Functions
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
            let v = self.view 
            if v.width == 0.0 || v.height == 0.0 { return }
            
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
        
        open func viewLoop() {
            autoreleasepool {
                loop()
            }
        }
        
        open func loop() {}
        
        open func startLooping() {
            _dlink.loopFunc = self.viewLoop
            _dlink.start()
        }
        
        open func endLooping() {
            _dlink.stop()
        }
    }
}

#endif
