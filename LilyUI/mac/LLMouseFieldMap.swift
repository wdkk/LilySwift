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

public struct LLMouseArg
{
    public let position:LLPoint
    public let event:NSEvent?
    
    public init( _ position:LLPoint, _ event:NSEvent? ) {
        self.position = position
        self.event = event
    }
}

open class LLMouseFieldMap : LLFieldMap 
{
    open func add<TCaller:AnyObject, TView:AnyObject, TPhenomena>(
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TView, LLMouseArg, TPhenomena)->Void )
    {
        fields[order] = LLMediaField(
            label:label,
            caller:caller,
            me:view,
            objType:LLMouseArg.self, 
            phenomena:phenomena,
            action:f )
    }
    
    open func add<TCaller:AnyObject, TView:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        me view:TView,
        field f:@escaping (TCaller, TView, LLMouseArg)->Void )
    {
        fields[order] = LLTalkingField(
            label:label,
            caller:caller,
            me:view,
            objType:LLMouseArg.self,
            action:f 
        )
    }
}

#endif
