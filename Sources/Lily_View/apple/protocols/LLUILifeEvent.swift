//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public protocol LLUILifeEvent 
: AnyObject
{
    var isUserInteractionEnabled:Bool { get set }   // UIView, NSViewの変数のプロパティを必須とする
    
    var _mutex:Lily.View.RecursiveMutex { get set }
    
    var setupField:(any LLField)? { get set }
    var buildupField:(any LLField)? { get set }
    var teardownField:(any LLField)? { get set }

    /// UIの準備サイクル
    func setup()
    /// UIの構築/再構築サイクル
    func buildup()
    /// UIの取り壊しサイクル
    func teardown()
    
    /// 各サイクルのデフォルト挙動
    func callSetupPhase()
    func callBuildupPhase()
    func callTeardownPhase()
  
    /// buildup系の総合関数. buidupシリーズは直接呼ばず、rebuildを使うこと
    func rebuild()
    
    /// プロトコルを持つ場合、小要素のrebuildとteardownを処理する関数を用意する
    func rebuildChildren()
    func teardownChildren()
}

extension LLUILifeEvent
{
    public func rebuild() { self.callBuildupPhase() }
    
    public var isEnabled:Bool { self.isUserInteractionEnabled }
    
    public func isEnabled( _ torf:Bool ) -> Self {
        self.isUserInteractionEnabled = torf
        self.rebuild()
        return self
    }
    
    public func callSetupPhase() {
        self.setup()
        self.setupField?.appear()
    }
    
    public func callBuildupPhase() {
        _mutex.lock {
            self.buildup()
            self.buildupField?.appear()
            self.rebuildChildren()
        }
    }
    
    public func callTeardownPhase() {
        self.teardownChildren()
        self.teardownField?.appear()
        self.teardown()        
    }
}

extension LLUILifeEvent
{
    public func setup( _ field:@escaping (Self)->Void )
    -> Self
    {
        setupField = Lily.Field.LifeCycle(
            me:self,
            action:field
        )
        return self
    }
    
    public func setup<TCaller:AnyObject>( caller:TCaller, _ field:@escaping (Self, TCaller)->Void )
    -> Self
    {
        setupField = Lily.Field.LifeCycle(
            me:self,
            caller:caller,
            action:field
        )
        return self
    }
    
    public func buildup( _ field:@escaping (Self)->Void )
    -> Self
    {
        buildupField = Lily.Field.LifeCycle(
            me:self,
            action:field
        )
        return self
    }
    
    public func buildup<TCaller:AnyObject>( caller:TCaller, _ field:@escaping (Self, TCaller)->Void )
    -> Self
    {
        buildupField = Lily.Field.LifeCycle(
            me:self,
            caller:caller,
            action:field
        )
        return self
    }
    
    public func teardown( _ field:@escaping (Self)->Void )
    -> Self
    {
        teardownField = Lily.Field.LifeCycle(
            me:self,
            action:field
        )
        return self
    }
    
    public func teardown<TCaller:AnyObject>( caller:TCaller, _ field:@escaping (Self, TCaller)->Void )
    -> Self
    {
        teardownField = Lily.Field.LifeCycle(
            me:self,
            caller:caller,
            action:field
        )
        return self
    }
}
