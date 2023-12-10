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
        static var imports:String { """
        #import <metal_stdlib>
        #import <TargetConditionals.h>
        
        using namespace metal;

        #import <simd/simd.h>
        
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
        
        static var defines:String { """
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
            float4 backBuffer [[ color(0) ]];
        };
        
        """ }
        
        static var vertexShader:String { """
        
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
        
        static var fragmentShader:String { """
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
            texture2d<float> tex [[ texture(0) ]]
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
            
            color.xyz = pow( color.xyz, float3( 2.2 ) );
            
            PG2DResult result;
            result.backBuffer = color;
            return result;
        }
        """ }
        
        public let vertexShader:Lily.Metal.Shader
        public let fragmentShader:Lily.Metal.Shader
        
        public static func shared( device:MTLDevice ) -> ShaderString {
            if instance == nil { instance = .init( device:device ) }
            return instance!
        }
        
        private static var instance:ShaderString?
        private init( device:MTLDevice ) {
            //LLLog( "文字列からシェーダを生成しています." )
            
            self.vertexShader = .init(
                device:device, 
                code: Self.imports + Self.defines + Self.vertexShader,
                shaderName:"Lily_Stage_Playground2D_Vs" 
            )
            
            self.fragmentShader = .init(
                device:device,
                code: Self.imports + Self.defines + Self.fragmentShader,
                shaderName:"Lily_Stage_Playground2D_Fs" 
            )
        }
    }
}