//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//
  
#import "Lily.Stage.Playground.Model.Mesh.h"
    
kernel void Lily_Stage_Playground_Model_Mesh_Com_Delta
(
 constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
 device Model::Mesh::UnitStatus* statuses [[ buffer(1) ]],
 uint gid [[thread_position_in_grid]]
)
{
    auto us = statuses[gid];
    
    us.position += us.deltaPosition;
    us.scale += us.deltaScale;
    us.rotation += us.deltaRotation;
    us.color += us.deltaColor;
    us.life += us.deltaLife;
    
    statuses[gid] = us;
}
