//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Foundation
import AppKit
import QuartzCore

extension Lily.View
{
    // CHECK: UIViewではなくCALayerのサブクラス
    open class BaseView 
    : CALayer
    , LLUILifeEvent
    {    
        public var _mutex = Lily.View.RecursiveMutex()
        public var isUserInteractionEnabled = true
        public var setupField:(any LLField)?
        public var buildupField:(any LLField)?
        public var teardownField:(any LLField)?
        public func setup() {}
        public func buildup() {}
        public func teardown() {}
        
        func initViewAttributes() {
            self.anchorPoint = CGPoint( x:0.5, y:0.5 )
            self.masksToBounds = false
            self.contentsScale = LLSystem.retinaScale.cgf
        }
        
        open var alpha:CGFloat {
            get { return self.opacity.cgf }
            set { self.opacity = newValue.f }
        }
        
        open func addSubview(_ lilyView:BaseView ) { 
            lilyView.callSetupPhase()
            self.addSublayer( lilyView )
        }
        
        open func addSubview(_ view:NSView ) { 
            (view as? LLUILifeEvent)?.callSetupPhase()
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
        
        // Viewのピック処理. ignitionの発火はLLViewControllerViewで全管理しているのでお任せ
        open func pick( _ global_pt: LLPoint ) -> ( view:BaseView?, local_pt:LLPoint ) {
            // 子レイヤーたちを先にあたる。該当があればそのViewを返して処理終了
            if sublayers != nil {
                let sorted_sublayers = sublayers!.sorted { ( l1:CALayer, l2:CALayer ) -> Bool in
                    return l1.zPosition > l2.zPosition
                }.reversed()
                
                for layer in sorted_sublayers {
                    if !(layer is BaseView) { continue }
                    let result = (layer as! BaseView).pick( global_pt )
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
}

public extension Lily.View.BaseView
{
    func rebuildChildren() {
        // CALayer側
        guard let sublayers = self.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.rebuild() }
        }
    }

    func teardownChildren() {
        // CALayer側
        guard let sublayers = self.sublayers else { return }
        for child in sublayers {
            if let llui = child as? LLUILifeEvent { llui.teardown() }
        }
    }
}

extension Lily.View.BaseView
{            
    public var bgColor:LLColor? { self.backgroundColor?.llColor }
    
    @discardableResult
    public func bgColor( _ c:LLColor ) -> Self {
        self.backgroundColor = c.cgColor
        return self
    }
    
    @discardableResult
    public func rect( _ rc:LLRect ) -> Self { 
        self.rect = rc
        return self
    }
    
    @discardableResult
    public func rect( _ cgrc:CGRect ) -> Self { 
        self.rect = cgrc.llRect
        return self
    }
    
    @discardableResult
    public func rect( _ x:LLDouble, _ y:LLDouble, _ width:LLDouble, _ height:LLDouble ) -> Self {
        return rect( LLRect( x, y, width, height ) )
    }
    
    
    @discardableResult
    public func bounds( _ rc:LLRect ) -> Self { 
        self.bounds = rc.cgRect
        return self
    }
    
    @discardableResult
    public func bounds( _ cgrc:CGRect ) -> Self { 
        self.bounds = cgrc
        return self
    }
        
    @discardableResult
    public func alpha( _ k:CGFloat ) -> Self { 
        self.alpha = k
        return self
    }
    
    //public var position:LLPoint { LLPoint( rect.x, rect.y ) }
    
    @discardableResult
    public func position( _ pos:LLPoint ) -> Self {
        rect.x = pos.x
        rect.y = pos.y
        return self
    }
    
    @discardableResult
    public func position( _ x:LLDouble, _ y:LLDouble ) -> Self {
        return position( LLPoint( x, y ) )
    }
    
    public var size:LLSize { LLSize( rect.width, rect.height ) }
        
    @discardableResult
    public func size( _ sz:LLSize ) -> Self {
        rect.width = sz.width
        rect.height = sz.height
        return self
    }
    
    @discardableResult
    public func size( _ width:LLDouble, _ height:LLDouble ) -> Self {
        return size( LLSize( width, height ) )
    }
    
    //public var borderColor:LLColor? { layer.borderColor?.llColor }
    
    @discardableResult
    public func borderColor( _ c:LLColor ) -> Self {
        borderColor = c.cgColor
        return self
    }  
    
    //public var borderWidth:LLFloat { borderWidth.f }
    
    @discardableResult
    public func borderWidth( _ w:LLFloat ) -> Self {
        borderWidth = w.cgf
        return self
    }
    
    //public var cornerRadius:LLFloat { layer.cornerRadius.f }
    
    @discardableResult
    public func cornerRadius( _ r:LLFloat ) -> Self {
        cornerRadius = r.cgf
        return self
    }
             
    //public var maskToBounds:Bool { layer.masksToBounds }
    
    @discardableResult
    public func maskToBounds( _ torf:Bool ) -> Self {
        masksToBounds = torf
        return self
    }
}


#endif
