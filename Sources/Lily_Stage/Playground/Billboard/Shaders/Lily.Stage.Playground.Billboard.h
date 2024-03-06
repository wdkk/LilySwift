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
#import "../../../Standard/Shaders/Lily.Stage.MathMatrix.metal"
#import "../../Utils/Shaders/Lily.Stage.Playground.GlobalUniform.metal"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Playground;

//// マクロ定義 ////
#define TOO_FAR 999999.0

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

//// 構造体 ////
    
struct BBVIn
{
    float4 xyzw;
    float2 uv;
    float2 texUV;
};

struct BBUnitStatus
{
    float4x4 matrix;
    float4 atlasUV;
    float4 color;
    float4 deltaColor;
    float3 position;
    float3 deltaPosition;
    float3 scale;
    float3 deltaScale;
    float3 rotation;
    float3 deltaRotation;
    float angle;
    float deltaAngle;
    float comboAngle;
    float _r1;
    float life;
    float deltaLife;
    float enabled;
    float state;
    CompositeType compositeType;
    ShapeType shapeType;
    uint  childDepth;
};
    
struct BBLocalUniform
{
    CompositeType shaderCompositeType;
    DrawingType   drawingType;
    int           drawingOffset;
};        

struct BBVOut
{
    float4 pos [[ position ]];
    float2 xy;
    float2 uv;
    float2 texUV;
    float4 color;
    float  shapeType;
};

struct BBResult 
{
    float4 billboardTexture [[ color(0) ]];
    float4 backBuffer [[ color(1) ]];
};
