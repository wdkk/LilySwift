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
import simd

extension Lily.Stage.Playground.Model.Object
{
    public static var ComDelta_SMetal:String { """
    //#import "Lily.Stage.Playground.Model.Object.h"
    \(Lily.Stage.Playground.Model.Object.h_SMetal)
    
    kernel void Lily_Stage_Playground_Model_Object_Com_Delta
    (
     constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
     device Model::Object::UnitStatus* statuses [[ buffer(1) ]],
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
    """
    }
}
