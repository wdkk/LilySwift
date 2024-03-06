//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//
  
#import "Lily.Stage.Playground.PlaneRenderer.h"
    
kernel void Lily_Stage_Playground_Plane_Com_Delta
(
 constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
 device PlaneUnitStatus* statuses [[ buffer(1) ]],
 uint gid [[thread_position_in_grid]]
)
{
    auto us = statuses[gid];
        
    us.position += us.deltaPosition;
    us.scale += us.deltaScale;
    us.angle += us.deltaAngle;
    us.color += us.deltaColor;
    us.life += us.deltaLife;
    
    statuses[gid] = us;
}
