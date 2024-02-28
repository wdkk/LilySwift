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

extension Lily.Stage.Playground.Billboard
{   
    open class BBShaderString
    {
        static var importsCode:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;

        #import <simd/simd.h>
                
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
                        simd::float4   frustumPlanes[6];
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
        using namespace metal;
        using namespace Lily::Stage;
        using namespace Lily::Stage::Shared;
        
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
        
        """ }
        
        static var vertexShaderCode:String { """
        
        vertex BBVOut Lily_Stage_Playground_Billboard_Vs(
            const device BBVIn* in [[ buffer(0) ]],
            constant GlobalUniformArray& uniformArray [[ buffer(1) ]],
            constant BBLocalUniform &localUniform [[ buffer(2) ]],
            const device BBUnitStatus* statuses [[ buffer(3) ]],
            ushort amp_id [[ amplification_id ]],
            uint vid [[ vertex_id ]],
            uint iid [[ instance_id ]]
        )
        {
            BBUnitStatus us = statuses[iid];
            
            if( us.compositeType != localUniform.shaderCompositeType ) { 
                BBVOut trush_vout;
                trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
                return trush_vout;
            }

            // 三角形が指定されているが, 描画が三角形でない場合
            if( us.shapeType == ShapeType::triangle && localUniform.drawingType != DrawingType::triangles ) {
                BBVOut trush_vout;
                trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
                return trush_vout;    
            }
            
            // 三角形以外が指定されているが、描画が三角形である場合
            if( us.shapeType != ShapeType::triangle && localUniform.drawingType == DrawingType::triangles ) {
                BBVOut trush_vout;
                trush_vout.pos = float4( 0, 0, TOO_FAR, 0 );
                return trush_vout;    
            }
            
            const int offset = localUniform.drawingOffset;
                
            GlobalUniform uniform = uniformArray.uniforms[amp_id];
            
            BBVIn vin = in[offset + vid];
                
            float4x4 modelMatrix = float4x4(
                float4( 1, 0, 0, 0 ),
                float4( 0, 1, 0, 0 ),
                float4( 0, 0, 1, 0 ),
                float4( us.position, 1 )
            );
            
            float4x4 vpMatrix = uniform.cameraUniform.viewProjectionMatrix;
            float4x4 mvpMatrix = vpMatrix * modelMatrix;
            
            float4 pos1 = mvpMatrix * in[offset + 0].xyzw;
            float4 pos2 = mvpMatrix * in[offset + 1].xyzw;
            float4 pos3 = mvpMatrix * in[offset + 2].xyzw;
            float4 pos4 = mvpMatrix * in[offset + 3].xyzw;
            
            float4 center_pos = (pos1 + pos2 + pos3 + pos4) / 4.0;

            constexpr float2 square_vertices[] = { 
                float2( -1.0, -1.0 ),
                float2(  1.0, -1.0 ),
                float2( -1.0,  1.0 ),
                float2(  1.0,  1.0 )
            };
            
            constexpr float2 triangle_vertices[] = { 
                float2(  0.0,  1.15470053838 ),
                float2( -1.0, -0.57735026919 ),
                float2(  1.0, -0.57735026919 ),
                float2(  0.0,  0.0 )
            };
            
            float4 atlas_uv = us.atlasUV;

            float2 min_uv = atlas_uv.xy;
            float2 max_uv = atlas_uv.zw;

            float u = vin.texUV.x;
            float v = vin.texUV.y;
            
            float cosv = cos( us.angle );
            float sinv = sin( us.angle );
            float scx = us.scale.x * 0.5;
            float scy = us.scale.y * 0.5;

            float2 tex_uv = float2( 
                min_uv[0] * (1.0-u) + max_uv[0] * u,
                min_uv[1] * (1.0-v) + max_uv[1] * v
            );

            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
                
            // ビルボード内ローカル座標
            float2 loc_pos = us.shapeType == ShapeType::triangle ? triangle_vertices[vid] : square_vertices[vid];
            
            float4 billboard_pos = float4(
                center_pos.x + (scx * cosv * loc_pos.x - sinv * scy * loc_pos.y) / uniform.aspect,
                center_pos.y + (scx * sinv * loc_pos.x + cosv * scy * loc_pos.y),
                center_pos.z + visibility_z,
                center_pos.w
            );

            BBVOut vout;
            vout.pos = billboard_pos;
            vout.xy = vin.xyzw.xy;
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
                namespace Playground
                {
                    float4 drawPlane( BBVOut in ) {
                        return in.color;
                    }
                    
                    float4 drawCircle( BBVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = x * x + y * y;
                        if( r > 1.0 ) { discard_fragment(); }
                        return in.color;
                    } 
                    
                    float4 drawBlurryCircle( BBVOut in ) {
                        float x = in.xy.x;
                        float y = in.xy.y;
                        float r = sqrt( x * x + y * y );
                        if( r > 1.0 ) { discard_fragment(); }
                        
                        float4 c = in.color;
                        c[3] *= (1.0 + cos( r * M_PI_F )) * 0.5;

                        return c;
                    } 
                    
                    float4 drawPicture( BBVOut in, texture2d<float> tex ) {
                        constexpr sampler sampler( mip_filter::nearest, mag_filter::nearest, min_filter::nearest );
                        
                        if( is_null_texture( tex ) ) { discard_fragment(); }
                        
                        float4 tex_c = tex.sample( sampler, in.texUV );
                        float4 c = in.color;
                        tex_c[3] *= c[3];
                        return tex_c;
                    } 
                    
                    float4 drawMask( BBVOut in, texture2d<float> tex ) {
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

        fragment BBResult Lily_Stage_Playground_Billboard_Fs(
            const BBVOut in [[ stage_in ]],
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
            }
            
            BBResult result;
            result.billboardTexture = color;
            result.backBuffer = color;
            return result;
        }
        
        """ }
        
        public let PlaygroundBillboardVertexShader:Lily.Metal.Shader
        public let PlaygroundBillboardFragmentShader:Lily.Metal.Shader

        public static func shared( device:MTLDevice ) -> BBShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:BBShaderString?
        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )
            
            self.PlaygroundBillboardVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.vertexShaderCode,
                shaderName:"Lily_Stage_Playground_Billboard_Vs" 
            )
            
            self.PlaygroundBillboardFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.fragmentShaderCode,
                shaderName:"Lily_Stage_Playground_Billboard_Fs" 
            )
        }
    }
}
