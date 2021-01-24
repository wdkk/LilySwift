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

public class LLFieldMap
{
    public var fields:[String:LLField] = [:]
    
    public init() {}
    
    public func appear( _ objs:Any? ) {
        let sorted_fields = fields.sorted { $0.0 < $1.0 }
        for (_,f) in sorted_fields {
            f.appear( objs )
        }
    }
    
    public func removeAll() {
        fields.removeAll()
    }
}
