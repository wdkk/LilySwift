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

extension Lily.Stage.Playground.Model
{   
    open class ModelObjectShaderString
    {
        static var importsCode:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;

        #import <simd/simd.h>

        //-- Lily.Stage.CameraUniform.metal --//
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
                        simd::float3   position;
                        simd::float3   up;
                        simd::float3   right;
                        simd::float3   direction;
                    };
                };
            };
        };
        
        //-- Lily.Stage.GlobalUniform.metal --//
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
        
        //-- Lily.Stage.Model.Obj.metal --//
        
        namespace Lily
        {
            namespace Stage 
            {
                namespace Model
                {
                    namespace Obj
                    {
                        struct Vertex
                        {
                            simd::float3 position;
                            simd::float3 normal;
                            simd::float3 color;
                        };
                    };
                };
            };
        };
        
        
        //-- Lily.Stage.Playground.Model.util.metal --//
        
        using namespace Lily::Stage;
        using namespace Lily::Stage::Shared;
        using namespace Lily::Stage::Model;

        namespace Lily
        {
            namespace Stage 
            {
                namespace Playground
                {
                    constant int IDX_OUTPUT = 0;
                    constant int IDX_GBUFFER_0 = 1;
                    constant int IDX_GBUFFER_1 = 2;
                    constant int IDX_GBUFFER_2 = 3;
                    constant int IDX_GBUFFER_DEPTH = 4;
                    constant int IDX_SHADOW_MAP = 5;
                    constant int IDX_CUBE_MAP = 6;
                    
                    struct GBufferFOut 
                    {
                        float4 GBuffer0 [[ color(IDX_GBUFFER_0) ]];
                        float4 GBuffer1 [[ color(IDX_GBUFFER_1) ]];
                        float4 GBuffer2 [[ color(IDX_GBUFFER_2) ]];
                        float  GBufferDepth [[ color(IDX_GBUFFER_DEPTH) ]];
                    };
                    
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
                };
            };
        };
        
        using namespace Lily::Stage::Playground;
        
        """ }
        
        static var definesCode:String { """
        
        //// マクロ定義 ////
        #define TOO_FAR 999999.0

        // vertexからfragmentへ渡す値
        struct ModelVOut
        {
            float4 position [[ position ]];
            float3 color;
            float3 normal;
        };

        struct ModelUnitStatus
        {
            float4x4 matrix;
            float4   atlasUV;
            float4   color;
            float4   deltaColor;
            float3   position;
            float3   deltaPosition;
            float3   scale;
            float3   deltaScale;
            float3   rotate;
            float3   deltaRotate;
            float    life;
            float    deltaLife;
            float    enabled;
            float    state;
            int      modelIndex;
        };

        float4x4 rotateZ( float rad ) {
            return float4x4(
                float4( cos( rad ), -sin( rad ), 0, 0 ),
                float4( sin( rad ),  cos( rad ), 0, 0 ),
                float4( 0, 0, 1, 0 ),
                float4( 0, 0, 0, 1 )
            );
        }  

        float4x4 rotateY( float rad ) {
            return float4x4(
               float4( cos( rad ), 0, sin( rad ), 0 ),
               float4( 0, 1, 0, 0 ),
               float4( -sin( rad ), 0, cos( rad ), 0 ),
               float4( 0, 0, 0, 1 )
            );
        }

        float4x4 rotateX( float rad ) {
            return float4x4(
                float4( 1, 0, 0, 0 ),
                float4( 0, cos( rad ), -sin( rad ), 0 ),
                float4( 0, sin( rad ),  cos( rad ), 0 ),
                float4( 0, 0, 0, 1 )
            );
        }

        float4x4 rotate( float3 rad3 ) {
            auto Rz = rotateZ( rad3.z );
            auto Ry = rotateY( rad3.y );
            auto Rx = rotateX( rad3.x );
            return Rz * Ry * Rx;
        }

        float4x4 scale( float3 sc ) {
            return float4x4(
                float4( sc.x, 0, 0, 0 ),
                float4( 0, sc.y, 0, 0 ),
                float4( 0, 0, sc.z, 0 ),
                float4( 0, 0, 0, 1 )
            );
        }

        float4x4 translate( float3 pos ) {
            return float4x4( 
                float4( 1, 0, 0, 0 ),
                float4( 0, 1, 0, 0 ),
                float4( 0, 0, 1, 0 ),
                float4( pos, 1 )
            );
        }

        float4x4 affineTransform( float3 trans, float3 sc, float3 ro ) {
            return translate( trans ) * rotate( ro ) * scale( sc );
        }
        """ }
        
        static var vertexShaderCode:String { """
        
        vertex ModelVOut Lily_Stage_Playground_Model_Object_Vs
        (
            const device Obj::Vertex* in [[ buffer(0) ]],
            const device ModelUnitStatus* statuses [[ buffer(1) ]],
            constant GlobalUniformArray & uniformArray [[ buffer(2) ]],
            constant int& modelIndex [[ buffer(3) ]],
            ushort amp_id [[ amplification_id ]],
            uint vid [[ vertex_id ]],
            uint iid [[ instance_id ]]
        )
        {
            auto uniform = uniformArray.uniforms[amp_id];
            
            int idx = iid;
            
            auto us = statuses[idx];
            
            // 一致しないインスタンスは破棄
            if( us.modelIndex != modelIndex ) { 
                ModelVOut trush_vout;
                trush_vout.position = float4( 0, 0, TOO_FAR, 0 );
                return trush_vout;
            }
            
            float4 base_pos = float4( in[vid].position, 1.0 );
            
            // アフィン変換の作成
            float3 pos = us.position;
            float3 ro = us.rotate;
            float3 sc = us.scale;
            
            float4x4 TRS = affineTransform( pos, sc, ro );
            
            float4 world_pos = TRS * base_pos;
            
            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
            
            ModelVOut out;
            out.position = uniform.cameraUniform.viewProjectionMatrix * world_pos;
            out.position.z += visibility_z;
            out.color    = pow( in[vid].color, 1.0 / 2.2 );    // sRGB -> linear変換
            out.normal   = (TRS * float4(in[vid].normal, 0)).xyz;
            return out;
        }
        
        """ }
        
        static var fragmentShaderCode:String { """
        // フラグメントシェーダ
        fragment GBufferFOut Lily_Stage_Playground_Model_Object_Fs
        (
            const ModelVOut in [[ stage_in ]]
        )
        {
            BRDFSet brdf;
            brdf.albedo = saturate( in.color );
            brdf.normal = in.normal;
            brdf.specIntensity = 1.f;
            brdf.specPower = 1.f;
            brdf.ao = 0.f;
            brdf.shadow = 0.f;

            GBufferFOut output = BRDFToGBuffers( brdf );
            output.GBufferDepth = in.position.z;
            return output;
        }
        """ }
        
        
        static var shadowVertexShaderCode:String { """
        
        vertex ModelVOut Lily_Stage_Playground_Model_Object_Shadow_Vs
        (
            const device Obj::Vertex* in [[ buffer(0) ]],
            const device ModelUnitStatus* statuses [[ buffer(1) ]],
            const device uint& cascadeIndex [[ buffer(2) ]],
            constant int& modelIndex [[ buffer(3) ]],
            constant float4x4& shadowCameraVPMatrix[[ buffer(6) ]],
            ushort amp_id [[ amplification_id ]],
            uint vid [[ vertex_id ]],
            uint iid [[ instance_id ]]
        )
        {
            int idx = iid;
            
            auto us = statuses[idx];
            
            // 一致しないインスタンスは破棄
            if( us.modelIndex != modelIndex ) { 
                ModelVOut trush_vout;
                trush_vout.position = float4( 0, 0, TOO_FAR, 0 );
                return trush_vout;
            }
            
            float4 position = float4( in[vid].position, 1.0 );
            
            // アフィン変換の作成
            float3 pos = us.position;
            float3 ro = us.rotate;
            float3 sc = us.scale;
            
            float4x4 TRS = affineTransform( pos, sc, ro );
            float4 world_pos = TRS * position;
            
            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;

            ModelVOut out;
            out.position = shadowCameraVPMatrix * world_pos;
            out.position.z += visibility_z;
            return out;
        }
        
        """ }
        
        public let PlaygroundModelVertexShader:Lily.Metal.Shader
        public let PlaygroundModelFragmentShader:Lily.Metal.Shader
        public let PlaygroundModelShadowVertexShader:Lily.Metal.Shader

        public static func shared( device:MTLDevice ) -> ModelObjectShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:ModelObjectShaderString?
        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )
            
            self.PlaygroundModelVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.vertexShaderCode,
                shaderName:"Lily_Stage_Playground_Model_Object_Vs" 
            )
            
            self.PlaygroundModelFragmentShader = .init(
                device:device,
                code: Self.importsCode + Self.definesCode + Self.fragmentShaderCode,
                shaderName:"Lily_Stage_Playground_Model_Object_Fs" 
            )
            
            self.PlaygroundModelShadowVertexShader = .init(
                device:device, 
                code: Self.importsCode + Self.definesCode + Self.shadowVertexShaderCode,
                shaderName:"Lily_Stage_Playground_Model_Object_Shadow_Vs" 
            )
            
        }
    }
}
