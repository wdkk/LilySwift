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

public class LLFieldContainer 
{
    public var fields = [String:LLField]()
    
    public func append( label:String, field:LLField ) {
        fields[label] = field
    }
    
    public func remove( label:String ) {
        fields.removeValue( forKey: label )
    }
    
    public func appear( _ obj:Any? ) {
        for f in fields {
            f.value.appear( obj )
        }
    }
}
