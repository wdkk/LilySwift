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

extension Lily.Stage.Playground2D
{
    open class AddRenderer
    {
        public var device: MTLDevice
        
        var pipeline: MTLRenderPipelineState!
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            let desc = MTLRenderPipelineDescriptor()
            desc.label = "Playground 2D Geometry(AddBlend)"
            
            if environment == .metallib {
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2D_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2D_Fs" ) )
            }
            else if environment == .string {
                let stringShader = Lily.Stage.Playground2D.ShaderString.shared( device:device )
                desc.vertexShader( stringShader.vertexShader )
                desc.fragmentShader( stringShader.fragmentShader )            
            }

            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[0].pixelFormat = Lily.Stage.BufferFormats.backBuffer
            desc.colorAttachments[0].composite( type:.add )
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            desc.maxVertexAmplificationCount = viewCount
            
            pipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            storage:Lily.Stage.Playground2D.Storage,
            screenSize:CGSize
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // プロジェクション行列を画面のピクセルサイズ変換に指定
            // シェーダの合成タイプの設定も行う
            var local_uniform = LocalUniform( 
                projectionMatrix:.pixelXYProjection( screenSize ),
                shaderCompositeType:.add
            )
            
            renderEncoder?.setVertexBuffer( storage.particles?.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<LocalUniform>.stride, index:2 )  
            renderEncoder?.setVertexBuffer( storage.statuses?.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:0 )
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
            storage:Lily.Stage.Playground2D.Storage,
            screenSize:CGSize
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // プロジェクション行列を画面のピクセルサイズ変換に指定
            // シェーダの合成タイプの設定も行う
            var local_uniform = LocalUniform( 
                projectionMatrix:.pixelXYProjection( screenSize ),
                shaderCompositeType:.add,
                drawingType:.triangles
            )
            
            renderEncoder?.setVertexBuffer( storage.particles?.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<LocalUniform>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses?.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:0 )
            renderEncoder?.drawPrimitives( 
                type: .triangle, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.capacity
            )
        }
    }
}
