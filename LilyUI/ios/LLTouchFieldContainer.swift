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

public struct LLTouchArg
{
    public let touches:Set<UITouch>
    public let event:UIEvent?
    
    public init( _ touches_:Set<UITouch>, _ event_:UIEvent? ) {
        touches = touches_
        event = event_
    }
}

public class LLTouchFieldContainer : LLFieldContainer 
{
    public func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().uuidString,
        with caller:TCaller,
        target view:TView,
        join phenomena:TPhenomena,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLTouchArg, TPhenomena>.Object,
        TPhenomena)->Void )
    {
        fields[label] = LLDiscussionField( by:caller, target:view, argType:LLTouchArg.self, 
                                           join:phenomena, field:f )
    }
    
    public func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().uuidString,
        with caller:TCaller,
        target view:TView,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLTouchArg, LLEmptyPhenomena>.Object,
        LLEmptyPhenomena)->Void )
    {
        fields[label] = LLDiscussionField( by:caller, target:view, argType:LLTouchArg.self,
                                           join:LLEmptyPhenomena.none, field:f )
    }
}

#endif
