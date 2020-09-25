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

import Foundation
import Cocoa
import QuartzCore

open class LLView : CALayer, LLUILifeEvent
{ 
    public lazy var setupField = LLViewFieldMap()
    public lazy var designField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
   
    open var available:Bool = true
        
    public var center:CGPoint { ourCenter }
    
    func initViewAttributes() {
        self.anchorPoint = CGPoint(x:0.5, y:0.5)
        self.masksToBounds = false
        self.contentsScale = LLSystem.retinaScale.cgf
    }
   
    open var alpha:CGFloat {
        get { return self.opacity.cgf }
        set { self.opacity = newValue.f }
    }
    
    open func addSubview(_ llview:LLView ) { self.addSublayer( llview ) }
    
    open func addSubview(_ view:NSView ) { self.addSublayer( view.layer! ) }
    
    required public init?(coder decoder: NSCoder) { super.init(coder:decoder) }
    public override init() {
        super.init()
        self.initViewAttributes()
        self.minificationFilter = .nearest
        self.magnificationFilter = .nearest
        preSetup()
        setup()
        postSetup()
    }
    
    public override init( layer: Any ) {
        super.init(layer:layer)
        self.initViewAttributes()
        self.minificationFilter = .nearest
        self.magnificationFilter = .nearest
        preSetup()
        setup()
        postSetup()
    }
        
    public func preSetup() { }
    
    public func setup() { }
    
    public func postSetup() { }
    
    public func preBuildup() { }
    
    public func buildup() { }
    
    public func postBuildup() {
        self.callDesignFunction()
        
        if let sublayers = self.sublayers {
            for child in sublayers {
                if let llui = child as? LLUILifeEvent { llui.rebuild() }
            }
        }
    }
    
    public func teardown() {
        self.callDissetupFunction()
        
        if let sublayers = self.sublayers {
            for child in sublayers {
                if let llui = child as? LLUILifeEvent { llui.teardown() }
            }
        }
    }
    
    var _mutex = LLRecursiveMutex()
    public func rebuild() {
        _mutex.lock {
            self.preBuildup()
            self.buildup()
            self.postBuildup()
        }
    }
    
    // Viewのピック処理. ignitionの発火はLLViewControllerViewで全管理しているのでお任せ
    open func pick( _ global_pt: LLPoint ) -> ( view:LLView?, local_pt:LLPoint ) {
        // 子レイヤーたちを先にあたる。該当があればそのViewを返して処理終了
        if sublayers != nil {
            let sorted_sublayers = sublayers!.sorted { ( l1:CALayer, l2:CALayer ) -> Bool in
                return l1.zPosition > l2.zPosition
            }.reversed()
            
            for layer in sorted_sublayers {
                if !(layer is LLView) { continue }
                let result = (layer as! LLView).pick( global_pt )
                if result.view != nil { return result }
            }
        }
        
        let local_pt = self.convert( global_pt.cgPoint, from: nil ).llPoint
        // 非表示・無効のViewは無視
        if isHidden || !available { return ( nil, global_pt ) }
        // 範囲チェック
        if local_pt.x < 0.0 || width < local_pt.x || local_pt.y < 0.0 || height < local_pt.y {
            return ( nil, global_pt )
        }
        // 範囲内であれば自身を返す
        return ( self, local_pt )
    }
}

extension LLView
{
    public func callAssembleFunction() {
        self.setupField.appear( LLEmpty.none )
    }
    
    public func callDesignFunction() {
        self.designField.appear( LLEmpty.none )
    }
    
    public func callDissetupFunction() {
        self.teardownField.appear( LLEmpty.none )
    }
}

#endif
