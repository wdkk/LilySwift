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

public struct LLTouchArg
{
    public let touches:Set<UITouch>
    public let event:UIEvent?
    
    public init( _ touches_:Set<UITouch>, _ event_:UIEvent? ) {
        touches = touches_
        event = event_
    }
}

open class LLTouchFieldMap : LLFieldMap 
{
    open func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, LLTouchArg, TPhenomena)->Void )
    {
        fields[order] = LLMediaField(
            label:label,
            caller:caller,
            me:view,
            objType:LLTouchArg.self, 
            phenomena:phenomena,
            action:f
        )
    }
    
    open func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView, LLTouchArg)->Void )
    {
        fields[order] = LLTalkingField(
            label:label,
            caller:caller,
            me:view,
            objType:LLTouchArg.self,
            action:f
        )
    }
}

#endif
