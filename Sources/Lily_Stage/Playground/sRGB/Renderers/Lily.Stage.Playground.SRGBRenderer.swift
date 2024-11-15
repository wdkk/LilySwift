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

extension Lily.Stage.Playground.sRGB
{
    open class Renderer
    {
        public typealias Playground = Lily.Stage.Playground
        
        public var device: MTLDevice
        
        var pipeline: MTLRenderPipelineState!
        
        public init( device:MTLDevice, environment:Lily.Metal.ShaderEnvironment, viewCount:Int ) {
            self.device = device
           
            let desc = MTLRenderPipelineDescriptor()
            desc.label = "Playground convert sRGB"
            
            if environment == .metallib && device.supportsFamily( .apple6 ) {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_SRGB_Vs" ) )
                desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground_SRGB_Fs" ) )
            }
            else {
                let sMetal = Lily.Stage.Playground.sRGB.SMetal.shared( device:device )
                desc.vertexShader( sMetal.vertexShader )
                desc.fragmentShader( sMetal.fragmentShader )            
            }

            desc.rasterSampleCount = Playground.BufferFormats.sampleCount
            
            desc.colorAttachments[0].pixelFormat = Playground.BufferFormats.backBuffer
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            
            pipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            mediumResource:Lily.Stage.Playground.MediumResource
        ) 
        {
            renderEncoder?.setRenderPipelineState( pipeline )
                    
            renderEncoder?.setFragmentTexture( mediumResource.resultTexture, index:0 )
            renderEncoder?.drawPrimitives( type:.triangle, vertexStart:0, vertexCount:3 )
        }
    }
}

#endif
