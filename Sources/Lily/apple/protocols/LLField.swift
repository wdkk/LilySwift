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

public class LLEmpty
{
    static public let none = LLEmpty()
}

public protocol LLField
{
    associatedtype TObj
    
    func appear()
    func appear( _ objs:TObj? )
}

public extension LLField
{
    func appear() { self.appear( nil ) }
}
