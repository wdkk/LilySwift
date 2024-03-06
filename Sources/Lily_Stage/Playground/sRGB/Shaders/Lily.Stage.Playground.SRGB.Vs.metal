//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#import "Lily.Stage.Playground.SRGB.h"

vertex SRGBVOut Lily_Stage_Playground_SRGB_Vs
( 
 uint vid [[vertex_id]],
 ushort amp_id [[ amplification_id ]]
)
{
    const float2 vertices[] = {
        float2(-1, -1),
        float2( 3, -1),
        float2(-1,  3)
    };

    SRGBVOut out;
    out.position = float4( vertices[vid], 0.0, 1.0 );
    out.ampID = amp_id;
    return out;
}
