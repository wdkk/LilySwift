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
    public static var Fs_SMetal:String { """
    //#import "Lily.Stage.Playground.SRGB.h"
    \(Lily.Stage.Playground.sRGB.h_SMetal)
    
    fragment SRGBFOut Lily_Stage_Playground_SRGB_Fs(
        SRGBVOut         in                  [[ stage_in ]],
        texture2d_array<float> resultTexture [[ texture(0) ]]
    )
    {    
        const auto pixelPos = uint2( floor( in.position.xy ) );
        float4 color = resultTexture.read( pixelPos, in.ampID );
        
        color.xyz = pow( color.xyz, float3( 2.2 ) );
        //color.w = 1.0;
        
        SRGBFOut out;
        out.backBuffer = color;
        
        return out;
    }

    """
    }
}
