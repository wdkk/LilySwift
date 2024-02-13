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

extension Lily.Stage
{
    open class LightingRenderer
    {        
        public var device: MTLDevice
        
        var lightingDepthState: MTLDepthStencilState?
        var lightingPipeline: MTLRenderPipelineState?
        
        public var cubeMap:MTLTexture?

        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device

            lightingPipeline = try! makeLightingRenderPipelineState( viewCount:viewCount )
            // ライティングデプスステートの作成
            lightingDepthState = makeLightingDepthState()
        }
        
        func makeLightingDepthState() -> MTLDepthStencilState? {
            let desc = MTLDepthStencilDescriptor()
            desc.depthCompareFunction = .always
            desc.isDepthWriteEnabled = false
            return device.makeDepthStencilState( descriptor:desc ) 
        }
        
        func makeLightingRenderPipelineState( viewCount:Int ) throws -> MTLRenderPipelineState? {
            let desc = MTLRenderPipelineDescriptor()
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            desc.label = "Lighting"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_LightingVs" ) )
            desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_LightingFs" ) )
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[0].pixelFormat = BufferFormats.GBuffer0
            desc.colorAttachments[1].pixelFormat = BufferFormats.GBuffer1
            desc.colorAttachments[2].pixelFormat = BufferFormats.GBuffer2
            desc.colorAttachments[3].pixelFormat = BufferFormats.GBufferDepth
            desc.colorAttachments[4].pixelFormat = BufferFormats.backBuffer
            desc.depthAttachmentPixelFormat = BufferFormats.depth
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
                   globalUniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>?,
                   renderTextures:RenderTextures
        )
        {
            guard let lighting_pp = lightingPipeline else { return }
            // ライティング描画
            renderEncoder?.setRenderPipelineState( lighting_pp )
            renderEncoder?.setDepthStencilState( lightingDepthState )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures.GBuffer0, index:0 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures.GBuffer1, index:1 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures.GBuffer2, index:2 )
            renderEncoder?.setFragmentMemoryLessTexture( renderTextures.GBufferDepth, index:3 )
            renderEncoder?.setFragmentTexture( renderTextures.shadowMap, index:5 )
            renderEncoder?.setFragmentTexture( cubeMap, index:6 )
            renderEncoder?.setFragmentBuffer( globalUniforms?.metalBuffer, offset:0, index:0 )
            renderEncoder?.drawPrimitives( type:.triangle, vertexStart:0, vertexCount:3 )
        }
    }
}
