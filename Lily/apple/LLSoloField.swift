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

public struct LLSoloField<TMe:AnyObject, TObj> : LLField
{
    public private(set) var field:((TObj)->Void)?
    
    public init( me:TMe,
                 objType:TObj.Type,
                 action:@escaping (TMe, TObj)->Void )
    {
        self.field = { [weak me] ( objs:TObj ) in
            guard let me = me else { return }
            action( me, objs )
        }
    }
    
    // ジェネリクス(TObj=Any)を指定して用いる
    public init( me:TMe,
                 action:@escaping (TMe)->Void )
    {
        self.field = { [weak me] ( objs:TObj ) in
            guard let me = me else { return }
            action( me )
        }
    }
    
    public func appear( _ obj:Any? = nil ) {
        guard let tobj = obj as? TObj else { return }
        self.field?( tobj )
    }
}
