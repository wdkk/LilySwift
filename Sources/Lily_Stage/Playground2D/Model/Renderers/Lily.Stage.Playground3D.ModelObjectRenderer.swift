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
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.Stage.Playground3D.Model
{   
    open class ModelObjectRenderer
    {
        public var device: MTLDevice
        
        public var objectPipeline: MTLRenderPipelineState?
        public var shadowPipeline: MTLRenderPipelineState?
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )

            let desc = MTLRenderPipelineDescriptor()
    
            desc.label = "Playground3D Objects Geometry"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Vs" ) )
            desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Fs" ) )
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
            objectPipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
            
            desc.label = "Playground3D Objects Shadow"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Shadow_Vs" ) )
            desc.fragmentFunction = nil 
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[IDX_GBUFFER_0].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_1].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_2].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_DEPTH].pixelFormat = .invalid
            desc.colorAttachments[IDX_OUTPUT].pixelFormat = .invalid
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            shadowPipeline = try! device.makeRenderPipelineState( descriptor:desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            storage:ModelStorage
        )
        {
            guard let obj_pp = objectPipeline else { return }
            
            renderEncoder?.setRenderPipelineState( obj_pp )
            for (_, v) in storage.models {
                guard let data = v.meshData, let mesh = data.mesh else { return }
                var model_idx = v.modelIndex
                
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset:0, index:0 )
                renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:1 )
                renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:2 )
                renderEncoder?.setVertexBytes( &model_idx, length:4, index:3 )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount:storage.objCount
                )
            }
        }
        
        public func drawShadows(
            with renderEncoder:MTLRenderCommandEncoder?, 
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            shadowCamVPMatrices:[LLMatrix4x4],
            storage:ModelStorage,
            cascadeIndex:Int 
        )
        {
            guard let obj_shadow_pp = shadowPipeline else { return }
            renderEncoder?.setRenderPipelineState( obj_shadow_pp )

            var cam_idx = cascadeIndex + 1
            
            for (_, v) in storage.models {
                guard let data = v.meshData, let mesh = data.mesh else { return }
                var model_idx = v.modelIndex
                
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset: 0, index: 0 )
                renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:1 )
                renderEncoder?.setVertexBytes( &cam_idx, length:4, index:2 )
                renderEncoder?.setVertexBytes( &model_idx, length:4, index:3 ) 
                renderEncoder?.setVertexBytes( 
                    shadowCamVPMatrices, 
                    length:MemoryLayout<LLMatrix4x4>.stride * shadowCamVPMatrices.count,
                    index:6 
                )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount:storage.objCount
                )
            }
        }
    }
}
