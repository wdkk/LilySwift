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

public extension LLFieldMapChain where TFieldMap:LLViewStyleFieldMap
{
    @discardableResult
    func `default`( 
        label:String = UUID().labelString,
        field f:@escaping (TObj)->Void 
    )
    -> LLChain<TObj>
    {
        fmap.default( 
            label:label,
            me:obj,
            field:f 
        )
        return LLChain( obj )
    }
    
    @discardableResult
    func defaultEqual( field f:@escaping (TObj)->LLField? )
    -> LLChain<TObj>
    {
        fmap.default = f( obj )
        return LLChain( obj )
    }
    
    @discardableResult
    func action( 
        label:String = UUID().labelString,
        field f:@escaping (TObj)->Void
    )
    -> LLChain<TObj>
    {
        fmap.action( 
            label:label,
            me:obj,
            field:f 
        )
        return LLChain( obj )
    }
    
    @discardableResult
    func actionEqual( field f:@escaping (TObj)->LLField? )
    -> LLChain<TObj>
    {
        fmap.action = f( obj )
        return LLChain( obj )
    }
    
    @discardableResult
    func disable( 
        label:String = UUID().labelString,
        field f:@escaping (TObj)->Void
    )
    -> LLChain<TObj>
    {
        fmap.disable( 
            label:label,
            me:obj,
            field:f 
        )
        return LLChain( obj )
    }
    
    @discardableResult
    func disableEqual( field f:@escaping (TObj)->LLField? )
    -> LLChain<TObj>
    {
        fmap.disable = f( obj )
        return LLChain( obj )
    }
}
