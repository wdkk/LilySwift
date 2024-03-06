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

extension Lily.Stage.Model
{   
    public static var Obj_SMetal:String { """
        #import <simd/simd.h>

        namespace Lily
        {
            namespace Stage 
            {
                namespace Model
                {
                    namespace Obj
                    {
                        struct Vertex
                        {
                            simd::float3 position;
                            simd::float3 normal;
                            simd::float3 color;
                        };
                    };
                };
            };
        };
        """
    }
}
