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
#import "../../Utils/Shaders/Lily.Stage.Playground.GlobalUniform.h"

using namespace metal;
using namespace Lily::Stage;
using namespace Lily::Stage::Playground;

namespace Lily
{
    namespace Stage 
    {
        namespace Playground
        {
            namespace Plane
            {
                //// マクロ定義 ////
                constant float TOO_FAR = 999999.0;
                constant float Z_INDEX_MIN = 0.0;
                constant float Z_INDEX_MAX = 99999.0;
            
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

                struct VIn
                {
                    float2 xy;
                    float2 uv;
                    float2 texUV;
                };

                struct UnitStatus
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
                    uint  childDepth;
                    float enabled;
                    float state;
                    CompositeType compositeType;
                    ShapeType shapeType;
                };

                struct LocalUniform
                {
                    float4x4      projectionMatrix;
                    CompositeType shaderCompositeType;
                    DrawingType   drawingType;
                    int           drawingOffset;
                };        

                struct VOut
                {
                    float4 pos [[ position ]];
                    float2 xy;
                    float2 uv;
                    float2 texUV;
                    float4 color;
                    float  shapeType;
                };

                struct Result 
                {
                    float4 planeTexture [[ color(0) ]];
                };
            }
        }
    }
}
