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

extension Lily.Stage.Playground.Model.Object
{   
    open class SMetal
    {
        static var header:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        #import <simd/simd.h>
        
        using namespace metal;
                        
        //-- Lily.Stage.MemoryLess.metal --//
        \(Lily.Stage.MemoryLess_SMetal)
        
        //-- Lily.Stage.MathMatrix.metal --//
        \(Lily.Stage.MathMatrix_SMetal)
        
        //-- Lily.Stage.Model.Obj.metal --//
        \(Lily.Stage.Model.Obj_SMetal)

        //-- Lily.Stage.CameraUniform.h --//
        \(Lily.Stage.Playground.CameraUniform_h_SMetal)
        
        //-- Lily.Stage.GlobalUniform.h --//
        \(Lily.Stage.Playground.GlobalUniform_h_SMetal)
        
        //-- Lily.Stage.Macro.metal --//
        \(Lily.Stage.Macro_SMetal)

          
        using namespace Lily::Stage;
        using namespace Lily::Stage::Model;
        using namespace Lily::Stage::Playground;

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
        """ }
        
        static var Vs:String { """
        
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
        
        static var Fs:String { """
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
        
        
        static var shadowVs:String { """
        
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
        
        public let comDeltaShader:Lily.Metal.Shader
        public let vertexShader:Lily.Metal.Shader
        public let fragmentShader:Lily.Metal.Shader
        public let shadowVertexShader:Lily.Metal.Shader

        private static var instance:SMetal?
        public static func shared( device:MTLDevice ) -> SMetal {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private init( device:MTLDevice ) {
            LLLog( "文字列からシェーダを生成しています." )
            
            
            self.comDeltaShader = .init(
                device:device, 
                code:Lily.Stage.Playground.Plane.ComDelta_SMetal,
                shaderName:"Lily_Stage_Playground_Model_Object_Com_Delta" 
            )
            
            self.vertexShader = .init(
                device:device, 
                code: Self.header + Self.Vs,
                shaderName:"Lily_Stage_Playground_Model_Object_Vs" 
            )
            
            self.fragmentShader = .init(
                device:device,
                code: Self.header + Self.Fs,
                shaderName:"Lily_Stage_Playground_Model_Object_Fs" 
            )
            
            self.shadowVertexShader = .init(
                device:device, 
                code: Self.header + Self.shadowVs,
                shaderName:"Lily_Stage_Playground_Model_Object_Shadow_Vs" 
            )
            
        }
    }
}
