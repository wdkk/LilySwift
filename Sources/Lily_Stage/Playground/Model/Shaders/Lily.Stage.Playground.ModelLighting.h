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
#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h"
#import "../../Utils/Shaders/Lily.Stage.Playground.GlobalUniform.h"

#import "Lily.Stage.Playground.Model.util.h"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Playground;

struct LightingVOut
{
    float4 position [[position]];
    uint   ampID;
};

struct LightingFOut
{
    float4 backBuffer [[ color(IDX_OUTPUT) ]];
};
