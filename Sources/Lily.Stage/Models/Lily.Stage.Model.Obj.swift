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
    open class Obj
    {
        public var mesh:Mesh?
        
        public init( device:MTLDevice, url:URL ) {
            mesh = Obj.Loader( device:device ).load( from:url )
        }
        
        public struct Vertex : Equatable, Hashable
        {
            public var position: simd_float3
            public var normal: simd_float3
            public var color: simd_float3
            
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
        
        public class Mesh 
        {
            public var boundingRadius:Float
            public var vertexBuffer:MTLBuffer!
            public var indexBuffer:MTLBuffer!
            
            public init( boundingRadius:Float, vertexBuffer: MTLBuffer, indexBuffer: MTLBuffer ) {
                self.boundingRadius = boundingRadius
                self.vertexBuffer = vertexBuffer
                self.indexBuffer = indexBuffer
            }
            
            public var vertexCount: Int { vertexBuffer.length / MemoryLayout<Vertex>.stride }
            
            public var indexCount: Int { indexBuffer.length / MemoryLayout<UInt16>.stride }
        }        
        
        public class Loader 
        {
            let device: MTLDevice
            let commandQueue: MTLCommandQueue
            
            private var positions: [simd_float3] = []
            private var normals: [simd_float3] = []
            private var colors: [simd_float3] = []
            private var boundingSphereRadius: Float = 0.0
            private var vertexMap: [Vertex: UInt32] = [:]
            private var vertices: [Vertex] = []
            private var indices: [UInt16] = []
            
            private static let bufferSize:UInt32 = 2048
            
            init( device:MTLDevice ) {
                self.device = device
                self.commandQueue = device.makeCommandQueue()!
            }
            
            private func createOrFindVertex(_ vertex:Vertex ) -> UInt32 {
                if let index = vertexMap[vertex] { return index }  
                else {
                    vertexMap[vertex] = UInt32(vertices.count)
                    vertices.append(vertex)
                    boundingSphereRadius = max( boundingSphereRadius, simd.length(vertex.position) )
                    return UInt32(vertices.count) - 1
                }
            }
            
            private func readLine(_ line:Data, lineNumber: UInt32) {
                let lineString = String( data:line, encoding:.utf8 )!
                
                var scanner = Scanner( string:lineString )
                if scanner.scanString( "v " ) != nil {
                    let x = scanner.scanFloat() ?? 0.0
                    let y = scanner.scanFloat() ?? 0.0
                    let z = scanner.scanFloat() ?? 0.0 
                    positions.append(simd_float3(x, y, z))
                    return
                }
                
                scanner = Scanner( string:lineString )
                if scanner.scanString( "vt " ) != nil {
                    let x = scanner.scanFloat() ?? 0.0
                    let y = scanner.scanFloat() ?? 0.0
                    let z = scanner.scanFloat() ?? 0.0 
                    colors.append(simd_float3(x, y, z))
                    return
                } 
                
                scanner = Scanner( string:lineString )
                if scanner.scanString( "vn " ) != nil {
                    let x = scanner.scanFloat() ?? 0.0
                    let y = scanner.scanFloat() ?? 0.0
                    let z = scanner.scanFloat() ?? 0.0 
                    normals.append(simd_float3(x, y, z))
                    return
                } 
                
                scanner = Scanner( string:lineString )
                if scanner.scanString( "f " ) != nil {
                    // "f %d/%d/%d %d/%d/%d %d/%d/%d %d/%d/%d"の分解
                    let params = lineString.replace( old:"f ", new:"" ).split( " " )
                    let values = params.map { $0.split( "/" ) }
                    
                    // MEMO: params.countが4を超える場合がある. その場合は4つ以上の部分を無視して構成する
                    if params.count >= 4 {
                        let iv  = [ values[0][0].i, values[1][0].i, values[2][0].i, values[3][0].i ]
                        let ivt = [ values[0][1].i, values[1][1].i, values[2][1].i, values[3][1].i ]
                        let ivn = [ values[0][2].i, values[1][2].i, values[2][2].i, values[3][2].i ]
                        
                        var indices:[UInt16] = []
                        for v in 0 ..< 4 {
                            guard let iv_v = iv[v], let ivn_v = ivn[v], let ivt_v = ivt[v] else { return }
                            let vtx = Vertex(
                                position: positions[iv_v - 1],
                                normal: normals[ivn_v - 1],
                                color: colors[ivt_v - 1]
                            )
                            indices.append( UInt16( createOrFindVertex(vtx) ) )
                        }
                        
                        self.indices.append(contentsOf:
                             [indices[0], indices[1], indices[2], indices[0], indices[2], indices[3]]
                        )
                    }
                    else if params.count == 3 {
                        let iv  = [ values[0][0].i, values[1][0].i, values[2][0].i ]
                        let ivt = [ values[0][1].i, values[1][1].i, values[2][1].i ]
                        let ivn = [ values[0][2].i, values[1][2].i, values[2][2].i ]
                        
                        var indices: [UInt16] = []
                        for v in 0 ..< 3 {
                            guard let iv_v = iv[v], let ivn_v = ivn[v], let ivt_v = ivt[v] else { return }
                            let vtx = Vertex(
                                position: positions[iv_v - 1],
                                normal: normals[ivn_v - 1],
                                color: colors[ivt_v - 1]
                            )
                            indices.append( UInt16( createOrFindVertex(vtx) ) )
                        }
                        
                        self.indices.append( contentsOf:[indices[0], indices[1], indices[2]] )
                    }
                    
                    return
                }
            }
            
            private func clear() {
                boundingSphereRadius = 0.0
                indices.removeAll()
                vertices.removeAll()
                vertexMap.removeAll()
                normals.removeAll()
                colors.removeAll()
                positions.removeAll()
            }
            
            func load( from url:URL ) -> Mesh? {
                clear()
                
                guard let inputStream = InputStream(url: url) else { fatalError("Failed to open input stream") }
                inputStream.open()
                
                var readBuffer = [UInt8]( repeating: 0, count: Int(Loader.bufferSize) )
                var beginLine:Int = 0
                var endLine:Int = 0
                var endBuffer:Int = 0
                var line = Data()
                var lineNumber: UInt32 = 0
                
                while beginLine != endBuffer || inputStream.hasBytesAvailable {
                    endLine = beginLine
                    while true {
                        if endLine >= endBuffer || readBuffer[endLine] == 0x0A { break }
                        endLine += 1
                    }
                    
                    let ptr = readBuffer.withUnsafeBytes { ($0.baseAddress! + beginLine).assumingMemoryBound(to:UInt8.self ) }
                    line.append( ptr, count: endLine - beginLine )
                    
                    if endLine == endBuffer {
                        let bytesRead = inputStream.read( &readBuffer, maxLength: Int(Loader.bufferSize) - 1)
                        endBuffer = bytesRead
                        beginLine = 0
                    } 
                    else {
                        line.append("", count: 1)
                        lineNumber += 1
                        readLine(line, lineNumber: lineNumber)
                        line.removeAll()
                        line.count = 0
                        beginLine = endLine + 1
                    }
                }
                
                inputStream.close()
                
                #if !targetEnvironment(simulator)
                let vertex_buffer = device.makeBuffer( bytes:vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options:[.storageModeShared])!
                let index_buffer =  device.makeBuffer( bytes:indices, length: MemoryLayout<UInt16>.stride * indices.count, options:[.storageModeShared])!
                
                let new_mesh = Mesh(
                    boundingRadius: boundingSphereRadius, 
                    vertexBuffer: vertex_buffer,
                    indexBuffer: index_buffer
                )
                #else
                let vertex_buffer = device.makeBuffer( length:MemoryLayout<Vertex>.stride * vertices.count, options:[.storageModePrivate] )!
                let index_buffer = device.makeBuffer( length: MemoryLayout<UInt16>.stride * indices.count, options:[.storageModePrivate] )!
   
                let blit_vertex_buffer = device.makeBuffer(
                    bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count )!
                let blit_index_buffer = device.makeBuffer(
                    bytes: indices, length: MemoryLayout<UInt16>.stride * indices.count )!
                
                let command_buffer = commandQueue.makeCommandBuffer()
                let blit_encoder = command_buffer?.makeBlitCommandEncoder()
                blit_encoder?.copy(from: blit_vertex_buffer, sourceOffset: 0, to: vertex_buffer, destinationOffset: 0, size:MemoryLayout<Vertex>.stride * vertices.count )
                blit_encoder?.copy(from: blit_index_buffer, sourceOffset: 0, to: index_buffer, destinationOffset: 0, size:MemoryLayout<UInt16>.stride * indices.count )
                blit_encoder?.endEncoding()
                
                command_buffer?.commit()
                command_buffer?.waitUntilCompleted()
                
                let new_mesh = Mesh(
                    boundingRadius: boundingSphereRadius, 
                    vertexBuffer: vertex_buffer,
                    indexBuffer: index_buffer
                )
                #endif
                
                clear()
                return new_mesh
            }
        }
    }

}
