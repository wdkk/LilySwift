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

public class LLViewFieldMap : LLFieldMap 
{
    public func add<TCaller:AnyObject, TView:AnyObject>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView)->Void )
    {
        fields[label] = LLTalkingField<TCaller, TView, Any>( by:caller,
                                                             me:view,
                                                             action:f )
    }
    
    public func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, TPhenomena)->Void )
    {
        fields[label] = LLMediaField<TCaller, TView, Any, TPhenomena>( by:caller,
                                                                       me:view, 
                                                                       phenomena:phenomena,
                                                                       action:f )
    }
}
