//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import simd
import Metal

extension Lily.Stage.Model
{
    open class Mesh 
    {
        public struct Vertex : Equatable, Hashable
        {
            public var position:LLFloatv3
            public var normal:LLFloatv3
            public var color:LLFloatv3
            
            public static func == ( lhs:Self, rhs:Self ) -> Bool {
                return lhs.position == rhs.position &&
                lhs.normal == rhs.normal &&
                lhs.color == rhs.color
            }
            
            public func hash(into hasher: inout Hasher) {
                var hash:UInt = 0
                withUnsafeBytes(of: self) { hash = $0.load( as:UInt.self ) }
                hasher.combine( hash )
            }
        }
        
        public var boundingRadius:Float
        public var vertexBuffer:MTLBuffer!
        public var indexBuffer:MTLBuffer!
        
        public var vertexCount: Int { vertexBuffer.length / MemoryLayout<Vertex>.stride }
        
        public var indexCount: Int { indexBuffer.length / MemoryLayout<UInt16>.stride }
        
        public init( boundingRadius:Float, vertexBuffer: MTLBuffer, indexBuffer: MTLBuffer ) {
            self.boundingRadius = boundingRadius
            self.vertexBuffer = vertexBuffer
            self.indexBuffer = indexBuffer
        }
        
        public init( device:MTLDevice, boundingRadius:Float, vertices:[Vertex], indices:[UInt16] ) {
            self.boundingRadius = boundingRadius
            
            #if !targetEnvironment(simulator)
            let vertex_buffer = device.makeBuffer(
                bytes:vertices, 
                length: MemoryLayout<Vertex>.stride * vertices.count,
                options:[.storageModeShared]
            )!
            let index_buffer = device.makeBuffer( 
                bytes:indices, 
                length: MemoryLayout<UInt16>.stride * indices.count,
                options:[.storageModeShared]
            )!
            
            #else
            let vertex_buffer = device.makeBuffer(
                length:MemoryLayout<Vertex>.stride * vertices.count,
                options:[.storageModePrivate] 
            )!
            let index_buffer = device.makeBuffer( 
                length: MemoryLayout<UInt16>.stride * indices.count,
                options:[.storageModePrivate] 
            )!
            
            let blit_vertex_buffer = device.makeBuffer(
                bytes: vertices, 
                length: MemoryLayout<Vertex>.stride * vertices.count
            )!
            let blit_index_buffer = device.makeBuffer(
                bytes: indices,
                length: MemoryLayout<UInt16>.stride * indices.count
            )!
            
            let command_buffer = commandQueue.makeCommandBuffer()
            let blit_encoder = command_buffer?.makeBlitCommandEncoder()
            blit_encoder?.copy(
                from: blit_vertex_buffer, 
                sourceOffset: 0, 
                to: vertex_buffer, 
                destinationOffset: 0,
                size:MemoryLayout<Vertex>.stride * vertices.count
            )
            blit_encoder?.copy(
                from: blit_index_buffer, 
                sourceOffset: 0,
                to: index_buffer,
                destinationOffset: 0, 
                size:MemoryLayout<UInt16>.stride * indices.count
            )
            blit_encoder?.endEncoding()
            
            command_buffer?.commit()
            command_buffer?.waitUntilCompleted()
            #endif
            
            self.vertexBuffer = vertex_buffer
            self.indexBuffer = index_buffer
        }        
    } 
}
