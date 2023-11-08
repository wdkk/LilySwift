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

#if os(visionOS)
import CompositorServices
import Spatial
#endif

extension Lily.Stage
{   
    public struct ParticleVIn
    {
        public var pos = LLFloatv4()
        public var texUV = LLFloatv2()
    }
    
    public struct ParticleStatus
    {
        public var scale = LLFloatv2( 1.0, 1.0 )
        public var color = LLFloatv4( 0.0, 1.0, 1.0, 1.0 )
    }
        
    open class ParticleRenderer
    {
        var device: MTLDevice
        var mode:VisionMode
        
        let maxParticleCount:Int = 256
        
        var particlePipeline: MTLRenderPipelineState!
        var particles:Model.Quadrangles<ParticleVIn>?
            
        var modelMatrices:Lily.Metal.Buffer<LLMatrix4x4>?
        var statuses:Lily.Metal.Buffer<ParticleStatus>?
        
        init( device:MTLDevice, viewCount:Int, mode:VisionMode = .shared ) {
            self.device = device
            self.mode = mode
            
            setupParticles()
            setupModelMatrix()
            setupStatus()
            
            let renderPPDesc = MTLRenderPipelineDescriptor()
            
            let library = try! Lily.Stage.metalLibrary( of:device )
            let vs = Lily.Metal.Shader( device:device, mtllib:library, shaderName:"particleVs" )
            let fs = Lily.Metal.Shader( device:device, mtllib:library, shaderName:"particleFs" )
            
            renderPPDesc.label = "Particle Geometry"
            renderPPDesc.vertexShader( vs )
            renderPPDesc.fragmentShader( fs )
            renderPPDesc.rasterSampleCount = BufferFormats.sampleCount
            
            renderPPDesc.colorAttachments[0].pixelFormat = BufferFormats.backBuffer
            renderPPDesc.colorAttachments[0].composite( type:.alphaBlend )
            renderPPDesc.depthAttachmentPixelFormat = BufferFormats.depth
            renderPPDesc.maxVertexAmplificationCount = viewCount
            
            particlePipeline = try! device.makeRenderPipelineState(descriptor: renderPPDesc, options: [], reflection: nil)
        }
        
        func setupParticles() {
            particles = .init( device:device, count:maxParticleCount )
            
            for i in 0 ..< maxParticleCount {
                let p = particles!.memory!.advanced( by: i )
                
                p.pointee.p1 = .init( pos:.init( -0.5, -0.5, 0.0, 1.0 ), texUV:.init( 0.0, 0.0 ) )
                p.pointee.p2 = .init( pos:.init(  0.5, -0.5, 0.0, 1.0 ), texUV:.init( 1.0, 0.0 ) )
                p.pointee.p3 = .init( pos:.init( -0.5,  0.5, 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) )
                p.pointee.p4 = .init( pos:.init(  0.5,  0.5, 0.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
            }
            
            particles?.update()
        }
        
        func setupStatus() {
            statuses = .init( device:device, count:maxParticleCount )
            
            statuses?.update { acc in
                for i in 0 ..< maxParticleCount {
                    acc[i] = .init( scale:.init( 4.0, 4.0 ), color:.init( 0.0, 0.0, 1.0, 0.5 ) )
                }
            }
        }
        
        func setupModelMatrix() {
            modelMatrices = .init( device:device, count:maxParticleCount )
            
            modelMatrices?.update { acc in
                for i in 0 ..< maxParticleCount {
                    let x = (i / 16).f * 5.0 - 40.0
                    let z = (i % 16).f * 5.0 - 40.0
                    
                    acc[i] = .translate( x, 0, z )
                }
            }
        }
        
        func draw( 
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
