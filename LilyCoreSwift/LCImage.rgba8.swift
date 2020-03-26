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

public class LCImageRGBA8 : LCImageGenericRaw<LLColor8>
{       
    public override func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return LLColor8tof }
    public override func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return LLColorfto8 }
    
    public required init( _ wid: Int, _ hgt: Int ) {
        super.init( wid, hgt )
        treatMemory( wid, hgt, .rgba8 )
    }
}
