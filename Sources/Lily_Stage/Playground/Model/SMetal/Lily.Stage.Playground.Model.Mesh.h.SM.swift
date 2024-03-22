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

extension Lily.Stage.Playground.Model.Mesh
{
    public static var h_SMetal:String { """
    //#import "Lily.Stage.Playground.Model.util.h"
    \(Lily.Stage.Playground.Model.util_h_SMetal)
    //#import "../../../Standard/Shaders/Lily.Stage.MathMatrix.metal"
    \(Lily.Stage.MathMatrix_SMetal)
    //#import "../../../Standard/Shaders/Lily.Stage.Model.Obj.metal"
    \(Lily.Stage.Model.Obj_SMetal)
    
    using namespace metal;
    using namespace Lily::Stage::Model;
    using namespace Lily::Stage::Playground;

    namespace Lily
    {
        namespace Stage 
        {
            namespace Playground
            {
                namespace Model
                {       
                    namespace Mesh
                    {
                        // vertexからfragmentへ渡す値
                        struct VOut
                        {
                            float4 position [[ position ]];
                            float3 color;
                            float3 normal;
                        };
                        
                        struct UnitStatus
                        {
                            float4x4 matrix;
                            float4   atlasUV;
                            float4   color;
                            float4   deltaColor;
                            float3   position;
                            float3   deltaPosition;
                            float3   scale;
                            float3   deltaScale;
                            float3   rotation;
                            float3   deltaRotation;
                            float    life;
                            float    deltaLife;
                            float    enabled;
                            float    state;
                            int      modelIndex;
                        };
                    }
                }
            }
        }
    }
    """
    }
}
