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
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            let desc = MTLRenderPipelineDescriptor()
            desc.label = "Playground 2D Geometry(AddBlend)"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2D_AddBlend_Vs" ) )
            desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2D_AddBlend_Fs" ) )
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
            var proj_matrix:LLMatrix4x4 = .pixelXYProjection( screenSize )
            
            renderEncoder?.setVertexBuffer( storage.particles?.metalBuffer, offset:0, index:0 )
            renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:1 )
            renderEncoder?.setVertexBytes( &proj_matrix, length:MemoryLayout<LLMatrix4x4>.stride, index:2 ) 
            renderEncoder?.setVertexBuffer( storage.statuses?.metalBuffer, offset:0, index:3 )
            renderEncoder?.drawPrimitives( 
                type: .triangleStrip, 
                vertexStart: 0, 
                vertexCount: 4,
                instanceCount: storage.particles!.count
            )
        }
    }
}
