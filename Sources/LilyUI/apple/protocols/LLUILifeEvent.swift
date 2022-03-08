//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import CoreGraphics

public protocol LLUILifeEvent
{
    var isUserInteractionEnabled:Bool { get set }   // UIView, NSViewの変数のプロパティを必須とする
    
    var _mutex:LLRecursiveMutex { get set }
    
    var setupField:LLViewFieldMap { get set }
    var buildupField:LLViewFieldMap { get set }
    var teardownField:LLViewFieldMap { get set }
        
    var styleField:LLViewStyleFieldMap { get set }
    
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
    
    /// Field
    func callSetupFields()
   
    func callBuildupFields()
     
    func callTeardownFields()
}

extension LLUILifeEvent
{    
    public func callSetupFields() {
        self.setupField.appear( LLEmpty.none )
    }
    
    public func callBuildupFields() {
        self.buildupField.appear( LLEmpty.none )
    }
    
    public func callTeardownFields() {
        self.teardownField.appear( LLEmpty.none )
    }
    
    public func callViewStyleFields() {
        self.styleField.appear( LLEmpty.none )
    }
}

extension LLUILifeEvent
{
    public var isEnabled:Bool {
        get { return self.isUserInteractionEnabled }
        set { 
            self.isUserInteractionEnabled = newValue
            self.rebuild()
        }    
    }
}
