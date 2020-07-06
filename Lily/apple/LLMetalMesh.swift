//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Metal
import MetalKit

public class LLMetalMesh : LLMetalDrawable
{
    public var metalMesh: MTKMesh?
    public var metalVertexBuffer:MTLBuffer? { return metalMesh?.vertexBuffers[0].buffer }
 
    static func defaultVertexDesc( at index:Int ) -> MTLVertexDescriptor {
        let mtl_vertex = MTLVertexDescriptor()
        mtl_vertex.attributes[0].format = .float3
        mtl_vertex.attributes[0].offset = 0
        mtl_vertex.attributes[0].bufferIndex = 0
        mtl_vertex.attributes[1].format = .float3
        mtl_vertex.attributes[1].offset = 12
        mtl_vertex.attributes[1].bufferIndex = 0
        mtl_vertex.attributes[2].format = .float2
        mtl_vertex.attributes[2].offset = 24
        mtl_vertex.attributes[2].bufferIndex = 0
        mtl_vertex.layouts[index].stride = 32
        mtl_vertex.layouts[index].stepRate = 1
        return mtl_vertex
    }
    
    public init() {}
    
    public init(with path:String, 
                at index:Int = 0, 
                addNormal add_normal:Bool = true,
                normalThreshold normal_threshold:Float = 1.0 )
    {
        metalMesh = self.load(with:path, at:index, addNormal: add_normal, normalThreshold: normal_threshold)
    }
    
    public static func sphere(at index:Int) -> LLMetalMesh 
    {
        let mesh = LLMetalMesh()
        mesh.metalMesh = mesh.makeSphere( at: index )
        return mesh
    }
    
    private func load(with path: String, 
                      at index:Int = 0, 
                      addNormal add_normal:Bool,
                      normalThreshold normal_threshold:Float )
    -> MTKMesh
    {
        let modelDescriptor3D = MTKModelIOVertexDescriptorFromMetal( LLMetalMesh.defaultVertexDesc(at:index) )
        (modelDescriptor3D.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (modelDescriptor3D.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        (modelDescriptor3D.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
        
        let allocator = MTKMeshBufferAllocator( device: LLMetalManager.shared.device! )

        let asset = MDLAsset( url: LLPath.bundle( path ).url,
                              vertexDescriptor: modelDescriptor3D,
                              bufferAllocator: allocator )

        let new_mesh = try! MTKMesh.newMeshes(asset: asset, device: LLMetalManager.shared.device! )
        
        if add_normal {
            new_mesh.modelIOMeshes.first!.addNormals( withAttributeNamed: MDLVertexAttributeNormal,
                                                      creaseThreshold: normal_threshold )
            let mtk_mesh = try! MTKMesh(mesh: new_mesh.modelIOMeshes.first!, device: LLMetalManager.shared.device! )
            return mtk_mesh
        }
        else {
            return new_mesh.metalKitMeshes.first!
        }
    }
    
    private func makeSphere(at index:Int) -> MTKMesh {
        let modelDescriptor3D = MTKModelIOVertexDescriptorFromMetal( LLMetalMesh.defaultVertexDesc( at:index ) )
        
        (modelDescriptor3D.attributes[0] as! MDLVertexAttribute).name = MDLVertexAttributePosition
        (modelDescriptor3D.attributes[1] as! MDLVertexAttribute).name = MDLVertexAttributeNormal
        (modelDescriptor3D.attributes[2] as! MDLVertexAttribute).name = MDLVertexAttributeTextureCoordinate
        
        let allocator = MTKMeshBufferAllocator( device: LLMetalManager.shared.device! )
        
        let mesh = MDLMesh( sphereWithExtent: [ 1.0, 1.0, 1.0 ], 
                            segments: [ 32, 32 ], 
                            inwardNormals: true, 
                            geometryType: .triangles, 
                            allocator: allocator )
        
        let new_mesh = try! MTKMesh( mesh: mesh, device: LLMetalManager.shared.device! )
        return new_mesh
    }
    
    public func draw( with encoder:MTLRenderCommandEncoder, index idx:Int ) {
        if metalVertexBuffer == nil { return }
        encoder.setVertexBuffer( metalVertexBuffer!, index: idx )
        
        metalMesh?.submeshes.forEach {
            encoder.drawIndexedPrimitives(type: $0.primitiveType,
                                       indexCount: $0.indexCount,
                                       indexType: $0.indexType,
                                       indexBuffer: $0.indexBuffer.buffer,
                                       indexBufferOffset: $0.indexBuffer.offset )
        }
    }
}
