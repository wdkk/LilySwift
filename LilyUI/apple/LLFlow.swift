//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

public struct LLFlow<TObj:AnyObject>
{
    public var obj:TObj
    public init( _ o:TObj ) { obj = o }
    
    public func commit() -> TObj { return obj }
}
