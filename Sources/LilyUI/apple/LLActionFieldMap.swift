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

public struct LLActionArg
{
    public var points:[LLPoint]

    public init( _ pts:[LLPoint] ) {
        self.points = pts
    }
}

open class LLActionFieldMap : LLFieldMap 
{
    open func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, LLActionArg, TPhenomena)->Void )
    {
        fields[order] = LLMediaField(
            label:label,
            caller:caller,
            me:view,
            objType:LLActionArg.self, 
            phenomena:phenomena,
            action:f
        )
    }
    
    open func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView, LLActionArg)->Void )
    {
        fields[order] = LLTalkingField(
            label:label,
            caller:caller,
            me:view,
            objType:LLActionArg.self,
            action:f
        )
    }
}
