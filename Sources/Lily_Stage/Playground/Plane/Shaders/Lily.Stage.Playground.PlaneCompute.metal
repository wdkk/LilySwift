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
#import "../../../Standard/Shaders/Lily.Stage.MemoryLess.h.metal"

#import "../../../Standard/Shared/Lily.Stage.Shared.Const.metal"
#import "../../../Standard/Shared/Lily.Stage.Shared.GlobalUniform.metal"
#import "../../../Standard/Shaders/Lily.Stage.StageRenderer.util.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Shared;

//// マクロ定義 ////
#define TOO_FAR 999999.0
#define Z_INDEX_MIN 0.0
#define Z_INDEX_MAX 99999.0

//// 列挙子 ////
enum CompositeType : uint
{
    none  = 0,
    alpha = 1,
    add   = 2,
    sub   = 3
};
    
enum ShapeType : uint
{
    empty        = 0,
    rectangle    = 1,
    triangle     = 2,
    circle       = 3,
    blurryCircle = 4,
    picture      = 101,
    mask         = 102
};
    
enum DrawingType : uint
{
    quadrangles = 0,
    triangles   = 1
};  

struct PlaneUnitStatus
{
    float4x4 matrix;
    float4 atlasUV;
    float4 color;
    float4 deltaColor;
    float2 position;
    float2 deltaPosition;
    float2 scale;
    float2 deltaScale;
    float angle;
    float deltaAngle;
    float life;
    float deltaLife;
    float zIndex;
    float _reserved;
    float enabled;
    float state;
    CompositeType compositeType;
    ShapeType shapeType;
};

kernel void Lily_Stage_Playground_Plane_Compute
(
 constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
 device PlaneUnitStatus* statuses [[ buffer(1) ]],
 const uint2 tid [[thread_position_in_grid]],
 const uint2 tsid [[threads_per_grid]]
)
{
    auto idx = tid.x + tid.y * 8;
    auto us = statuses[idx];
    
}
