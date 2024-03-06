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
        
        //-- Lily.Stage.StageRenderer.util.metal --//
        inline float4x4 rotateZ( float rad ) {
            return float4x4(
                float4( cos( rad ), -sin( rad ), 0, 0 ),
                float4( sin( rad ),  cos( rad ), 0, 0 ),
                float4( 0, 0, 1, 0 ),
                float4( 0, 0, 0, 1 )
            );
        }  

        inline float4x4 rotateY( float rad ) {
            return float4x4(
               float4( cos( rad ), 0, sin( rad ), 0 ),
               float4( 0, 1, 0, 0 ),
               float4( -sin( rad ), 0, cos( rad ), 0 ),
               float4( 0, 0, 0, 1 )
            );
        }

        inline float4x4 rotateX( float rad ) {
            return float4x4(
                float4( 1, 0, 0, 0 ),
                float4( 0, cos( rad ), -sin( rad ), 0 ),
                float4( 0, sin( rad ),  cos( rad ), 0 ),
                float4( 0, 0, 0, 1 )
            );
        }

        inline float4x4 rotate( float3 rad3 ) {
            auto Rz = rotateZ( rad3.z );
            auto Ry = rotateY( rad3.y );
            auto Rx = rotateX( rad3.x );
            return Rz * Ry * Rx;
        }

        inline float4x4 scale( float3 sc ) {
            return float4x4(
                float4( sc.x, 0, 0, 0 ),
                float4( 0, sc.y, 0, 0 ),
                float4( 0, 0, sc.z, 0 ),
                float4( 0, 0, 0, 1 )
            );
        }

        inline float4x4 translate( float3 pos ) {
            return float4x4( 
                float4( 1, 0, 0, 0 ),
                float4( 0, 1, 0, 0 ),
                float4( 0, 0, 1, 0 ),
                float4( pos, 1 )
            );
        }

        inline float4x4 affineTransform( float3 trans, float3 sc, float3 ro ) {
            return translate( trans ) * rotate( ro ) * scale( sc );
        }
        
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
            float2 scale;
            float2 deltaScale;
            float3 rotate;
            float3 deltaRotate;
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
             
            GlobalUniform uniform = uniformArray.uniforms[amp_id];
            CameraUniform camera = uniform.cameraUniform;
         
            const int offset = localUniform.drawingOffset;
            BBVIn vin = in[offset + vid];
            
            // 表示/非表示の判定( state, enabled, alphaのどれかが非表示を満たしているかを計算. 負の値 = 非表示 )
            float visibility_z = us.state * us.enabled * us.color[3] > 0.00001 ? 0.0 : TOO_FAR;
            
            // ビルボードの回転
            float3 ro = us.rotate;
            // スケーリング
            float3 sc = float3( us.scale * 0.5, 1.0 );
            // 移動量
            float3 t  = us.position;
            
            // ビルボードのモデル行列
            float4x4 modelMatrix = affineTransform( t, sc, ro );
            float4x4 vpMatrix = camera.viewProjectionMatrix;
            float4x4 pMatrix = camera.projectionMatrix;
            float4x4 vMatrix = camera.viewMatrix;
            
            // ビルボードを構成する板ポリゴンのローカル座標
            float4 coord = in[offset + vid].xyzw;
            
            //-----------//
            // ビルボード中央座標のワールド座標
            float4 worldPosition = modelMatrix * float4(0, 0, 0, 1);
            // カメラup = ビルボードupで、そのワールド座標
            float3 worldUp = float3( vMatrix[0][1], vMatrix[1][1], vMatrix[2][1] );
            
            // カメラの視線方向を正面方向とする
            float3 forward = normalize( -camera.direction );
            float3 up = normalize( worldUp );
            float3 right = cross( up, forward );

            // ビルボードのスケーリングを適用
            right *= sc.x;
            up *= sc.y;

            // ビルボードのモデル行列を再構築
            float4x4 bbModelMatrix = {
                float4(right, 0.0),
                float4(up, 0.0),
                float4(forward, 0.0),
                float4(worldPosition.xyz, 1.0)
            };

            // 最終的なビルボードの座標
            float4 billboard_pos = vpMatrix * bbModelMatrix * coord;
            //-----------//
            

            float2 local_uv = vin.texUV;
            float4 atlas_uv = us.atlasUV;
            float2 tex_uv = {
                atlas_uv[0] * (1.0-local_uv.x) + atlas_uv[2] * local_uv.x,
                atlas_uv[1] * (1.0-local_uv.y) + atlas_uv[3] * local_uv.y
            };

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
                default:
                    discard_fragment();
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
