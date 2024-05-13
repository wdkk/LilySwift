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

import MetalKit

extension Lily.Stage.Playground.Model.Mesh
{
    open class ComDelta
    {
        public typealias Model = Lily.Stage.Playground.Model
        
        public var device: MTLDevice
        
        var pipeline: MTLComputePipelineState!
        
        public init( device:MTLDevice, environment:Lily.Stage.ShaderEnvironment ) {
            self.device = device
            
            #if !targetEnvironment(simulator)
            let desc = MTLComputePipelineDescriptor()
            desc.threadGroupSizeIsMultipleOfThreadExecutionWidth = true
            
            if environment == .metallib && device.supportsFamily( .apple6 ) {
                let library = try! Lily.Stage.metalLibrary( of:device )
                desc.computeShader( Lily.Metal.Shader( 
                    device:device,
                    mtllib:library, 
                    shaderName:"Lily_Stage_Playground_Model_Mesh_Com_Delta" 
                ) ) 
            }
            else {
                let sMetal = SMetal.shared( device:device )
                desc.computeShader( sMetal.comDeltaShader )
            }
            
            pipeline = try? device.makeComputePipelineState(descriptor:desc, options: [], reflection: nil)
            #endif
        }
        
        public func updateMatrices( 
            with commandBuffer:MTLCommandBuffer?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>?,
            storage:Model.ModelStorage
        )
        {
            /*
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
            */
            storage.statuses.update { acc, _ in
                for i in 0 ..< acc.count-1 {
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    acc[i].position += acc[i].deltaPosition
                    acc[i].scale += acc[i].deltaScale
                    acc[i].rotation += acc[i].deltaRotation
                    acc[i].color += acc[i].deltaColor
                    acc[i].life += acc[i].deltaLife
                }
            }
            /*
            #endif
            */
        }
    }
}

#endif
