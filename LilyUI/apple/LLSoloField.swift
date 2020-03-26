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

public struct LLSoloField<TMe:AnyObject, TArg> : LLField
{
    public private(set) var field:((TArg)->Void)?
    
    public struct Object
    {
        public var me:TMe
        public var args:TArg
    }
  
    public init( by me:TMe,
                 argType:TArg.Type,
                 field f:@escaping (Object)->Void )
    {
        self.field = { [weak me] ( args:TArg ) in
            guard let me = me else { return }
            let obj = Object( me: me, args: args )
            f( obj )
        }
    }
    
    public func appear( _ obj:Any? = nil ) {
        guard let args = obj as? TArg else { return }
        self.field?( args )
    }
}
