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
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.Stage.Playground3D
{   
    open class ModelBaseObjectRenderer
    {
        public var device: MTLDevice
        
        var objectPipeline: MTLRenderPipelineState?
        var shadowPipeline: MTLRenderPipelineState?
        
        public var models:[Lily.Stage.Model.Obj?] = []
        public var instanceBuffer:Lily.Metal.Buffer<float4x4>?
    
        public let cameraCount:Int = Lily.Stage.Shared.Const.shadowCascadesCount + 1
        public var maxModelCount:Int = 4
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.device = device
            let library = try! Lily.Stage.metalLibrary( of:device )

            let desc = MTLRenderPipelineDescriptor()
    
            desc.label = "Playground3D Objects Geometry"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Vs" ) )
            desc.fragmentShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Fs" ) )
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            
            desc.colorAttachments[IDX_GBUFFER_0].pixelFormat = Lily.Stage.BufferFormats.GBuffer0
            desc.colorAttachments[IDX_GBUFFER_1].pixelFormat = Lily.Stage.BufferFormats.GBuffer1
            desc.colorAttachments[IDX_GBUFFER_2].pixelFormat = Lily.Stage.BufferFormats.GBuffer2
            desc.colorAttachments[IDX_GBUFFER_DEPTH].pixelFormat = Lily.Stage.BufferFormats.GBufferDepth
            desc.colorAttachments[IDX_OUTPUT].pixelFormat = Lily.Stage.BufferFormats.backBuffer
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            objectPipeline = try! device.makeRenderPipelineState(descriptor: desc, options: [], reflection: nil)
            
            
            desc.label = "Playground3D Objects Shadow"
            desc.vertexShader( .init( device:device, mtllib:library, shaderName:"Lily_Stage_Playground3D_Model_Object_Shadow_Vs" ) )
            desc.fragmentFunction = nil 
            desc.rasterSampleCount = Lily.Stage.BufferFormats.sampleCount
            desc.colorAttachments[IDX_GBUFFER_0].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_1].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_2].pixelFormat = .invalid
            desc.colorAttachments[IDX_GBUFFER_DEPTH].pixelFormat = .invalid
            desc.colorAttachments[IDX_OUTPUT].pixelFormat = .invalid
            desc.depthAttachmentPixelFormat = Lily.Stage.BufferFormats.depth
            if #available( macCatalyst 13.4, * ) {
                desc.maxVertexAmplificationCount = viewCount
            }
            shadowPipeline = try! device.makeRenderPipelineState( descriptor:desc, options: [], reflection: nil)
        }
        
        public func draw( 
            with renderEncoder:MTLRenderCommandEncoder?,
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?
        )
        {
            guard let obj_pp = objectPipeline else { return }
            
            renderEncoder?.setRenderPipelineState( obj_pp )
            for model_idx in 0 ..< models.count {
                guard let model = models[model_idx], let mesh = model.mesh else { return }
            
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset:0, index:0 )
                renderEncoder?.setVertexBuffer( instanceBuffer?.metalBuffer, offset:0, index:1 )
                renderEncoder?.setVertexBuffer( globalUniforms?.metalBuffer, offset:0, index:2 )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount: maxModelCount
                )
            }
        }
        
        public func drawShadows(
            with renderEncoder:MTLRenderCommandEncoder?, 
            globalUniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>?,
            cascadeIndex:Int 
        )
        {
            guard let obj_shadow_pp = shadowPipeline else { return }
            renderEncoder?.setRenderPipelineState( obj_shadow_pp )

            var cam_idx = cascadeIndex + 1
            
            for model_idx in 0 ..< models.count {
                guard let model = models[model_idx],
                      let mesh = model.mesh
                else { return }
                
                renderEncoder?.setVertexBuffer( mesh.vertexBuffer, offset: 0, index: 0 )
                renderEncoder?.setVertexBuffer( instanceBuffer?.metalBuffer, offset: 0, index: 1 )
                renderEncoder?.setVertexBytes( &cam_idx, length:4, index:2 )
                
                renderEncoder?.drawIndexedPrimitives(
                    type: .triangle,
                    indexCount: mesh.indexCount,
                    indexType: .uint16,
                    indexBuffer: mesh.indexBuffer,
                    indexBufferOffset: 0,
                    instanceCount: maxModelCount
                )
            }
        }
    }
    
    open class ModelObjectRenderer
    : ModelBaseObjectRenderer
    {          
        public override init( device:MTLDevice, viewCount:Int ) {
            super.init( device:device, viewCount:viewCount )
            
            maxModelCount = 64
            
            loadAssets()
            
            instanceBuffer = .init( device:device, count:maxModelCount * models.count * cameraCount )
            
            instanceBuffer?.update { acc, _ in
                for cam_idx in 0 ..< cameraCount {
                    for idx in 0 ..< models.count {
                        let b = idx + cam_idx
                        acc[b] = .identity
                    }
                }
            }
        }
        
        public func loadAssets() {
            let assets = [
                "acacia1"
            ]
            
            for asset_name in assets {
                guard let asset = NSDataAsset( name:asset_name ) else { continue }
                models.append( Lily.Stage.Model.Obj( device:device, data:asset.data ) )
            }
        }
        
        public func generateObject( with commandBuffer:MTLCommandBuffer? ) {
            instanceBuffer?.update { acc, _ in
                for iid in 0 ..< maxModelCount * cameraCount {
                    
                    let idx = iid / cameraCount
                    let x = idx / 8
                    let z = idx % 8
                    // オブジェクトの位置
                    let world_pos = LLFloatv3( 20.0 + -10.0 * x.f, -2.0, 20.0 + -10.0 * z.f )
                    
                    let object_scale = LLFloatv3( 8.0, 8.0, 8.0 )
                    
                    let up = LLFloatv3( 0, 1, 0 )
                    let right = normalize( cross( up, LLFloatv3( 1.0, 0.0, 1.0 ) ) )
                    let fwd = cross( up, right )
                    
                    let world_matrix = float4x4(   
                        LLFloatv4( fwd * object_scale, 0 ),
                        LLFloatv4( up * object_scale, 0 ),
                        LLFloatv4( right * object_scale, 0 ),
                        LLFloatv4( world_pos, 1 )
                    )
                    
                    acc[iid] = world_matrix
                }
            }
        }
    }
}
