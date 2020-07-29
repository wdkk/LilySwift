//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
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

    open func rebuild() {
        self.buildup()
        self.postBuildup()
    }
    
    // NSView用
    open func addSubview(_ view:NSView ) {
        vcview.addSubview( view )
    }

    open func addSubview(_ view: NSView, positioned place: NSWindow.OrderingMode, relativeTo otherView: NSView? ) {
        vcview.addSubview( view, positioned: place, relativeTo: otherView )
    }   
    
    // CALayerベースLLView用
    open func addSubview(_ llView:LLView ) {
        vcview.addSubview( llView )
    }
    
    // MARK: - Override Pretty Functions
    open func setup() {
        
    }
    
    open func postSetup() {

    }
    
    open func buildup() {
        if let core = self.view as? LLUILifeEvent {
            core.rebuild()
        }
    }
    
    open func postBuildup() {
        
    }
    
    open func teardown() {
        if let core = self.view as? LLUILifeEvent {
            core.teardown()
        }
        
        _already = false
    }
        
    override open func loadView() {
        self.view = LLViewControllerView( vc:self )
    }
    
    override open func viewDidLoad() {
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
    
    open func viewUpdate() {

    }
    
    open func startUpdateLoop() {
        _dlink.loopFunc = self.viewUpdate
        _dlink.start()
    }
    
    open func endUpdateLoop() {
        _dlink.stop()
    }
}

#endif
