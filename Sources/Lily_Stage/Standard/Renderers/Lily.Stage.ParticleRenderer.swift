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
    public struct ParticleVIn
    {
        public var pos = LLFloatv4()
        public var texUV = LLFloatv2()
        
        public init( pos:LLFloatv4, texUV:LLFloatv2 ) {
            self.pos = pos
            self.texUV = texUV
        }
    }
    
    public struct ParticleStatus
    {
        public var scale = LLFloatv2( 1.0, 1.0 )
        public var color = LLFloatv4( 0.0, 1.0, 1.0, 1.0 )
        
        public init( scale:LLFloatv2, color:LLFloatv4 ) {
            self.scale = scale
            self.color = color
        }
    }
        
    open class ParticleRenderer
    {
        public var device: MTLDevice
        
        var particlePipeline: MTLRenderPipelineState!
        
        public var particles:Model.Quadrangles<ParticleVIn>?
        public var modelMatrices:Lily.Metal.Buffer<LLMatrix4x4>?
        public var statuses:Lily.Metal.Buffer<ParticleStatus>?
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            let renderPPDesc = MTLRenderPipelineDescriptor()
            renderPPDesc.label = "Particle Geometry"
            renderPPDesc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_ParticleVs" ) )
            renderPPDesc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_ParticleFs" ) )
            renderPPDesc.rasterSampleCount = BufferFormats.sampleCount
            
            renderPPDesc.colorAttachments[0].pixelFormat = BufferFormats.backBuffer
            renderPPDesc.colorAttachments[0].composite( type:.alphaBlend )
            renderPPDesc.depthAttachmentPixelFormat = BufferFormats.depth
            renderPPDesc.maxVertexAmplificationCount = viewCount
            
            particlePipeline = try! device.makeRenderPipelineState( descriptor:renderPPDesc, options: [], reflection: nil )
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Shared.GlobalUniformArray>?,
            renderTextures:RenderTextures
        ) 
        {
            renderEncoder?.setRenderPipelineState( particlePipeline )
            
            renderEncoder?.setVertexBuffer( particles?.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBuffer( modelMatrices?.metalBuffer, offset:0, index:2 )
            renderEncoder?.setVertexBuffer( statuses?.metalBuffer, offset:0, index:3 )
            renderEncoder?.drawPrimitives(
                type: .triangleStrip, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: particles!.count
            )
        }
    }
}
