//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public struct LLMediaField<TCaller:AnyObject, TMe:AnyObject, TObj, TPhenomena> : LLField
{
    public private(set) var field:((TObj, TPhenomena)->Void)?
    public private(set) var phenomena:TPhenomena
  
    public init( by caller:TCaller,
                 me:TMe,
                 objType:TObj.Type,
                 phenomena:TPhenomena,
                 action:@escaping (TCaller, TMe, TObj, TPhenomena)->Void )
    {
        self.phenomena = phenomena
        self.field = { [weak caller, weak me] objs, phenomena in
            guard let caller = caller,
                  let me = me else { return }
            action( caller, me, objs, phenomena )
        }
    }
    
    // ジェネリクス(<TCaller, TMe, Any, TPhenomena>)を指定して用いる
    public init( by caller:TCaller,
                 me:TMe,
                 phenomena:TPhenomena,
                 action:@escaping (TCaller, TMe, TPhenomena)->Void )
    {
        self.phenomena = phenomena
        self.field = { [weak caller, weak me] objs, phenomena in
            guard let caller = caller,
                  let me = me else { return }
            action( caller, me, phenomena )
        }
    }
        
    public func appear( _ objs:Any? = nil ) {
        guard let tobjs = objs as? TObj else { return }
        self.field?( tobjs, self.phenomena )
    }
}
