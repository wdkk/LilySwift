//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

extension Lily.Stage.Playground.sRGB
{
    public static var h_SMetal:String { """
    #import <metal_stdlib>
    #import <TargetConditionals.h>

    using namespace metal;

    struct SRGBVOut
    {
        float4 position [[ position ]];
        uint   ampID;
    };
        
    struct SRGBFOut
    {
        float4 backBuffer [[ color(0) ]];
    };
    """
    }
}
