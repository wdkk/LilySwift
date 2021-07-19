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

public class LLDrawFieldMap : LLFieldMap 
{
    public typealias Args = CGRect
    
    open func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, Args, TPhenomena)->Void )
    {
        fields[label] = LLMediaField( by:caller,
                                      me:view,
                                      objType:Args.self, 
                                      phenomena:phenomena,
                                      action:f )
    }
    
    open func add<TCaller:AnyObject, TView:AnyObject>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView, Args)->Void )
    {
        fields[label] = LLTalkingField( by:caller,
                                        me:view,
                                        objType:Args.self,
                                        action:f )
    }
}

#endif
