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

public class LLEmptyObject 
{
   static public let none = LLEmptyObject()
}

public class LLEmptyPhenomena 
{
    static public let none = LLEmptyPhenomena()
}

public protocol LLField
{
    func appear( _ obj:Any? )
}
