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

public class LLTouchFieldMap : LLFieldMap 
{
    public func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, LLTouchArg, TPhenomena)->Void )
    {
        fields[label] = LLMediaField( by:caller,
                                      me:view,
                                      objType:LLTouchArg.self, 
                                      phenomena:phenomena,
                                      action:f )
    }
    
    public func add<TCaller:AnyObject, TView:AnyObject>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView, LLTouchArg)->Void )
    {
        fields[label] = LLTalkingField( by:caller,
                                        me:view,
                                        objType:LLTouchArg.self,
                                        action:f )
    }
}

#endif
