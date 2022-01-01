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

/// LLViewControllerViewチェインアクセサ : イベント
public extension LLChain where TObj:LLViewControllerView
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

#endif
