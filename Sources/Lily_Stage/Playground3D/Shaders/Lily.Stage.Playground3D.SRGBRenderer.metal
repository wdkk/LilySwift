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
#import "../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"

#import "../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "../../Standard/Shaders/Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Shared;

struct SRGBVOut
{
    float4 position [[ position ]];
};
    
struct SRGBFOut
{
    float4 backBuffer [[ color(0) ]];
};

vertex SRGBVOut Lily_Stage_Playground3D_SRGB_Vs( uint vid [[vertex_id]] )
{
    const float2 vertices[] = {
        float2(-1, -1),
        float2( 3, -1),
        float2(-1,  3)
    };

    SRGBVOut out;
    out.position = float4( vertices[vid], 0.0, 1.0 );
    return out;
}

fragment SRGBFOut Lily_Stage_Playground3D_SRGB_Fs(
    SRGBVOut         in               [[ stage_in ]],
    texture2d<float> billboardTexture [[ texture(0) ]]
)
{    
    const auto pixelPos = uint2( floor( in.position.xy ) );
    float4 color = billboardTexture.read( pixelPos );
    
    color.xyz = pow( color.xyz, float3( 2.2 ) );
    
    SRGBFOut out;
    out.backBuffer = color;
    
    return out;
}
