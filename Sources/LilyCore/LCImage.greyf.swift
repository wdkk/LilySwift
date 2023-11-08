//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public class LCImageGreyf : LCImageGenericRaw<LLFloat>
{    
    public override func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return LLGreyftoColorf }
    public override func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return LLColorftoGreyf }
    
    public required init( _ wid: Int, _ hgt: Int ) {
        super.init( wid, hgt )
        treatMemory( wid, hgt, .greyf )
    }
}
