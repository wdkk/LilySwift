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

/// LLViewチェインアクセサ : イベント
public extension LLChain where TObj:LLView
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
    
    // MARK: -
    
    var defaultBuildup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.defaultBuildupField )
    }
    
    var staticBuildup:LLFieldMapChain<TObj, LLViewFieldMap> {
        return LLFieldMapChain( obj, obj.staticBuildupField )
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
