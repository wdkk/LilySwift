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

/// 基本プロパティアクセサ系
public extension LLFlow where TObj:LLViewBase
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
}

/// Field Container系経由関数
public extension LLFlow where TObj:LLViewBase 
{
    var assemble:LLViewFieldContainerFlow<TObj> {
        return LLViewFieldContainerFlow( obj.assemble, self ) 
    }
    
    var design:LLViewFieldContainerFlow<TObj> {
        return LLViewFieldContainerFlow( obj.design, self ) 
    }

    var disassemble:LLViewFieldContainerFlow<TObj> {
        return LLViewFieldContainerFlow( obj.disassemble, self ) 
    }
    
    var touchesBegan:LLTouchFieldContainerFlow<TObj> {
        return LLTouchFieldContainerFlow( obj.touchesBegan, self ) 
    }
    
    var touchesMoved:LLTouchFieldContainerFlow<TObj> {
        return LLTouchFieldContainerFlow( obj.touchesMoved, self ) 
    }

    var touchesEnded:LLTouchFieldContainerFlow<TObj> {
        return LLTouchFieldContainerFlow( obj.touchesEnded, self ) 
    }
    
    var touchesCancelled:LLTouchFieldContainerFlow<TObj> {
        return LLTouchFieldContainerFlow( obj.touchesCancelled, self ) 
    }
}

#endif
