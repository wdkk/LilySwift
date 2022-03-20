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

public extension LLFieldMapChain where TFieldMap:LLDrawFieldMap
{
    @discardableResult
    func add<TCaller:AnyObject>( 
        label:String = UUID().labelString,
        order:LLFieldMap.Order = LLFieldMap.newOrder(),
        caller:TCaller,
        args:LLDrawFieldMap.Objs,
        field f:@escaping (TCaller, TObj, LLDrawFieldMap.Objs)->Void )
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
        args:LLDrawFieldMap.Objs,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TObj, LLDrawFieldMap.Objs, TPhenomena)->Void )
    -> LLChain<TObj>
    {
        fmap.add( 
            label:label,
            order:order,
            caller:caller, 
            me:obj, 
            phenomena:phenomena, 
            field:f 
        )
        return LLChain( obj )
    }
}

#endif
