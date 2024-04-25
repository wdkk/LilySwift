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
    public static var h_SMetal:String { """
    #import <metal_stdlib>
    #import <TargetConditionals.h>
    //#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h"
    \(Lily.Stage.MemoryLess_SMetal)
    //#import "../../Utils/Shaders/Lily.Stage.Playground.GlobalUniform.h"
    \(Lily.Stage.Playground.GlobalUniform_h_SMetal)
    #import "Lily.Stage.Playground.Model.util.h"
    \(Lily.Stage.Playground.Model.util_h_SMetal)

    using namespace metal;
    using namespace Lily::Stage;
    using namespace Lily::Stage::Playground;

    namespace Lily
    {
        namespace Stage 
        {
            namespace Playground
            {
                namespace Model
                {
                    namespace Lighting
                    {
                        struct VOut
                        {
                            float4 position [[position]];
                            uint   ampID;
                        };
                        
                        struct FOut
                        {
                            float4 backBuffer [[ color(IDX_OUTPUT) ]];
                        };
                    }
                }
            }
        }
    }
    """
    }
}

#endif
