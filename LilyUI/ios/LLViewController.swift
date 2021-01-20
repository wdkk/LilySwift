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
                
        if !already {
            self.preSetup()
            self.setup()
            self.postSetup()
            // TODO: iOS11対応でsetup時のbuildup呼び出しを停止した.
            // 今後問題が起きるようであれば復帰させ、iOS11対応を廃止する > iOS13にする
            //CATransaction.stop { self.rebuild() }
            already = true
        }
        else if _old_size.width != self.width || _old_size.height != self.height {
            _old_size = LLSize( self.width, self.height )
            // TODO: iOS11対応でLLViewの初期化サイズを(1,1)としたので、それ以上の場合buildupを呼ぶようにする
            if self.width > 1 || self.height > 1 {
                rebuild()
            }
        }
        
        self.view.layoutIfNeeded()
    }
    
    open override func viewDidDisappear( _ animated: Bool ) {
        self.endLooping()
        super.viewDidDisappear( animated )
        teardown()
    }
    
    var _mutex = LLRecursiveMutex()
    open func rebuild() {
        // viewが出来上がっていないときはbuildしない
        guard let v = self.view else { return }
        if v.width == 0.0 || v.height == 0.0 { return }
        
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }

    // MARK: - Display Linkでのポーリング処理
    @objc 
    private func _viewLoop( _ displayLink:CADisplayLink ) {
        viewLoop()
    }
    
    open func viewLoop() {
        preLoop()
        loop()
        postLoop()    
    }
        
    open func startLooping() {
        if _display_link != nil { return }
        _display_link = CADisplayLink( target: self, 
                                       selector: #selector( LLViewController._viewLoop(_:) ) )
        _display_link?.preferredFramesPerSecond = 60
        _display_link?.add( to: RunLoop.current, forMode: RunLoop.Mode.common )
    }
    
    open func endLooping() {
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

    }
    
    open func postBuildup() {
        if let life_event_ui = self.view as? LLUILifeEvent {
            life_event_ui.rebuild()
        }
    }
    
    open func teardown() {
        if let life_event_ui = self.view as? LLUILifeEvent {
            life_event_ui.teardown()
        }
        already = false
    }

    open func preLoop() {
    
    }
    
    open func loop() {
        
    }
    
    open func postLoop() {

    }
}

#endif
