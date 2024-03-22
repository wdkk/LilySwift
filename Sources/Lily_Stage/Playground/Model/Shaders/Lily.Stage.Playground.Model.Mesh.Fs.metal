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

// フラグメントシェーダ
fragment Model::GBufferFOut Lily_Stage_Playground_Model_Mesh_Fs
(
    const Model::Mesh::VOut in [[ stage_in ]]
)
{
    Model::BRDFSet brdf;
    brdf.albedo = saturate( in.color );
    brdf.normal = in.normal;
    brdf.specIntensity = 1.f;
    brdf.specPower = 1.f;
    brdf.ao = 0.f;
    brdf.shadow = 0.f;

    auto output = Model::BRDFToGBuffers( brdf );
    output.GBufferDepth = in.position.z;
    return output;
}
