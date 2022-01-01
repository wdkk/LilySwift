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

public extension LLFieldMapChain where TFieldMap:LLMouseFieldMap
{
    @discardableResult
    func add<TCaller:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        field f:@escaping (TCaller, TObj, LLMouseArg)->Void )
    -> LLChain<TObj>
    {
        fmap.add( 
            label:label,
            order:order,
            caller:caller,
            me:obj,
            field:f 
        )
        return LLChain( obj )
    } 
    
    @discardableResult
    func add<TCaller:AnyObject, TPhenomena>(
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TObj, LLMouseArg, TPhenomena)->Void )
    -> LLChain<TObj>
    {
        fmap.add( 
            label:label,
            order:order,
            caller:caller, 
            me:obj,
            phenomena:phenomena, 
            field: f
        )
        return LLChain( obj )
    }
}

#endif
