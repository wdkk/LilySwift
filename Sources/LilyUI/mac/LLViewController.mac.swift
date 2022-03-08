//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Cocoa
import QuartzCore

open class LLViewController : NSViewController
{
    private var _already:Bool = false
    public var already:Bool { _already }
    private var _dlink = LLDisplayLink()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        _already = false
    }
    
    open var vcview:LLViewControllerView { return self.view as! LLViewControllerView }

    var _mutex = LLRecursiveMutex()
    open func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    override open func loadView() {
        self.view = LLViewControllerView( vc:self )
    }
    
    override open func viewDidLoad() {
        preSetup()
        setup()
        postSetup()
    }

    override open func viewWillLayout() {
        if isViewLoaded {
            _already = true
            rebuild()
        }
    }
    
    override open func viewDidAppear() {
        
    }
    
    override open func viewWillDisappear() {
        
    }
    
    // NSView用
    open func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode, relativeTo otherView: NSView? ) {
        vcview.addSubview( view, positioned: place, relativeTo: otherView )
    }   
    
    open func addSubview(_ view:NSView ) {
        vcview.addSubview( view )
    }
    open func addSubview(_ viewChain:LLChain<NSView> ) {
        vcview.addSubview( viewChain.unchain )
    }

    // CALayerベースLLView用
    open func addSubview(_ llView:LLView ) {
        vcview.addSubview( llView )
    }
    open func addSubview(_ llViewChain:LLChain<LLView> ) {
        vcview.addSubview( llViewChain.unchain )
    }
    
    // MARK: - Override Pretty Functions
    open func preSetup() {
        
    }
    
    open func setup() {
        
    }
    
    open func postSetup() {

    }
    
    open func preBuildup() {
        
    }
    
    open func buildup() {

    }
    
    open func postBuildup() {
        if let core = self.view as? LLUILifeEvent {
            core.rebuild()
        }        
    }
    
    open func teardown() {
        if let core = self.view as? LLUILifeEvent {
            core.teardown()
        }
        
        _already = false
    }
    
    open func viewLoop() {
        preLoop()
        loop()
        postLoop()
    }
    
    open func preLoop() {

    }
    
    open func loop() {

    }
    
    open func postLoop() {

    }
        
    open func startLooping() {
        _dlink.loopFunc = self.viewLoop
        _dlink.start()
    }
    
    open func endLooping() {
        _dlink.stop()
    }
}

#endif
