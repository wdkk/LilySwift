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
            float _reserved;
            float _reserved2;
            float _reserved3;
            float enabled;
            float state;
            CompositeType compositeType;
            ShapeType shapeType;
        };
            
        struct PlaneLocalUniform
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
        
        static var vertexShaderCode:String { """
        
        vertex PlaneVOut Lily_Stage_Playground2D_Plane_Vs(
            const device PlaneVIn* in [[ buffer(0) ]],
            constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
            constant PlaneLocalUniform &localUniform [[ buffer(2) ]],
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
            
            const int offset = localUniform.drawingOffset;
            
            //GlobalUniform uniform = uniformArray.uniforms[amp_id];
            PlaneVIn vin = in[offset + vid];
            
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

            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_y = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
            
            // xy座標のアフィン変換
            float2 v_coord = float2(
                scx * cosv * x - sinv * scy * y + us.position.x,
                scx * sinv * x + cosv * scy * y + us.position.y + visibility_y
            );

            PlaneVOut vout;
            vout.pos = localUniform.projectionMatrix * float4( v_coord, (Z_INDEX_MAX - us.zIndex) / Z_INDEX_MAX, 1 );
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

        fragment PlaneResult Lily_Stage_Playground2D_Plane_Fs(
            const PlaneVOut in [[ stage_in ]],
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
            
            PlaneResult result;
            result.planeTexture = color;
            return result;
        }
        """ }

        public let playground2DVertexShader:Lily.Metal.Shader
        public let playground2DFragmentShader:Lily.Metal.Shader
        
        public static func shared( device:MTLDevice ) -> ShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:ShaderString?
        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )
            
            self.playground2DVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.vertexShaderCode,
                shaderName:"Lily_Stage_Playground2D_Plane_Vs" 
            )
            
            self.playground2DFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.fragmentShaderCode,
                shaderName:"Lily_Stage_Playground2D_Plane_Fs" 
            )
        }
    }
}
