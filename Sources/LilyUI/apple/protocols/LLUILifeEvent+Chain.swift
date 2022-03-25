//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

public extension LLChain where TObj:LLUILifeEvent
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
    
    func layout<TCaller:AnyObject>(
        caller:TCaller,
        field f:@escaping (TCaller, TObj)->Void
    ) -> Self
    {
        obj.layoutField = LLTalkingField<TCaller, TObj, Any>(
            caller:caller,
            me:obj.self,
            action:f
        )
        return LLChain( obj )
    }
}
