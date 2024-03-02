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
#import "./Lily.Stage.MemoryLess.h.metal"

#import "../Shared/Lily.Stage.Shared.GlobalUniform.metal"

using namespace metal;
using namespace Lily::Stage::Shared;

inline float4x4 rotateZ( float rad ) {
    return float4x4(
        float4( cos( rad ), -sin( rad ), 0, 0 ),
        float4( sin( rad ),  cos( rad ), 0, 0 ),
        float4( 0, 0, 1, 0 ),
        float4( 0, 0, 0, 1 )
    );
}  

inline float4x4 rotateY( float rad ) {
    return float4x4(
       float4( cos( rad ), 0, sin( rad ), 0 ),
       float4( 0, 1, 0, 0 ),
       float4( -sin( rad ), 0, cos( rad ), 0 ),
       float4( 0, 0, 0, 1 )
    );
}

inline float4x4 rotateX( float rad ) {
    return float4x4(
        float4( 1, 0, 0, 0 ),
        float4( 0, cos( rad ), -sin( rad ), 0 ),
        float4( 0, sin( rad ),  cos( rad ), 0 ),
        float4( 0, 0, 0, 1 )
    );
}

inline float4x4 rotate( float3 rad3 ) {
    auto Rz = rotateZ( rad3.z );
    auto Ry = rotateY( rad3.y );
    auto Rx = rotateX( rad3.x );
    return Rz * Ry * Rx;
}

inline float4x4 scale( float3 sc ) {
    return float4x4(
        float4( sc.x, 0, 0, 0 ),
        float4( 0, sc.y, 0, 0 ),
        float4( 0, 0, sc.z, 0 ),
        float4( 0, 0, 0, 1 )
    );
}

inline float4x4 translate( float3 pos ) {
    return float4x4( 
        float4( 1, 0, 0, 0 ),
        float4( 0, 1, 0, 0 ),
        float4( 0, 0, 1, 0 ),
        float4( pos, 1 )
    );
}

inline float4x4 affineTransform( float3 trans, float3 sc, float3 ro ) {
    return translate( trans ) * rotate( ro ) * scale( sc );
}
