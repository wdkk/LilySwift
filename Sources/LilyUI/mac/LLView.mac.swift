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

import Foundation
import Cocoa
import QuartzCore

// ATTENTION: UIViewではなくCALayerのサブクラス
open class LLView 
: CALayer
, LLUILifeEvent
{
    public var isUserInteractionEnabled = true
    
    public lazy var setupField = LLViewFieldMap()
    public lazy var buildupField = LLViewFieldMap()
    public lazy var teardownField = LLViewFieldMap()
    
    public lazy var styleField = LLViewStyleFieldMap()
    public var layoutField: LLField?
    
    public lazy var actionBeganField = LLActionFieldMap()
    public lazy var actionMovedField = LLActionFieldMap()
    public lazy var actionEndedField = LLActionFieldMap()
    public lazy var actionEndedInsideField = LLActionFieldMap()

    public lazy var mouseMovedField = LLMouseFieldMap()
    public lazy var mouseLeftDownField = LLMouseFieldMap()
    public lazy var mouseLeftDraggedField = LLMouseFieldMap()
    public lazy var mouseLeftUpField = LLMouseFieldMap()
    public lazy var mouseLeftUpInsideField = LLMouseFieldMap()
    public lazy var mouseRightDownField = LLMouseFieldMap()
    public lazy var mouseRightDraggedField = LLMouseFieldMap()
    public lazy var mouseRightUpField = LLMouseFieldMap()
    public lazy var mouseRightUpInsideField = LLMouseFieldMap()
    public lazy var mouseOverField = LLMouseFieldMap()
    public lazy var mouseOutField = LLMouseFieldMap()
            
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
    
    open func addSubview(_ llview:LLView ) { 
        llview.preSetup()
        llview.setup()
        llview.postSetup()
        self.addSublayer( llview )
    }
    
    open func addSubview(_ view:NSView ) { 
        if let llui = view as? LLUILifeEvent {
            llui.preSetup()
            llui.setup()
            llui.postSetup()
        }
        self.addSublayer( view.layer! )
    }
    
    required public init?(coder decoder: NSCoder) { super.init(coder:decoder) }
    public override init() {
        super.init()
        self.initViewAttributes()
        self.minificationFilter = .nearest
        self.magnificationFilter = .nearest
    }
    
    public override init( layer: Any ) {
        super.init(layer:layer)
        self.initViewAttributes()
        self.minificationFilter = .nearest
        self.magnificationFilter = .nearest
    }
        
    public var _mutex = LLRecursiveMutex()
    
    open func preSetup() { }
    
    open func setup() { }
    
    open func postSetup() { self.lifeEventDefaultSetup() }
    
    open func preBuildup() { }
    
    open func buildup() { }
    
    open func postBuildup() { self.lifeEventDefaultBuildup() }
    
    open func teardown() { self.lifeEventDefaultTeardown() }
    
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
        if isHidden || !isEnabled { return ( nil, global_pt ) }
        // 範囲チェック
        if local_pt.x < 0.0 || width < local_pt.x || local_pt.y < 0.0 || height < local_pt.y {
            return ( nil, global_pt )
        }
        // 範囲内であれば自身を返す
        return ( self, local_pt )
    }
}

#endif
