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

fragment SRGBFOut Lily_Stage_Playground_SRGB_Fs(
    SRGBVOut         in                  [[ stage_in ]],
    texture2d_array<float> resultTexture [[ texture(0) ]],
    constant bool   &alphaPremultiply    [[ buffer(0) ]]
)
{    
    const auto pixelPos = uint2( floor( in.position.xy ) );
    float4 color = resultTexture.read( pixelPos, in.ampID );
    
    color.xyz = pow( color.xyz, float3( 2.2 ) );
    if( alphaPremultiply ) { color.xyz = color.xyz / color.w; }
    
    SRGBFOut out;
    out.backBuffer = color;
    return out;
}
