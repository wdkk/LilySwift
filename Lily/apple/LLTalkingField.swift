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

public struct LLTalkingField<TCaller:AnyObject, TMe:AnyObject, TObj> : LLField
{
    public private(set) var field:((TObj)->Void)?
      
    public init( by caller:TCaller,
                 me:TMe,
                 objType:TObj.Type,
                 action:@escaping (TCaller, TMe, TObj)->Void )
    {
        self.field = { [weak caller, weak me] ( objs:TObj ) in
            guard let caller:TCaller = caller,
                  let me:TMe = me else { return }
            action( caller, me, objs )
        }
    }
    
    // ジェネリクス(<TCaller, TMe, Any>)を指定して用いる
    public init( by caller:TCaller,
                 me:TMe,
                 action:@escaping (TCaller, TMe)->Void )
    {
        self.field = { [weak caller, weak me] ( objs:TObj ) in
            guard let caller:TCaller = caller,
                  let me:TMe = me else { return }
            action( caller, me )
        }
    }
        
    public func appear( _ objs:Any? = nil ) {
        guard let tobjs = objs as? TObj else { return }
        self.field?( tobjs )
    }
}
