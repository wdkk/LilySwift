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

public struct LLFieldMapChain<TObj:LLView, TFieldMap:LLFieldMap>
{
    public var obj:TObj
    public var fmap:TFieldMap
    init( _ o:TObj, _ fm:TFieldMap ) {
        obj = o
        fmap = fm
    }
}