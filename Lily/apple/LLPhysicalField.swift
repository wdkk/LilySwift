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

public struct LLPhysicalField<TCaller:AnyObject, TTarget:AnyObject, TArg> : LLField
{
    public private(set) var field:((TArg)->Void)?
    
    public struct Object
    {
        public var caller:TCaller
        public var me:TTarget
        public var args:TArg
    }
  
    public init( by caller:TCaller,
                 target me:TTarget,
                 argType:TArg.Type,
                 field f:@escaping (Object)->Void )
    {
        self.field = { [weak caller, weak me] ( args:TArg ) in
            guard let caller = caller,
              let me = me else { return }
            let obj = Object( caller:caller, me: me, args: args )
            f( obj )
        }
    }
    
    public func appear( _ obj:Any? = nil ) {
        guard let args = obj as? TArg else { return }
        self.field?( args )
    }
}
