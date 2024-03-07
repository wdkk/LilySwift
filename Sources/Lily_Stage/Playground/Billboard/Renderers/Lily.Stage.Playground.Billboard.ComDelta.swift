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

extension Lily.Stage.Playground.Billboard
{
    open class ComDelta
    {
        public var device: MTLDevice
        
        var pipeline: MTLComputePipelineState!
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment ) {
            self.device = device
            
            #if !targetEnvironment(simulator)
            let desc = MTLComputePipelineDescriptor()
            desc.threadGroupSizeIsMultipleOfThreadExecutionWidth = true
            
            if environment == .metallib {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.computeShader( Lily.Metal.Shader( 
                    device:device,
                    mtllib:library, 
                    shaderName:"Lily_Stage_Playground_Billboard_Com_Delta" 
                ) ) 
            }
            else if environment == .string {
                let sMetal = Lily.Stage.Playground.Billboard.SMetal.shared( device:device )
                desc.computeShader( sMetal.comDeltaShader )
            }
            
            pipeline = try? device.makeComputePipelineState(descriptor:desc, options: [], reflection: nil)
            #endif
        }
        
        public func updateMatrices( 
            with commandBuffer:MTLCommandBuffer?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Storage
        )
        {
            #if !targetEnvironment(simulator)
            let computeEncoder = commandBuffer?.makeComputeCommandEncoder()
            
            computeEncoder?.setBuffer( globalUniforms?.metalBuffer, offset:0, index:0 )
            computeEncoder?.setBuffer( storage.statuses.metalBuffer, offset:0, index:1 )

            let count = storage.statuses.cpuBuffer.count
            
            let thread_group_count = MTLSize(width: 32, height: 1, depth: 1)
            let thread_groups = MTLSize(width: count / thread_group_count.width, height: 1, depth: 1)
            computeEncoder?.setComputePipelineState( self.pipeline )
            computeEncoder?.dispatchThreadgroups( thread_groups, threadsPerThreadgroup:thread_group_count )
            
            computeEncoder?.endEncoding()
            #else
            storage.statuses.update { acc, _ in
                for i in 0 ..< acc.count-1 {
                    var us = acc[i]
                    if us.enabled == false || us.state == .trush { continue }
                    us.position += us.deltaPosition
                    us.scale += us.deltaScale
                    us.rotation += us.deltaRotation
                    us.angle += us.deltaAngle
                    us.color += us.deltaColor
                    us.life += us.deltaLife
                    acc[i] = us
                }
            }
            #endif
        }
    }
}
