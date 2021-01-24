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

public extension LLFieldMapChain where TFieldMap:LLViewFieldMap
{
    @discardableResult
    func add<TCaller:AnyObject>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        field f:@escaping (TCaller, TObj)->Void )
    -> LLChain<TObj>
    {
        fmap.add( label, with:caller, me:obj, field:f )
        return LLChain( obj )
    }
    
    @discardableResult
    func add<TCaller:AnyObject, TPhenomena>( 
        _ label:String = UUID().uuidString,
        with caller:TCaller,
        phenomena:TPhenomena,
        field f:@escaping (TCaller, TObj, TPhenomena)->Void )
    -> LLChain<TObj>
    {
        fmap.add( label, with:caller, me:obj, phenomena:phenomena, field:f )
        return LLChain( obj )
    }
}
