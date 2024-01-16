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

extension Lily.Stage.Playground3D
{
    open class ModelBaseLightingRenderer
    {        
        public var device: MTLDevice
        
        var pipeline: MTLRenderPipelineState?
        var depthState: MTLDepthStencilState?
        
        public var skyCubeMap: MTLTexture?

        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device

            pipeline = try! makeLightingRenderPipelineState( viewCount:viewCount )
            
            // ライティングデプスステートの作成
            depthState = device.makeDepthStencilState(descriptor: .make {
                $0
                .depthCompare( .always )
                .depthWriteEnabled( false )
            })
            //makeLightingDepthState()
        }
        
        /*
        func makeLightingDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .always
            desc.isDepthWriteEnabled = false
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        */
        
        func makeLightingRenderPipelineState( viewCount:Int ) throws -> MTLRenderPipelineState? {
            let desc = MTLRenderPipelineDescriptor()
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            desc.label = "Playground3D Model Lighting"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Lighting_Vs" ) )
            desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Lighting_Fs" ) )
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[IDX_GBUFFER_0].pixelFormat = Lily.Stage.BufferFormats.GBuffer0
            desc.colorAttachments[IDX_GBUFFER_1].pixelFormat = Lily.Stage.BufferFormats.GBuffer1
            desc.colorAttachments[IDX_GBUFFER_2].pixelFormat = Lily.Stage.BufferFormats.GBuffer2
            desc.colorAttachments[IDX_GBUFFER_DEPTH].pixelFormat = Lily.Stage.BufferFormats.GBufferDepth
            desc.colorAttachments[IDX_OUTPUT].pixelFormat = Lily.Stage.BufferFormats.linearSRGBBuffer
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
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
        
        
        public func draw( with renderEncoder:MTLRenderCommandEncoder?, 
                   globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
                   renderTextures:ModelRenderTextures?
        )
        {
            guard let lighting_pp = pipeline else { return }
            // ライティング描画
            renderEncoder?.setRenderPipelineState( lighting_pp )
            renderEncoder?.setDepthStencilState( depthState )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer0, index:IDX_GBUFFER_0 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer1, index:IDX_GBUFFER_1 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBuffer2, index:IDX_GBUFFER_2 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures?.GBufferDepth, index:IDX_GBUFFER_DEPTH )
            renderEncoder?.setFragmentTexture( renderTextures?.shadowMap, index:IDX_SHADOW_MAP )
            renderEncoder?.setFragmentTexture( skyCubeMap, index:IDX_CUBE_MAP )
            renderEncoder?.setFragmentBuffer( globalUniforms?.metalBuffer, offset:0, index:0 )
            renderEncoder?.drawPrimitives( type:.triangle, vertexStart:0, vertexCount:3 )
        }
    }
    
    open class ModelLightingRenderer
    : ModelBaseLightingRenderer
    {           
        public override init( device:MTLDevice, viewCount:Int ) {
            super.init( device:device, viewCount:viewCount )

            // Mipsを活用するためにKTXフォーマットを使う
            skyCubeMap = try! Lily.Metal.Texture.create( device:device, assetName:"skyCubeMap" )!
            .makeTextureView( pixelFormat:.rgba8Unorm )
        }
    }
}
