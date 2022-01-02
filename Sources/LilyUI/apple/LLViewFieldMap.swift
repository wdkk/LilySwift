//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public class LLViewFieldMap : LLFieldMap 
{
    public func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView)->Void
    )
    {
        fields[order] = LLTalkingField<TCaller, TView, Any>(
            label:label,
            caller:caller,
            me:view,
            action:f 
        )
    }
    
    public func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, TPhenomena)->Void
    )
    {
        fields[order] = LLMediaField<TCaller, TView, Any, TPhenomena>( 
            label:label,
            caller:caller,
            me:view, 
            phenomena:phenomena,
            action:f 
        )
    }
}
