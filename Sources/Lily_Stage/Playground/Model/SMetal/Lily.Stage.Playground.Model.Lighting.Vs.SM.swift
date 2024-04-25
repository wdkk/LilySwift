//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal
import simd

extension Lily.Stage.Playground.Model.Lighting
{
    public static var Vs_SMetal:String { """
    //#import "Lily.Stage.Playground.Model.Lighting.h"
    \(Lily.Stage.Playground.Model.Lighting.h_SMetal)
    
    vertex Model::Lighting::VOut Lily_Stage_Playground_Model_Lighting_Vs
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

        Model::Lighting::VOut out;
        out.position = float4( vertices[vid], 1.0, 1.0 );
        out.ampID = amp_id;
        return out;
    }

    """
    }
}

#endif
