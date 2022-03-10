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

/// LLLabelチェインアクセサ : イベント
public extension LLChain where TObj:LLLabel
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

#endif
