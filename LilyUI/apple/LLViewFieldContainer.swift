//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public class LLViewFieldContainer : LLFieldContainer 
{           
    public func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().uuidString,
        with caller:TCaller,
        target view:TView,
        join phenomena:TPhenomena,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLEmptyObject, TPhenomena>.Object,
        TPhenomena)->Void )
    {
        fields[label] = LLDiscussionField( by:caller, target:view, argType:LLEmptyObject.self, 
                                           join:phenomena, field:f )
    }
    
    public func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().uuidString,
        with caller:TCaller,
        target view:TView,
        field f:@escaping (LLDiscussionField<TCaller, TView, LLEmptyObject, LLEmptyPhenomena>.Object,
        LLEmptyPhenomena)->Void )
    {
        fields[label] = LLDiscussionField( by:caller, target:view, argType:LLEmptyObject.self,
                                          join:LLEmptyPhenomena.none, field:f )
    }
}
