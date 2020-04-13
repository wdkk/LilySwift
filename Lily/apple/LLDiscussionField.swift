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

public struct LLDiscussionField<TCaller:AnyObject, TTarget:AnyObject, TArg, TPhenomena> : LLField
{
    public private(set) var field:((TArg, TPhenomena)->Void)?
    public private(set) var phenomena:TPhenomena
    
    public struct Object
    {
        public var caller:TCaller
        public var me:TTarget
        public var args:TArg
    }
  
    public init( by caller:TCaller,
                 target me:TTarget,
                 argType:TArg.Type,
                 join phenomena:TPhenomena,
                 field f:@escaping (Object, TPhenomena)->Void )
    {
        self.phenomena = phenomena
        self.field = { [weak caller, weak me] ( args:TArg, phenomena:TPhenomena ) in
            guard let caller = caller else { return }
            guard let me = me else { return }
            let obj = Object( caller: caller, me: me, args: args )
            f( obj, phenomena )
        }
    }
    
    public func appear( _ obj:Any? = nil ) {
        guard let args = obj as? TArg else { return }
        self.field?( args, self.phenomena )
    }
}
