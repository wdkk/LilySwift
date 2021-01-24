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

public extension LLFieldMapChain where TFieldMap:LLTouchFieldMap
{
    @discardableResult
    func add<TCaller:AnyObject>( 
        label:String = UUID().uuidString,
        with caller:TCaller,
        field f:@escaping (TCaller, TObj, LLTouchArg)->Void )
    -> LLChain<TObj>
    {
        fmap.add( label, with: caller, me:obj, field: f )
        return LLChain( obj )
    } 
    
    @discardableResult
    func add<TCaller:AnyObject, TPhenomena>(
        label:String = UUID().uuidString,
        with caller:TCaller,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TObj, LLTouchArg, TPhenomena)->Void )
    -> LLChain<TObj>
    {
        fmap.add( label, with: caller, me:obj, phenomena:phenomena, field: f )
        return LLChain( obj )
    }
}

#endif
