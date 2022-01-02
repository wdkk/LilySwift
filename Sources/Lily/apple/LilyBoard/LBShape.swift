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
import Metal

open class LBShape<
    TObjPL:LBObjectPipeline<TStorage>,
    TStorage:LBActorStorage
>
: LBActor
{
    public weak var objPipeline:TObjPL?
    public private(set) var index:Int
    
    public init( objpl:TObjPL ) {
        // makeされていなかった場合を考慮してここでmakeする
        objpl.make()
                
        self.index = objpl.storage.request()
        self.objPipeline = objpl
    }
    
    deinit {
        params.state = .trush
    }
    
    public override var params:LBActorParam {
        get { return objPipeline!.storage.params.accessor![index] }
        set { objPipeline?.storage.params.accessor?[index] = newValue }
    }
}
