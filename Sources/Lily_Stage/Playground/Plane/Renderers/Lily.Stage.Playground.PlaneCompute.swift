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
import MetalKit

extension Lily.Stage.Playground.Plane
{
    open class PlaneCompute
    {
        public var device: MTLDevice
        
        var pipeline: MTLComputePipelineState!
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment ) {
            self.device = device
            
            let desc = MTLComputePipelineDescriptor()
            desc.threadGroupSizeIsMultipleOfThreadExecutionWidth = true
            
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.computeShader( Lily.Metal.Shader( 
                    device:device,
                    mtllib:library, 
                    shaderName:"Lily_Stage_Playground_Plane_Compute" 
                ) ) 
            }
            else if environment == .string {
                /*
                let stringShader = Lily.Stage.Playground.ShaderString.shared( device:device )
                desc.computeShader( stringShader.PlaygroundComputeShader )
                */
            }
            
            pipeline = try? device.makeComputePipelineState(descriptor:desc, options: [], reflection: nil)
        }
        
        public func updateMatrices( 
            with commandBuffer:MTLCommandBuffer?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            mediumTexture:Lily.Stage.Playground.MediumTexture,
            storage:PlaneStorage,
            screenSize:CGSize
        )
        {
            let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
            
            computeEncoder?.setBuffer( globalUniforms?.metalBuffer, offset:0, index:0 )
            computeEncoder?.setBuffer( storage.statuses.metalBuffer, offset:0, index:1 )

            let count = storage.statuses.cpuBuffer.count
            
            computeEncoder?.setComputePipelineState( self.pipeline )
            computeEncoder?.dispatchThreadgroups(
                MTLSizeMake( count / 8, count / 8, 1 ),
                threadsPerThreadgroup: MTLSizeMake( 8, 8, 1 )
            )
            
            computeEncoder?.endEncoding()
        }
    }
}
