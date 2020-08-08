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

public protocol LLChainable
{
    associatedtype TObj
    var chain:LLChain<TObj> { get }
    
    static var chain:LLChain<TObj>.Type { get }
}

public extension LLChainable
{
    var chain:LLChain<Self> {
        LLChain( self )
    }
    
    static var chain:LLChain<Self>.Type {
        LLChain<Self>.self
    }
}

extension NSObject: LLChainable {}

/// チェインアクセサ
public struct LLChain<TObj>
{ 
    public let obj:TObj
    
    public init( _ obj:TObj ) {
        self.obj = obj
    }    
    
    public var unchain:TObj { self.obj }
}
