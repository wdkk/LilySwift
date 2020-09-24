//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

open class LLViewController : UIViewController
{        
    public private(set) var already:Bool = false
    private var _display_link:CADisplayLink?
    
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
        self.view = LLView()
    }
    
    fileprivate var _old_size:LLSize = .zero
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let setup_result = { () -> Bool in
            if already { return false }
            self.preSetup()
            self.setup()
            self.postSetup()
            CATransaction.stop { self.rebuild() }
            already = true
            return true
        }()
        
        if !setup_result && (_old_size.width != self.width || _old_size.height != self.height) {
            _old_size = LLSize( self.width, self.height )
            rebuild()
        }
        
        self.view.layoutIfNeeded()
    }
    
    open override func viewDidAppear( _ animated: Bool ) {
        super.viewDidAppear( animated )
        
        if let prnt = self.parent { view.rect = prnt.view.bounds.llRect }

        if already { rebuild() }
    }
    
    open override func viewDidDisappear( _ animated: Bool ) {
        self.endUpdating()
        super.viewDidDisappear( animated )
        teardown()
    }
    
    open func rebuild() {
        // viewが出来上がっていないときはbuildしない
        guard let v = self.view else { return }
        if v.width == 0.0 || v.height == 0.0 { return }
            
        self.preBuildup()
        self.buildup()
        self.postBuildup()
    }

    // MARK: - Display Linkでのポーリング処理
    @objc 
    public func viewUpdate( _ displayLink:CADisplayLink ) {
        preUpdate()
        update()
        postUpdate()
    }
        
    open func startUpdating() {
        if _display_link != nil { return }
        _display_link = CADisplayLink( target: self, 
                                       selector: #selector( LLViewController.viewUpdate(_:) ) )
        _display_link?.preferredFramesPerSecond = 60
        _display_link?.add( to: RunLoop.current, forMode: RunLoop.Mode.common )
    }
    
    open func endUpdating() {
        if _display_link == nil { return }
        _display_link?.remove( from: RunLoop.current, forMode: RunLoop.Mode.common )
        _display_link = nil
    }
    
    open func preSetup() {
    
    }
    
    open func setup() {
        
    }
    
    open func postSetup() {

    }
    
    open func preBuildup() {
        
    }
    
    open func buildup() {
        if let llview = self.view as? LLView {
            llview.rebuild()
        }
    }
    
    open func postBuildup() {
        
    }
    
    open func teardown() {
        if let llview = self.view as? LLView {
            llview.teardown()
        }
        
        already = false
    }

    open func preUpdate() {
    
    }
    
    open func update() {
        
    }
    
    open func postUpdate() {

    }
    

}

#endif
