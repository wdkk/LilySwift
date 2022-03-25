//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

public protocol LLUILifeEvent : AnyObject
{
    var isUserInteractionEnabled:Bool { get set }   // UIView, NSViewの変数のプロパティを必須とする
    
    var _mutex:LLRecursiveMutex { get set }
    
    var setupField:LLViewFieldMap { get set }
    var buildupField:LLViewFieldMap { get set }
    var teardownField:LLViewFieldMap { get set }
        
    var styleField:LLViewStyleFieldMap { get set }
    var layoutField:LLField? { get set }
    
    /// UIの準備サイクル
    func preSetup()
    func setup()
    func postSetup()
    
    /// UIの構築/再構築サイクル
    func preBuildup()
    func buildup()
    func postBuildup()
    
    /// UIの取り壊しサイクル
    func teardown()
    
    /// buildup系の総合関数. buidupシリーズは直接呼ばず、rebuildを使うこと
    func rebuild()
    
    /// プロトコルを持つ場合、小要素のrebuildとteardownを処理する関数を用意する
    func rebuildChildren()
    func teardownChildren()
}

extension LLUILifeEvent
{
    public func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    public var isEnabled:Bool {
        get { return self.isUserInteractionEnabled }
        set { 
            self.isUserInteractionEnabled = newValue
            self.rebuild()
        }    
    }
    
    public func layout<TCaller:AnyObject, TView:AnyObject>(
        caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView)->Void
    )
    {
        layoutField = LLTalkingField<TCaller, TView, Any>(
            caller:caller,
            me:view,
            action:f 
        )
    }
    
    public func lifeEventDefaultSetup() { 
        self.setupField.appear( LLEmpty.none )
    }
    
    public func lifeEventDefaultBuildup() { 
        self.layoutField?.appear()
        
        self.styleField.default?.appear() 
        if !isEnabled { self.styleField.disable?.appear() }

        self.buildupField.appear( LLEmpty.none )
        
        self.rebuildChildren()
    }
    
    public func lifeEventDefaultTeardown() { 
        self.teardownField.appear( LLEmpty.none )
        self.teardownChildren()
    }
}
