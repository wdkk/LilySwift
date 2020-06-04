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

public struct LLPlaneField<TMe:AnyObject> : LLField
{
    public private(set) var field:((TMe)->Void)?
    
    public init( by me:TMe,
                 field f:@escaping (TMe)->Void )
    {
        self.field = { [weak me] _ in
            guard let me = me else { return }
            f( me )
        }
    }
    
    public func appear( _ obj:Any? = nil ) {
        guard let me = obj as? TMe else { return }
        self.field?( me )
    }
}
