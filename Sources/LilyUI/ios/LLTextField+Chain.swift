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

/// LLTextFieldチェインアクセサ : イベント
public extension LLChain where TObj:LLTextField
{    
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
    
    var touchesBegan:LLFieldMapChain<TObj, LLTouchFieldMap> {
        return LLFieldMapChain( obj, obj.touchesBeganField ) 
    }
    
    var touchesMoved:LLFieldMapChain<TObj, LLTouchFieldMap> {
        return LLFieldMapChain( obj, obj.touchesMovedField ) 
    }

    var touchesEnded:LLFieldMapChain<TObj, LLTouchFieldMap> {
        return LLFieldMapChain( obj, obj.touchesEndedField ) 
    }
    
    var touchesEndedInside:LLFieldMapChain<TObj, LLTouchFieldMap> {
        return LLFieldMapChain( obj, obj.touchesEndedInsideField ) 
    }
    
    var touchesCancelled:LLFieldMapChain<TObj, LLTouchFieldMap> {
        return LLFieldMapChain( obj, obj.touchesCancelledField ) 
    }
}

/// LLTextFieldチェインアクセサ : メソッド
public extension LLChain where TObj:LLTextField
{
    var placeholderColor:LLColor { obj.placeholderColor }
    
    @discardableResult
    func placeholderColor( _ c:UIColor ) -> Self { 
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
}

#endif
