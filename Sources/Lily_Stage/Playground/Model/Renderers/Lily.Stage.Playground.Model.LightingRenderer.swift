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
    open class BaseLightingRenderer
    {        
        public var device: MTLDevice
        
        public var pipeline:MTLRenderPipelineState?
        public var depthState:MTLDepthStencilState?
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment, viewCount:Int ) {
            self.device = device

            pipeline = try! makeLightingRenderPipelineState( environment:environment, viewCount:viewCount )
            
            // ライティングデプスステートの作成
            depthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .always )
                .depthWriteEnabled( false )
            })
        }
        
        public func makeLightingRenderPipelineState( 
            environment:Lily.Stage.ShaderEnvironment, 
            viewCount:Int 
        )
        throws
        -> MTLRenderPipelineState?
        {
            let desc = MTLRenderPipelineDescriptor()

            desc.label = "Playground Model Lighting"
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Model_Lighting_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Model_Lighting_Fs" ) )
            }
            else if environment == .string {
                let sMetal = Lily.Stage.Playground.Model.LightingSMetal.shared( device:device )
                desc.vertexShader( sMetal.PlaygroundModelLightingVertexShader )
                desc.fragmentShader( sMetal.PlaygroundModelLightingFragmentShader )            
            }
            
            desc.rasterSampleCount = Lily.Stage.Playground.BufferFormats.sampleCount
            
            desc.colorAttachments[IDX_GBUFFER_0].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer0
            desc.colorAttachments[IDX_GBUFFER_1].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer1
            desc.colorAttachments[IDX_GBUFFER_2].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer2
            desc.colorAttachments[IDX_GBUFFER_DEPTH].pixelFormat = Lily.Stage.Playground.BufferFormats.GBufferDepth
            desc.colorAttachments[IDX_OUTPUT].pixelFormat = Lily.Stage.Playground.BufferFormats.linearSRGBBuffer
            desc.depthAttachmentPixelFormat = Lily.Stage.Playground.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            
            do {
                return try device.makeRenderPipelineState( descriptor:desc )
            }
            catch {
                throw NSError( domain:"lighting pipeline make failed. \(error)", code: 0, userInfo:nil )
            }
        }
        
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?, 
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Storage,
            renderTextures:RenderTextures?
        )
        {
            guard let lighting_pp = pipeline else { return }
            
            var clear_color = storage.clearColor
            
            // ライティング描画
            renderEncoder?.setRenderPipelineState( lighting_pp )
            renderEncoder?.setDepthStencilState( depthState )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer0, index:IDX_GBUFFER_0 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer1, index:IDX_GBUFFER_1 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer2, index:IDX_GBUFFER_2 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBufferDepth, index:IDX_GBUFFER_DEPTH )
            renderEncoder?.setFragmentTexture( renderTextures?.shadowMap, index:IDX_SHADOW_MAP )
            renderEncoder?.setFragmentTexture( storage.cubeMap, index:IDX_CUBE_MAP )
            renderEncoder?.setFragmentBuffer( globalUniforms?.metalBuffer, offset:0, index:0 )
            renderEncoder?.setFragmentBytes( &clear_color, length:MemoryLayout<LLColor>.stride, index:1 )
            renderEncoder?.drawPrimitives( type:.triangle, vertexStart:0, vertexCount:3 )
        }
    }
    
    open class LightingRenderer
    : BaseLightingRenderer
    {           
        public override init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment, viewCount:Int ) {
            super.init( device:device, environment:environment, viewCount:viewCount )
        }
    }
}
