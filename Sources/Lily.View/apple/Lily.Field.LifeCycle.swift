//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

extension Lily.Field
{
    public class LifeCycle<TMe:AnyObject, TObj>
    : LLField
    {    
        public private(set) var relayFunc:((TObj)->Void)?
        
        public init(
            me:TMe,
            action:@escaping (TMe)->Void 
        )
        where TObj == LLEmpty
        {
            self.relayFunc = { [weak me] ( objs:TObj ) in
                guard let me:TMe = me else { return }
                action( me )
            }
        }
        
        public init(
            me:TMe,
            action:@escaping (TMe, TObj)->Void 
        )
        {
            self.relayFunc = { [weak me] ( objs:TObj ) in
                guard let me:TMe = me else { return }
                action( me, objs )
            }
        }
        
        public init<TCaller:AnyObject>( 
            me:TMe,
            caller:TCaller,
            action:@escaping (TMe, TCaller)->Void
        )
        where TObj == LLEmpty
        {
            self.relayFunc = { [weak caller, weak me] ( objs:TObj ) in
                guard let caller:TCaller = caller, let me:TMe = me else { return }
                action( me, caller )
            }
        }
        
        public init<TCaller:AnyObject>( 
            me:TMe,
            caller:TCaller,
            action:@escaping (TMe, TCaller, TObj)->Void
        )
        {
            self.relayFunc = { [weak caller, weak me] ( objs:TObj ) in
                guard let caller:TCaller = caller, let me:TMe = me else { return }
                action( me, caller, objs )
            }
        }
        
        public func appear( _ objs:TObj? ) {
            if TObj.self == LLEmpty.self { self.relayFunc?( LLEmpty.none as! TObj ); return }
            guard let tobjs = objs else { return }
            self.relayFunc?( tobjs )
        }
    }
}
