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
    open class Playground2D {}
}

extension Lily.Stage.Playground2D
{
    public struct VertexIn
    {
        var xy = LLFloatv2()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
        var uv = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
        var texUV = LLFloatv2() // 0.0 ~ 1.0 テクスチャのuv座標
        
        public init( xy:LLFloatv2, uv:LLFloatv2, texUV:LLFloatv2 ) {
            self.xy = xy
            self.uv = uv
            self.texUV = texUV
        }
    }
            
    open class Renderer
    {
        public var device: MTLDevice
        
        var particlePipeline: MTLRenderPipelineState!
        
        public var particles:Lily.Stage.Model.Quadrangles<VertexIn>?
        public var modelMatrices:Lily.Metal.Buffer<LLMatrix4x4>?
        public var statuses:Lily.Metal.Buffer<UnitStatus>?
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )
            
            let renderPPDesc = MTLRenderPipelineDescriptor()
            renderPPDesc.label = "Playground 2D Particle Geometry"
            renderPPDesc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2DVs" ) )
            renderPPDesc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground2DFs" ) )
            renderPPDesc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            renderPPDesc.colorAttachments[0].pixelFormat = Lily.Stage.BufferFormats.backBuffer
            renderPPDesc.colorAttachments[0].composite( type:.alphaBlend )
            renderPPDesc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            renderPPDesc.maxVertexAmplificationCount = viewCount
            
            particlePipeline = try! device.makeRenderPipelineState(descriptor: renderPPDesc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            renderTextures:Lily.Stage.RenderTextures
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
