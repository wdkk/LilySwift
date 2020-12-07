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

import AppKit

/// アクセサ
public extension LLChain where TObj:LLView
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
        obj.backgroundColor = c.cgColor
        return self
    }

    var setup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.setupField )
    }
    
    var buildup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.buildupField )
    }

    var teardown:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.teardownField )
    }
}

#endif
