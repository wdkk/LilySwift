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

/// LLTextFieldチェインアクセサ : イベント
public extension LLChain where TObj:LLTextField
{
    // MARK: -
    
    var setup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.setupField )
    }
    
    var buildup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.buildupField )
    }

    var teardown:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.teardownField )
    }
    
    var style:LLFieldMapChain<TObj, LLViewStyleFieldMap> {
        return LLFieldMapChain( obj, obj.styleField )
    }
    
    // MARK: -
    
    var actionBegan:LLFieldMapChain<TObj, LLActionFieldMap> {
        return LLFieldMapChain( obj, obj.actionBeganField ) 
    }
    
    var actionMoved:LLFieldMapChain<TObj, LLActionFieldMap> {
        return LLFieldMapChain( obj, obj.actionMovedField ) 
    }

    var actionEnded:LLFieldMapChain<TObj, LLActionFieldMap> {
        return LLFieldMapChain( obj, obj.actionEndedField ) 
    }
    
    var actionEndedInside:LLFieldMapChain<TObj, LLActionFieldMap> {
        return LLFieldMapChain( obj, obj.actionEndedInsideField ) 
    }
    
    // MARK: - 
    
    var mouseLeftDown:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseLeftDownField ) 
    }
    
    var mouseLeftDragged:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseLeftDraggedField ) 
    }   
    
    var mouseLeftUp:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseLeftUpField ) 
    }
    
    var mouseLeftUpInside:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseLeftUpInsideField ) 
    }

    var mouseRightDown:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseRightDownField ) 
    }
    
    var mouseRightDragged:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseRightDraggedField ) 
    }   
    
    var mouseRightUp:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseRightUpField ) 
    }
    
    var mouseRightUpInside:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseRightUpInsideField ) 
    }
    
    var mouseOver:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseOverField ) 
    } 
    
    var mouseOut:LLFieldMapChain<TObj, LLMouseFieldMap> {
        return LLFieldMapChain( obj, obj.mouseOutField ) 
    }
}

/// LLTextFieldチェインアクセサ : メソッド
public extension LLChain where TObj:LLTextField
{
    var placeholderColor:LLColor { obj.placeholderColor }
    
    @discardableResult
    func placeholderColor( _ c:NSColor ) -> Self { 
        obj.placeholderColor( c.llColor )
        return self
    }
    
    @discardableResult
    func placeholderColor( _ llc:LLColor ) -> Self { 
        obj.placeholderColor( llc )
        return self
    }
    
    var placeholderText:LLString { obj.placeholderText }
    
    @discardableResult
    func placeholderText( _ txt:LLString ) -> Self { 
        obj.placeholderText( txt )
        return self
    }
    
    // プレイスホルダも同時に更新するため、fontSizeを上書き
    @discardableResult
    func fontSize( _ sz:LLFloat ) -> Self {
        let f_desc = obj.font!.fontDescriptor
        obj.font = NSFont( descriptor: f_desc, size: sz.cgf )
        let txt = obj.placeholderText
        obj.placeholderText( txt )
        return self
    }
}

#endif
