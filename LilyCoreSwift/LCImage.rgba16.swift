//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public class LCImageRGBA16 : LCImageGenericRaw<LLColor16>
{    
    public override func requestFunctionOfConvertRawColorFrom() -> ConvertFromFunc? { return LLColor16tof }
    public override func requestFunctionOfConvertRawColorTo() -> ConvertToFunc? { return LLColorfto16 }
    
    public required init( _ wid: Int, _ hgt: Int ) {
        super.init( wid, hgt )
        treatMemory( wid, hgt, .rgba16 )
    }
}

