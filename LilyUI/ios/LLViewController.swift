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
    private var _already:Bool = false
    public var already:Bool { _already }
    private var _display_link:CADisplayLink?
    
    /// コンストラクタ
    required public init?( coder aDecoder: NSCoder ) { super.init( coder:aDecoder ) }
    public init() { 
        super.init( nibName: nil, bundle: nil ) 
    }

    /// デストラクタ
    deinit {
        _already = false
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
            if _already { return false }
            self.setup()
            self.postSetup()
            CATransaction.stop { self.rebuild() }
            _already = true
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

        if _already { rebuild() }
    }
    
    open override func viewDidDisappear( _ animated: Bool ) {
        self.endUpdateLoop()
        super.viewDidDisappear( animated )
        teardown()
    }
    
    open func rebuild() {
        // viewが出来上がっていないときはbuildしない
        guard let v = self.view else { return }
        if v.width == 0.0 || v.height == 0.0 { return }
            
        self.buildup()
        self.postBuildup()
    }

    // MARK: - Display Linkでのポーリング処理
    @objc 
    private func _viewUpdate( _ displayLink:CADisplayLink ) {
        viewUpdate()
    }
    
    open func viewUpdate() {
    
    }
    
    open func startUpdateLoop() {
        if _display_link != nil { return }
        _display_link = CADisplayLink( target: self, 
                                       selector: #selector( LLViewController._viewUpdate(_:) ) )
        _display_link?.add( to: RunLoop.current, forMode: RunLoop.Mode.common )
    }
    
    open func endUpdateLoop() {
        if _display_link == nil { return }
        _display_link?.remove( from: RunLoop.current, forMode: RunLoop.Mode.common )
        _display_link = nil
    }
    
    open func setup() {
        
    }
    
    open func postSetup() {

    }
    
    open func buildup() {
        if let core = self.view as? LLView {
            core.rebuild()
        }
    }
    
    open func postBuildup() {
        
    }
    
    open func teardown() {
        if let core = self.view as? LLView {
            core.teardown()
        }
        
        _already = false
    }
}

#endif
