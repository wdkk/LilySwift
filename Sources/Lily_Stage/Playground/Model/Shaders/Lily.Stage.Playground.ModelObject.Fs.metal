//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#import "Lily.Stage.Playground.ModelObject.h"

// フラグメントシェーダ
fragment GBufferFOut Lily_Stage_Playground_Model_Object_Fs
(
    const ModelVOut in [[ stage_in ]]
)
{
    BRDFSet brdf;
    brdf.albedo = saturate( in.color );
    brdf.normal = in.normal;
    brdf.specIntensity = 1.f;
    brdf.specPower = 1.f;
    brdf.ao = 0.f;
    brdf.shadow = 0.f;

    GBufferFOut output = BRDFToGBuffers( brdf );
    output.GBufferDepth = in.position.z;
    return output;
}
