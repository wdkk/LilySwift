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

extension Lily.Stage.Playground.Model.Mesh
{   
    open class Renderer
    {
        public typealias Model = Lily.Stage.Playground.Model
        
        public var device: MTLDevice
        
        public var meshPipeline: MTLRenderPipelineState?
        public var shadowPipeline: MTLRenderPipelineState?
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment, viewCount:Int ) {
            self.device = device
            let desc = MTLRenderPipelineDescriptor()
    
            desc.label = "Playground Meshes Geometry"
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Model_Mesh_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Model_Mesh_Fs" ) )
            }
            else if environment == .string {
                let sMetal = Lily.Stage.Playground.Model.Mesh.SMetal.shared( device:device )
                desc.vertexShader( sMetal.vertexShader )
                desc.fragmentShader( sMetal.fragmentShader )            
            }
        
            desc.rasterSampleCount = Lily.Stage.Playground.BufferFormats.sampleCount
            
            desc.colorAttachments[Model.IDX_GBUFFER_0].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer0
            desc.colorAttachments[Model.IDX_GBUFFER_1].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer1
            desc.colorAttachments[Model.IDX_GBUFFER_2].pixelFormat = Lily.Stage.Playground.BufferFormats.GBuffer2
            desc.colorAttachments[Model.IDX_GBUFFER_DEPTH].pixelFormat = Lily.Stage.Playground.BufferFormats.GBufferDepth
            desc.colorAttachments[Model.IDX_OUTPUT].pixelFormat = Lily.Stage.Playground.BufferFormats.linearSRGBBuffer
            desc.depthAttachmentPixelFormat = Lily.Stage.Playground.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            meshPipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
            
            desc.label = "Playground Meshs Shadow"
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Model_Mesh_Shadow_Vs" ) )
                desc.fragmentFunction = nil 
            }
            else if environment == .string {
                let sMetal = Lily.Stage.Playground.Model.Mesh.SMetal.shared( device:device )
                desc.vertexShader( sMetal.shadowVertexShader )
                desc.fragmentFunction = nil          
            }

            desc.rasterSampleCount = Lily.Stage.Playground.BufferFormats.sampleCount
            
            desc.colorAttachments[Model.IDX_GBUFFER_0].pixelFormat = .invalid
            desc.colorAttachments[Model.IDX_GBUFFER_1].pixelFormat = .invalid
            desc.colorAttachments[Model.IDX_GBUFFER_2].pixelFormat = .invalid
            desc.colorAttachments[Model.IDX_GBUFFER_DEPTH].pixelFormat = .invalid
            desc.colorAttachments[Model.IDX_OUTPUT].pixelFormat = .invalid
            desc.depthAttachmentPixelFormat = Lily.Stage.Playground.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            shadowPipeline = try! device.makeRenderPipelineState( descriptor:desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Model.ModelStorage
        )
        {
            guard let obj_pp = meshPipeline else { return }
            
            renderEncoder?.setRenderPipelineState( obj_pp )
            for (_, v) in storage.models {
                guard let mesh = v.meshData else { continue }
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
                    instanceCount:storage.modelCapacity
                )
            }
        }
        
        public func drawShadows(
            with renderEncoder:MTLRenderCommandEncoder?, 
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            shadowCamVPMatrices:[LLMatrix4x4],
            storage:Model.ModelStorage,
            cascadeIndex:Int 
        )
        {
            guard let obj_shadow_pp = shadowPipeline else { return }
            renderEncoder?.setRenderPipelineState( obj_shadow_pp )

            var cam_idx = cascadeIndex + 1
            
            for (k, v) in storage.models {
                // TODO: 仮にplaneは影描かないようにした
                if k == "plane" { continue }
                guard let mesh = v.meshData else { continue }
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
                    instanceCount:storage.modelCapacity
                )
            }
        }
    }
}
