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
import Metal

open class LBShape<
    TDecoration:LBDecoration<TStorage>,
    TStorage:LBActorStorage
    >
: LBActor
{
    public weak var decoration:TDecoration?
    public private(set) var index:Int
    
    public init( decoration deco:TDecoration ) {
        // makeされていなかった場合を考慮してここでmakeする
        deco.make()
                
        self.index = deco.storage.request()
        self.decoration = deco
    }
    
    deinit {
        params.state = .trush
    }
    
    public override var params:LBActorParam {
        get { return decoration!.storage.params.accessor![index] }
        set { decoration?.storage.params.accessor?[index] = newValue }
    }
}
