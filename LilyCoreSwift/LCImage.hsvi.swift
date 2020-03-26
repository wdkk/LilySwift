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

public class LCImageHSVi : LCImageGenericRaw<LLHSVi>
{    
    public override func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return LLHSVitoColorf }
    public override func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return LLColorftoHSVi }
    
    public required init( _ wid: Int, _ hgt: Int ) {
        super.init( wid, hgt )
        treatMemory( wid, hgt, .hsvi )
    }
}
