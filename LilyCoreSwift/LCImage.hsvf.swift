//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public class LCImageHSVf : LCImageGenericRaw<LLHSVf>
{    
    public override func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return LLHSVftoColorf }
    public override func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return LLColorftoHSVf }
    
    public required init( _ wid: Int, _ hgt: Int ) {
        super.init( wid, hgt )
        treatMemory( wid, hgt, .hsvf )
    }
}
