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

extension Lily.Stage.Playground2D
{   
    open class ShaderString 
    {
        static var importsCode:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;

        #import <simd/simd.h>
        
        //-- Lily.Stage.Shared.Const.metal --//
        namespace Lily
        {
            namespace Stage 
            {
                namespace Shared 
                {
                    namespace Const
                    {
                        constant int shadowCascadesCount = 3;
                    };
                };
            };
        };
        
        //-- Lily.Stage.Shared.CameraUniform.metal --//
        namespace Lily
        {
            namespace Stage 
            {
                namespace Shared
                {
                    struct CameraUniform
                    {
                        simd::float4x4 viewMatrix;
                        simd::float4x4 projectionMatrix;
                        simd::float4x4 viewProjectionMatrix;
                        simd::float4x4 invOrientationProjectionMatrix;
                        simd::float4x4 invViewProjectionMatrix;
                        simd::float4x4 invProjectionMatrix;
                        simd::float4x4 invViewMatrix;
                    };
                };
            };
        };
        
        //-- Lily.Stage.Shared.GlobalUniform.metal --//
        namespace Lily
        {
            namespace Stage 
            {
                namespace Shared 
                {
                    struct GlobalUniform
                    {
                        CameraUniform   cameraUniform;
                        CameraUniform   shadowCameraUniforms[3];
                        
                        simd::float2    invScreenSize;
                        float           aspect;
                        
                        simd::float3    sunDirection;
                        float           projectionYScale;
                        float           ambientOcclusionContrast;
                        float           ambientOcclusionScale;
                        float           ambientLightScale;
                        
                        float           frameTime;
                    };
                
                    // Vision用のGlobalUniform
                    struct GlobalUniformArray
                    {
                        GlobalUniform uniforms[2];
                    };
                };
            };
        };
        
        //-- Lily.Stage.MemoryLess.h.metal --//
        #if ( !TARGET_OS_SIMULATOR || TARGET_OS_MACCATALYST )
        #define LILY_MEMORY_LESS 1
        #endif

        #if LILY_MEMORY_LESS
        #define lily_memory(i)      color(i) 
        #define lily_memory_float4  float4
        #define lily_memory_depth   float
        #else
        #define lily_memory(i)      texture(i)
        #define lily_memory_float4  texture2d<float>
        #define lily_memory_depth   depth2d<float>
        #endif
        
        //-- Lily.Stage.MemoryLess.metal --//
        namespace Lily
        {
            namespace Stage 
            {
                namespace MemoryLess
                {
                    #if LILY_MEMORY_LESS
                    float4 float4OfPos( uint2 pos, float4 mem ) { return mem; };
                    float depthOfPos( uint2 pos, float mem ) { return mem; };
                    #else
                    float4 float4OfPos( uint2 pos, texture2d<float> mem ) { return mem.read( pos ); };
                    float depthOfPos( uint2 pos, depth2d<float> mem ) { return mem.read( pos ); };
                    #endif
                };
            };
        };
        
        //-- Lily.Stage.StageRenderer.util.metal --//
        
        using namespace Lily::Stage;
        using namespace Lily::Stage::Shared;
        
        // G-BufferのFragmentの出力構造体
        struct GBufferFOut 
        {
            float4 GBuffer0 [[ color(0) ]];
            float4 GBuffer1 [[ color(1) ]];
            float4 GBuffer2 [[ color(2) ]];
            float  GBufferDepth [[ color(3) ]];
        };
        
        // BRDF: Bidirectional Reflectance Distribution Function (双方向反射率分布関数)
        // 不透明な表面で光がどのように反射するかを定義
        struct BRDFSet 
        {
            float3 albedo;
            float3 normal;
            float specIntensity;
            float specPower;
            float ao;
            float shadow;
        };
        
        inline GBufferFOut BRDFToGBuffers( thread BRDFSet &brdf ) {
            GBufferFOut fout;
            
            fout.GBuffer0 = float4( brdf.albedo, 0.0 );
            fout.GBuffer1 = float4( brdf.normal, 0.0 );
            fout.GBuffer2 = float4( brdf.specIntensity, brdf.specPower, brdf.shadow, brdf.ao );
            
            return fout;
        };
        
        inline BRDFSet GBuffersToBRDF( float4 GBuffer0, float4 GBuffer1, float4 GBuffer2 ) {
            BRDFSet brdf;
            
            brdf.albedo = GBuffer0.xyz;
            brdf.normal = GBuffer1.xyz;
            brdf.specIntensity = GBuffer2.x;
            brdf.specPower = GBuffer2.y;
            brdf.shadow = GBuffer2.z;
            brdf.ao = GBuffer2.w;
            
            return brdf;
        };
        
        """ }
        
        static var definesCode:String { """
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
            rectangle    = 0,
            triangle     = 1,
            circle       = 2,
            blurryCircle = 3,
            picture      = 100,
            mask         = 101
        };
            
        enum DrawingType : uint
        {
            quadrangles = 0,
            triangles   = 1
        };        
        
        //// 構造体 ////
            
        struct PG2DVIn
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
        
        struct PG2DVOut
        {
            float4 pos [[ position ]];
            float2 xy;
            float2 uv;
            float2 texUV;
            float4 color;
            float  shapeType;
        };
        
        struct PG2DResult 
        {
            float4 particleTexture [[ color(0) ]];
        };
        
        struct SRGBVOut
        {
            float4 position [[position]];
        };
            
        struct SRGBFOut
        {
            float4 backBuffer [[ color(1) ]];
        };
        
        """ }
        
        static var vertexShaderCode:String { """
        
        vertex PG2DVOut Lily_Stage_Playground2D_Vs(
            const device PG2DVIn* in [[ buffer(0) ]],
            constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
            constant LocalUniform &localUniform [[ buffer(2) ]],
            const device UnitStatus* statuses [[ buffer(3) ]],
            ushort amp_id [[ amplification_id ]],
            uint vid [[ vertex_id ]],
            uint iid [[ instance_id ]]
        )
        {
            UnitStatus us = statuses[iid];
            
            if( us.compositeType != localUniform.shaderCompositeType ) { 
                PG2DVOut trush_vout;
                trush_vout.pos = float4( 0, 0, -1000000, 0 );
                return trush_vout;
            }
        
            // 三角形が指定されているが, 描画が三角形でない場合
            if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
                PG2DVOut trush_vout;
                trush_vout.pos = float4( 0, 0, -1000000, 0 );
                return trush_vout;    
            }
            
            // 三角形以外が指定されているが、描画が三角形である場合
            if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
                PG2DVOut trush_vout;
                trush_vout.pos = float4( 0, 0, -1000000, 0 );
                return trush_vout;    
            }
            
            const int offset = localUniform.drawingOffset;
            
            GlobalUniform uniform = uniformArray.uniforms[amp_id];
            PG2DVIn vin = in[offset + vid];
            
            float cosv = cos( us.angle );
            float sinv = sin( us.angle );
            float x = vin.xy.x;
            float y = vin.xy.y;
            float scx = us.scale.x * 0.5;
            float scy = us.scale.y * 0.5;
        
            float4 atlas_uv = us.atlasUV;
        
            float min_u = atlas_uv[0];
            float min_v = atlas_uv[1];
            float max_u = atlas_uv[2];
            float max_v = atlas_uv[3];
        
            float u = vin.texUV.x;
            float v = vin.texUV.y;
        
            float2 tex_uv = float2( 
                min_u * (1.0-u) + max_u * u,
                min_v * (1.0-v) + max_v * v
            );
        
            // xy座標のアフィン変換
            float2 v_coord = float2(
                scx * cosv * x - sinv * scy * y + us.position.x,
                scx * sinv * x + cosv * scy * y + us.position.y 
            );
        
            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_z = us.state * us.enabled * us.color[3] - 0.00001;
            
            PG2DVOut vout;
            vout.pos = localUniform.projectionMatrix * float4( v_coord, visibility_z, 1 );
            vout.xy = vin.xy;
            vout.texUV = tex_uv;
            vout.uv = vin.uv;
            vout.color = us.color;
            vout.shapeType = float( us.shapeType );
        
            return vout;
        }
        
        """ }
        
        static var fragmentShaderCode:String { """
        namespace Lily
        {
            namespace Stage 
            {
                namespace Playground2D
                {
                    float4 drawPlane( PG2DVOut in ) {
                        return in.color;
                    }
                    
                    float4 drawCircle( PG2DVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = x * x + y * y;
                        if( r > 1.0 ) { discard_fragment(); }
                        return in.color;
                    } 
                    
                    float4 drawBlurryCircle( PG2DVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = sqrt( x * x + y * y );
                        if( r > 1.0 ) { discard_fragment(); }
                        
                        float4 c = in.color;
                        c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                        return c;
                    } 
                    
                    float4 drawPicture( PG2DVOut in, texture2d<float> tex ) {
                        constexpr sampler sampler( mip_filter::linear, mag_filter::linear, min_filter::linear );
                        
                        if( is_null_texture( tex ) ) { discard_fragment(); }
                        return tex.sample( sampler, in.texUV );
                    } 
                    
                    float4 drawMask( PG2DVOut in, texture2d<float> tex ) {
                        constexpr sampler sampler( mip_filter::linear, mag_filter::linear, min_filter::linear );
                        
                        if( is_null_texture( tex ) ) { discard_fragment(); }
                        
                        float4 tex_c = tex.sample( sampler, in.texUV );
                        float4 c = in.color;
                        c[3] *= tex_c[0];
                        return c;
                    } 
                }
            }
        }

        fragment PG2DResult Lily_Stage_Playground2D_Fs(
            const PG2DVOut in [[ stage_in ]],
            lily_memory_float4 out [[ lily_memory(0) ]],
            texture2d<float> tex [[ texture(1) ]]
        )
        {
            ShapeType type = ShapeType( in.shapeType );
            float4 color = float4( 0 );
            switch( type ) {
                case rectangle:
                    color = Lily::Stage::Playground2D::drawPlane( in );
                    break;
                case triangle:
                    color = Lily::Stage::Playground2D::drawPlane( in );
                    break;
                case circle:
                    color = Lily::Stage::Playground2D::drawCircle( in );
                    break;
                case blurryCircle:
                    color = Lily::Stage::Playground2D::drawBlurryCircle( in );
                    break;
                case picture:
                    color = Lily::Stage::Playground2D::drawPicture( in, tex );
                    break;
                case mask:
                    color = Lily::Stage::Playground2D::drawMask( in, tex );
                    break;
            }
            
            PG2DResult result;
            result.particleTexture = color;
            return result;
        }
        """ }

        static var sRGBVertexShaderCode:String { """
        vertex SRGBVOut Lily_Stage_Playground2D_SRGB_Vs( uint vid [[vertex_id]] )
        {
            const float2 vertices[] = {
                float2(-1, -1),
                float2( 3, -1),
                float2(-1,  3)
            };

            SRGBVOut out;
            out.position = float4( vertices[vid], 1.0, 1.0 );
            return out;
        }
        """ }
        
        static var sRGBFragmentShaderCode:String { """
        fragment SRGBFOut Lily_Stage_Playground2D_SRGB_Fs(
            SRGBVOut                 in               [[ stage_in ]],
            lily_memory_float4       particleTexture  [[ lily_memory(0) ]]
        )
        {    
            const auto pixelPos = uint2( floor( in.position.xy ) );

            float4 color = MemoryLess::float4OfPos( pixelPos, particleTexture );
            color.xyz = pow( color.xyz, float3( 2.2 ) );

            SRGBFOut out;
            out.backBuffer = color;
            
            return out;
        }
        """ }
        
        public let playground2DVertexShader:Lily.Metal.Shader
        public let playground2DFragmentShader:Lily.Metal.Shader
        public let sRGBVertexShader:Lily.Metal.Shader
        public let sRGBFragmentShader:Lily.Metal.Shader
        
        public static func shared( device:MTLDevice ) -> ShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:ShaderString?
        private init( device:MTLDevice ) {
            //LLLog( "文字列からシェーダを生成しています." )
            
            self.playground2DVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.vertexShaderCode,
                shaderName:"Lily_Stage_Playground2D_Vs" 
            )
            
            self.playground2DFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.fragmentShaderCode,
                shaderName:"Lily_Stage_Playground2D_Fs" 
            )
            
            self.sRGBVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.sRGBVertexShaderCode,
                shaderName:"Lily_Stage_Playground2D_SRGB_Vs" 
            )
            
            self.sRGBFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.sRGBFragmentShaderCode,
                shaderName:"Lily_Stage_Playground2D_SRGB_Fs" 
            )
        }
    }
}
