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

// LLFieldを一斉実行するためのマッピング格納クラス
open class LLFieldMap
{
    public typealias Order = Int
    
    // 自動オーダーのカウンタ
    static public private(set) var auto_order_count:Order = 0
    static public func newOrder() -> Order { 
        auto_order_count += 1
        return auto_order_count
    }
    
    public var fields:[Order:LLField] = [:]
    
    public init() {}
    
    open func appear( _ objs:Any? ) {
        // Order順に実行していく.
        let sorted_fields = fields.sorted { $0.0 < $1.0 }
        for (_,f) in sorted_fields {
            f.appear( objs )
        }
    }
    
    open func removeAll() {
        fields.removeAll()
    }
}

public extension LLFieldMap.Order 
{
    static var pre:Self { -15000000 }

    static func pre( offsetBy v:Int = 0 ) -> Self {
        return -15000000 + v 
    }
}
