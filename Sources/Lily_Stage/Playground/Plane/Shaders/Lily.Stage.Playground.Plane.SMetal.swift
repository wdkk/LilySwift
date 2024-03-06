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

extension Lily.Stage.Playground.Plane
{   
    open class SMetal 
    {
        static var header:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;
        
        //-- Lily.Stage.Macro.metal --//
        \(Lily.Stage.Macro_SMetal)
        
        //-- Lily.Stage.MemoryLess.metal --//
        \(Lily.Stage.MemoryLess_SMetal)
        
        //-- Lily.Stage.MathMatrix.metal --//
        \(Lily.Stage.MathMatrix_SMetal)
        
        //-- Lily.Stage.CameraUniform.metal --//
        \(Lily.Stage.Playground.CameraUniform_SMetal)
        
        //-- Lily.Stage.GlobalUniform.metal --//
        \(Lily.Stage.Playground.GlobalUniform_SMetal)

        using namespace metal;
        using namespace Lily::Stage;
        using namespace Lily::Stage::Playground;

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

        //// 構造体 ////
            
        struct PlaneVIn
        {
            float2 xy;
            float2 uv;
            float2 texUV;
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

        struct PlaneVOut
        {
            float4 pos [[ position ]];
            float2 xy;
            float2 uv;
            float2 texUV;
            float4 color;
            float  shapeType;
        };

        struct PlaneResult 
        {
            float4 planeTexture [[ color(0) ]];
        };

        """ }
        
        static var ComDelta:String { """
        kernel void Lily_Stage_Playground_Plane_Com_Delta
        (
         constant GlobalUniformArray& uniformArray [[ buffer(0) ]],
         device PlaneUnitStatus* statuses [[ buffer(1) ]],
         uint gid [[thread_position_in_grid]]
        )
        {
            auto us = statuses[gid];
                
            us.position += us.deltaPosition;
            us.scale += us.deltaScale;
            us.angle += us.deltaAngle;
            us.color += us.deltaColor;
            us.life += us.deltaLife;
            
            statuses[gid] = us;
        }        
        """ }
        
        static var Vs:String { """
        
        vertex PlaneVOut Lily_Stage_Playground_Plane_Vs
        (
            const device PlaneVIn* in [[ buffer(0) ]],
            constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
            constant LocalUniform &localUniform [[ buffer(2) ]],
            const device PlaneUnitStatus* statuses [[ buffer(3) ]],
            ushort amp_id [[ amplification_id ]],
            uint vid [[ vertex_id ]],
            uint iid [[ instance_id ]]
        )
        {
            auto us = statuses[iid];
            
            if( us.compositeType != localUniform.shaderCompositeType ) { 
                PlaneVOut trush_vout;
                trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
                return trush_vout;
            }

            // 三角形が指定されているが, 描画が三角形でない場合
            if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
                PlaneVOut trush_vout;
                trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
                return trush_vout;    
            }
            
            // 三角形以外が指定されているが、描画が三角形である場合
            if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
                PlaneVOut trush_vout;
                trush_vout.pos = float4( 0, TOO_FAR, 0.0, 0 );
                return trush_vout;    
            }
                
            //GlobalUniform uniform = uniformArray.uniforms[amp_id];
            
            const int offset = localUniform.drawingOffset;
            PlaneVIn vin = in[offset + vid];

            float2 local_uv = vin.texUV;
            float4 atlas_uv = us.atlasUV;
            float2 tex_uv = float2
            ( 
             atlas_uv[0] * (1.0-local_uv.x) + atlas_uv[2] * local_uv.x,
             atlas_uv[1] * (1.0-local_uv.y) + atlas_uv[3] * local_uv.y
            );
            
            float z = (Z_INDEX_MAX - us.zIndex) / Z_INDEX_MAX;
            float4 coord = float4( vin.xy, z, 1 );

            PlaneVOut vout;
            vout.pos = localUniform.projectionMatrix * us.matrix * coord;
            vout.xy = vin.xy;
            vout.texUV = tex_uv;
            vout.uv = vin.uv;
            vout.color = us.color;
            vout.shapeType = float( us.shapeType );

            return vout;
        }
        
        """ }
        
        static var Fs:String { """
        namespace Lily
        {
            namespace Stage 
            {
                namespace Playground
                {
                    float4 drawPlane( PlaneVOut in ) {
                        return in.color;
                    }
                    
                    float4 drawCircle( PlaneVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = x * x + y * y;
                        if( r > 1.0 ) { discard_fragment(); }
                        return in.color;
                    } 
                    
                    float4 drawBlurryCircle( PlaneVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = sqrt( x * x + y * y );
                        if( r > 1.0 ) { discard_fragment(); }
                        
                        float4 c = in.color;
                        c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                        return c;
                    } 
                    
                    float4 drawPicture( PlaneVOut in, texture2d<float> tex ) {
                        constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                        
                        if( is_null_texture( tex ) ) { discard_fragment(); }
                        float4 tex_c = tex.sample( sampler, in.texUV );
                        float4 c = in.color;
                        tex_c[3] *= c[3];
                        return tex_c;
                    } 
                    
                    float4 drawMask( PlaneVOut in, texture2d<float> tex ) {
                        constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                        
                        if( is_null_texture( tex ) ) { discard_fragment(); }
                        
                        float4 tex_c = tex.sample( sampler, in.texUV );
                        float4 c = in.color;
                        c[3] *= tex_c[0];
                        return c;
                    } 
                }
            }
        }

        fragment PlaneResult Lily_Stage_Playground_Plane_Fs(
            const PlaneVOut in [[ stage_in ]],
            texture2d<float> tex [[ texture(1) ]]
        )
        {
            ShapeType type = ShapeType( in.shapeType );
            float4 color = float4( 0 );
            switch( type ) {
                case rectangle:
                    color = Lily::Stage::Playground::drawPlane( in );
                    break;
                case triangle:
                    color = Lily::Stage::Playground::drawPlane( in );
                    break;
                case circle:
                    color = Lily::Stage::Playground::drawCircle( in );
                    break;
                case blurryCircle:
                    color = Lily::Stage::Playground::drawBlurryCircle( in );
                    break;
                case picture:
                    color = Lily::Stage::Playground::drawPicture( in, tex );
                    break;
                case mask:
                    color = Lily::Stage::Playground::drawMask( in, tex );
                    break;
                default:
                    discard_fragment();
            }
            
            PlaneResult result;
            result.planeTexture = color;
            return result;
        }
        """ }

        public let comDeltaShader:Lily.Metal.Shader
        public let vertexShader:Lily.Metal.Shader
        public let fragmentShader:Lily.Metal.Shader
        
        private static var instance:SMetal?
        public static func shared( device:MTLDevice ) -> SMetal {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }

        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )

            self.comDeltaShader = .init(
                device:device, 
                code: Self.header + Self.ComDelta,
                shaderName:"Lily_Stage_Playground_Plane_Com_Delta" 
            )
            
            self.vertexShader = .init(
                device:device, 
                code: Self.header + Self.Vs,
                shaderName:"Lily_Stage_Playground_Plane_Vs" 
            )
            
            self.fragmentShader = .init(
                device:device,
                code: Self.header + Self.Fs,
                shaderName:"Lily_Stage_Playground_Plane_Fs" 
            )
        }
    }
}
