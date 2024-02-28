//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

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

fragment SRGBFOut Lily_Stage_Playground_SRGB_Fs(
    SRGBVOut         in                  [[ stage_in ]],
    texture2d_array<float> resultTexture [[ texture(0) ]]
)
{    
    const auto pixelPos = uint2( floor( in.position.xy ) );
    float4 color = resultTexture.read( pixelPos, in.ampID );
    
    color.xyz = pow( color.xyz, float3( 2.2 ) );
    
    SRGBFOut out;
    out.backBuffer = color;
    
    return out;
}
