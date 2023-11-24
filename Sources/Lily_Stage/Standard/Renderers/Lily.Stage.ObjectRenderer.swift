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
    open class ObjectRenderer
    {
        public var device: MTLDevice
        
        var objectPipeline: MTLRenderPipelineState?
        var objectShadowPipeline: MTLRenderPipelineState?
        
        public var models:[Model.Obj?] = []
        public var instanceBuffer:Lily.Metal.Buffer<float4x4>?
    
        public let cameraCount:Int = Shared.Const.shadowCascadesCount + 1
        public var maxModelCount:Int = 4
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )

            let renderPPDesc = MTLRenderPipelineDescriptor()
    
            renderPPDesc.label = "Objects Geometry"
            renderPPDesc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_ObjectVs" ) )
            renderPPDesc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_ObjectFs" ) )
            renderPPDesc.rasterSampleCount = BufferFormats.sampleCount
            
            renderPPDesc.colorAttachments[0].pixelFormat = BufferFormats.GBuffer0
            renderPPDesc.colorAttachments[1].pixelFormat = BufferFormats.GBuffer1
            renderPPDesc.colorAttachments[2].pixelFormat = BufferFormats.GBuffer2
            renderPPDesc.colorAttachments[3].pixelFormat = BufferFormats.GBufferDepth
            renderPPDesc.colorAttachments[4].pixelFormat = BufferFormats.backBuffer
            renderPPDesc.depthAttachmentPixelFormat = BufferFormats.depth
            renderPPDesc.maxVertexAmplificationCount = viewCount
            
            objectPipeline = try! device.makeRenderPipelineState(descriptor: renderPPDesc, options: [], reflection: nil)
            
            
            renderPPDesc.label = "Objects Shadow"
            renderPPDesc.vertexFunction = library.makeFunction( name:"Lily_Stage_ObjectShadowVs" )
            renderPPDesc.fragmentFunction = nil 
            renderPPDesc.rasterSampleCount = BufferFormats.sampleCount
            renderPPDesc.colorAttachments[0].pixelFormat = .invalid
            renderPPDesc.colorAttachments[1].pixelFormat = .invalid
            renderPPDesc.colorAttachments[2].pixelFormat = .invalid
            renderPPDesc.colorAttachments[3].pixelFormat = .invalid
            renderPPDesc.colorAttachments[4].pixelFormat = .invalid
            renderPPDesc.depthAttachmentPixelFormat = BufferFormats.depth
            renderPPDesc.maxVertexAmplificationCount = viewCount
                        
            objectShadowPipeline = try! device.makeRenderPipelineState( descriptor:renderPPDesc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>?
        )
        {
            guard let obj_pp = objectPipeline else { return }
            
            renderEncoder?.setRenderPipelineState( obj_pp )
            for model_idx in 0 ..< models.count {
                guard let model = models[model_idx],
                      let mesh = model.mesh 
                else { return }
            
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset:0, index:0 )
                renderEncoder?.setVertexBuffer( instanceBuffer?.metalBuffer, offset:0, index:1 )
                renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:2 )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount: maxModelCount
                )
            }
        }
        
        public func drawShadows(
            with renderEncoder:MTLRenderCommandEncoder?, 
            globalUniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>?,
            cascadeIndex:Int 
        )
        {
            guard let obj_shadow_pp = objectShadowPipeline else { return }
            renderEncoder?.setRenderPipelineState( obj_shadow_pp )

            var cam_idx = cascadeIndex + 1
            
            for model_idx in 0 ..< models.count {
                guard let model = models[model_idx],
                      let mesh = model.mesh
                else { return }
                
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset: 0, index: 0 )
                renderEncoder?.setVertexBuffer( instanceBuffer?.metalBuffer, offset: 0, index: 1 )
                renderEncoder?.setVertexBytes( &cam_idx, length:4, index:2 )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount: maxModelCount
                )
            }
        }
    }
}
