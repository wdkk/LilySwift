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

public class LLEmpty 
{
    static public let none:LLEmpty = LLEmpty()
}

public protocol LLField
{
    func appear( _ objs:Any? )
}
