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

public class LLFieldMap
{
    public var fields = [String:LLField]()
        
    public func appear( _ objs:Any? ) {
        for f in fields {
            f.value.appear( objs )
        }
    }
    
    public func removeAll() {
        fields.removeAll()
    }
}
