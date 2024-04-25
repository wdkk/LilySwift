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

import simd
import Metal

extension Lily.Stage.Model
{    
    open class Obj
    {
        public var mesh:Lily.Stage.Model.Mesh?
        
        public init( device:MTLDevice, url:URL ) {
            mesh = Obj.Loader( device:device ).load( from:url )
        }
        
        public init( device:MTLDevice, data:Data ) {
            mesh = Obj.Loader( device:device ).load( data:data )
        }
    }
}

extension Lily.Stage.Model.Obj
{
    public class Loader 
    {
        typealias Mesh = Lily.Stage.Model.Mesh
        typealias Vertex = Lily.Stage.Model.Mesh.Vertex
        
        let device: MTLDevice
        let commandQueue: MTLCommandQueue
        
        private var positions: [simd_float3] = []
        private var normals: [simd_float3] = []
        private var colors: [simd_float3] = []
        private var vertexMap: [Vertex: UInt32] = [:]
        private var vertices: [Vertex] = []
        private var indices: [UInt16] = []
        
        private static let bufferSize:UInt32 = 2048
        
        init( device:MTLDevice ) {
            self.device = device
            self.commandQueue = device.makeCommandQueue()!
        }
        
        private func clear() {
            indices.removeAll()
            vertices.removeAll()
            vertexMap.removeAll()
            normals.removeAll()
            colors.removeAll()
            positions.removeAll()
        }
        
        private func createOrFindVertex(_ vertex:Vertex ) -> UInt32 {
            if let index = vertexMap[vertex] { return index }  
            else {
                vertexMap[vertex] = UInt32(vertices.count)
                vertices.append(vertex)
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
        
        func load( from url:URL ) -> Mesh? {
            clear()
            guard let inputStream = InputStream(url: url) else { fatalError("Failed to open input stream") }
            return load( stream:inputStream )
        }
        
        func load( data:Data ) -> Mesh? {
            clear()
            let inputStream = InputStream( data:data )
            return load( stream:inputStream )
        }
        
        func load( stream inputStream:InputStream ) -> Mesh? {   
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
            
            let result_mesh = Mesh(
                device:device, 
                commandQueue:commandQueue,
                vertices: vertices,
                indices: indices
            )
            
            clear()
            
            return result_mesh
        }
    }
}

#endif
