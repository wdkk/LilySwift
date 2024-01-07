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

// TODO: 未実装
extension Lily.Stage.Playground3D
{   
    open class SRGBShaderString
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
            float zIndex;
            float _reserved;
            float _reserved2;
            float _reserved3;
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
            float4 position [[ position ]];
        };
            
        struct SRGBFOut
        {
            float4 backBuffer [[ color(1) ]];
        };
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
            out.position = float4( vertices[vid], 0.0, 1.0 );
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

        public let sRGBVertexShader:Lily.Metal.Shader
        public let sRGBFragmentShader:Lily.Metal.Shader
        
        public static func shared( device:MTLDevice ) -> SRGBShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:SRGBShaderString?
        private init( device:MTLDevice ) {
            //LLLog( "文字列からシェーダを生成しています." )
            
            self.sRGBVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.sRGBVertexShaderCode,
                shaderName:"Lily_Stage_Playground3D_SRGB_Vs" 
            )
            
            self.sRGBFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.sRGBFragmentShaderCode,
                shaderName:"Lily_Stage_Playground3D_SRGB_Fs" 
            )
        }
    }
}
