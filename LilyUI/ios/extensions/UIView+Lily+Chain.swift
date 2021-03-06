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

/// UIViewチェインアクセサ : プロパティ
public extension LLChain where TObj:UIView
{
    var bounds:CGRect { obj.bounds }
    
    @discardableResult
    func bounds( _ rc:CGRect ) -> Self { 
        obj.bounds = rc
        return self
    }
    
    var alpha:CGFloat { obj.alpha }
    
    @discardableResult
    func alpha( _ k:CGFloat ) -> Self { 
        obj.alpha = k
        return self
    }
    
    var rect:LLRect { obj.rect }
    
    @discardableResult
    func rect( _ rc:LLRect ) -> Self { 
        obj.rect = rc
        return self
    }
    
    @discardableResult
    func rect( _ x:LLDouble, _ y:LLDouble, _ width:LLDouble, _ height:LLDouble ) -> Self {
        return rect( LLRect( x, y, width, height ) )
    }
    
    var position:LLPoint { LLPoint( obj.rect.x, obj.rect.y ) }
    
    @discardableResult
    func position( _ pos:LLPoint ) -> Self {
        obj.rect.x = pos.x
        obj.rect.y = pos.y
        return self
    }
    
    @discardableResult
    func position( _ x:LLDouble, _ y:LLDouble ) -> Self {
        return position( LLPoint( x, y ) )
    }
    
    var size:LLSize { LLSize( obj.rect.width, obj.rect.height ) }
        
    @discardableResult
    func size( _ sz:LLSize ) -> Self {
        obj.rect.width = sz.width
        obj.rect.height = sz.height
        return self
    }
    
    @discardableResult
    func size( _ width:LLDouble, _ height:LLDouble ) -> Self {
        return size( LLSize( width, height ) )
    }
    
    var backgroundColor:LLColor? { obj.backgroundColor?.llColor }
    
    @discardableResult
    func backgroundColor( _ c:LLColor ) -> Self {
        obj.backgroundColor = c.uiColor
        return self
    }
    
    var borderColor:LLColor? { obj.layer.borderColor?.llColor }
    
    @discardableResult
    func borderColor( _ c:LLColor ) -> Self {
        obj.layer.borderColor = c.cgColor
        return self
    }  
    
    var borderWidth:LLFloat { obj.layer.borderWidth.f }
    
    @discardableResult
    func borderWidth( _ w:LLFloat ) -> Self {
        obj.layer.borderWidth = w.cgf
        return self
    }
    
    var cornerRadius:LLFloat { obj.layer.cornerRadius.f }
    
    @discardableResult
    func cornerRadius( _ r:LLFloat ) -> Self {
        obj.layer.cornerRadius = r.cgf
        return self
    }
    
    var isUserInteractionEnabled:Bool { obj.isUserInteractionEnabled }
    
    @discardableResult
    func isUserInteractionEnabled( _ torf:Bool ) -> Self {
        obj.isUserInteractionEnabled = torf
        return self
    }
    
    var maskToBounds:Bool { obj.layer.masksToBounds }
    
    @discardableResult
    func maskToBounds( _ torf:Bool ) -> Self {
        obj.layer.masksToBounds = torf
        return self
    }
}

/// UIViewチェインアクセサ : メソッド
public extension LLChain where TObj:UIView
{
    @discardableResult
    func addSubview<TView:UIView>( _ view:TView ) -> Self {
        obj.addSubview( view )
        return self
    }
    
    @discardableResult
    func addSubview<TView:UIView>( _ chainview:LLChain<TView> ) -> Self {
        obj.addSubview( chainview )
        return self
    }    
}

#endif
