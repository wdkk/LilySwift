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

public struct LLReturnField<TMe:AnyObject, TReturn:LLZeroable>
{
    public private(set) var field:((TMe)->TReturn)?
    public weak var me:TMe?
    
    public init( by me:TMe,
                 field f:@escaping (TMe)->TReturn )
    {
        self.me = me
        self.field = { [weak me] _ in
            guard let me = me else { return .zero }
            return f( me )
        }
    }
    
    public func appear() -> TReturn {
        guard let me = self.me else { return .zero }
        guard let field = field else { return .zero }
        return field( me )
    }
}
