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
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        args:LLDrawFieldMap.Args,
        field f:@escaping (TCaller, TObj, LLDrawFieldMap.Args)->Void )
    -> LLChain<TObj>
    {
        fmap.add( with:caller, me:obj, field:f )
        return LLChain( obj )
    }
    
    @discardableResult
    func add<TCaller:AnyObject, TPhenomena>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        args:LLDrawFieldMap.Args,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TObj, LLDrawFieldMap.Args, TPhenomena)->Void )
    -> LLChain<TObj>
    {
        fmap.add( with:caller, me:obj, phenomena:phenomena, field:f )
        return LLChain( obj )
    }
}

#endif
