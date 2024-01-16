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

extension Lily.Stage.Playground3D.Billboard
{
    open class BBAddRenderer
    {
        public var device: MTLDevice
        
        var pipeline: MTLRenderPipelineState!
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment, viewCount:Int ) {
            self.device = device
            
            let desc = MTLRenderPipelineDescriptor()
            desc.label = "Playground 3D Geometry(Add)"
            
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Billboard_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Billboard_Fs" ) )
            }
            else if environment == .string {
                let stringShader = Lily.Stage.Playground3D.Billboard.BBShaderString.shared( device:device )
                desc.vertexShader( stringShader.playground3DBillboardVertexShader )
                desc.fragmentShader( stringShader.playground3DBillboardFragmentShader )            
            }
            
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[0].pixelFormat = Lily.Stage.BufferFormats.linearSRGBBuffer
            desc.colorAttachments[0].composite( type:.add )
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            
            pipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            storage:Lily.Stage.Playground3D.Billboard.BBStorage
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // シェーダの合成タイプの設定も行う
            var local_uniform = BBLocalUniform( 
                shaderCompositeType:.add,
                drawingType:.quadrangles
            )
            
            renderEncoder?.setVertexBuffer( storage.particles.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<BBLocalUniform>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:1 )
            renderEncoder?.drawPrimitives( 
                type: .triangleStrip, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.capacity
            )
        }
        
        public func drawTriangle( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            storage:Lily.Stage.Playground3D.Billboard.BBStorage
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // シェーダの合成タイプの設定も行う
            var local_uniform = BBLocalUniform(
                shaderCompositeType:.add,
                drawingType:.triangles
            )
            
            renderEncoder?.setVertexBuffer( storage.particles.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<BBLocalUniform>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:1 )
            renderEncoder?.drawPrimitives( 
                type: .triangle, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.capacity
            )
        }
    }
}
