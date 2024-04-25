//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal
import simd

extension Lily.Stage.Playground.Billboard
{
    open class SubRenderer
    {
        public var device: MTLDevice
        
        var pipeline: MTLRenderPipelineState!
        var funcTable: MTLVisibleFunctionTable?
        
        public init( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            bbFunctions:[BBFunction]
        ) 
        {
            self.device = device
            
            let desc = MTLRenderPipelineDescriptor()
            desc.label = "Playground 3D Geometry(Sub)"
                        
            if environment == .metallib && device.supportsFamily( .apple6 ) {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Billboard_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_Billboard_Fs" ) )
            }
            else {
                let sMetal = Lily.Stage.Playground.Billboard.SMetal.shared( device:device )
                desc.vertexShader( sMetal.vertexShader )
                desc.fragmentShader( sMetal.fragmentShader )
            }
            
            let functions = bbFunctions.metalFunctions
            if device.supportsFamily( .apple6 ) {
                let linkedFuncs = MTLLinkedFunctions()
                linkedFuncs.functions = functions
                desc.fragmentLinkedFunctions = linkedFuncs
            }
            
            desc.rasterSampleCount = Lily.Stage.Playground.BufferFormats.sampleCount
            
            desc.colorAttachments[0].pixelFormat = Lily.Stage.Playground.BufferFormats.linearSRGBBuffer
            desc.colorAttachments[0].composite( type:.add )
            desc.depthAttachmentPixelFormat = Lily.Stage.Playground.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            
            pipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
            
            if device.supportsFamily( .apple6 ) {
                // function tableの作成
                let funcDescriptor = MTLVisibleFunctionTableDescriptor()
                funcDescriptor.functionCount = functions.count
                
                funcTable = pipeline.makeVisibleFunctionTable( descriptor:funcDescriptor, stage:.fragment )
                for idx in 0 ..< functions.count {
                    let fs_handle = pipeline.functionHandle(function:functions[idx], stage:.fragment )
                    funcTable?.setFunction( fs_handle, index:idx )
                }
            } 
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Lily.Stage.Playground.Billboard.BBStorage
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // シェーダの合成タイプの設定も行う
            var local_uniform = LocalUniform( 
                shaderCompositeType:.sub,
                drawingType:.quadrangles
            )
            
            renderEncoder?.setVertexBuffer( storage.particles.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<LocalUniform>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:1 )
            if device.supportsFamily( .apple6 ) {
                renderEncoder?.setFragmentVisibleFunctionTable( funcTable, bufferIndex:0 )
            }

            renderEncoder?.drawPrimitives( 
                type: .triangleStrip, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.capacity
            )
        }
        
        public func drawTriangle( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Lily.Stage.Playground.Billboard.BBStorage
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
            
            // シェーダの合成タイプの設定も行う
            var local_uniform = LocalUniform(
                shaderCompositeType:.sub,
                drawingType:.triangles
            )
            
            renderEncoder?.setVertexBuffer( storage.particles.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &local_uniform, length:MemoryLayout<LocalUniform>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses.metalBuffer, offset:0, index:3 )
            renderEncoder?.setFragmentTexture( storage.textureAtlas.metalTexture, index:1 )
            if device.supportsFamily( .apple6 ) {
                renderEncoder?.setFragmentVisibleFunctionTable( funcTable, bufferIndex:0 )
            }
            
            renderEncoder?.drawPrimitives( 
                type: .triangle, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.capacity
            )
        }
    }
}

#endif
