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
    open class Sphere
    {  
        public var mesh:Mesh?
        
        public init( device:MTLDevice, segments: Int, rings: Int ) {
            mesh = makeSphere( device:device, segments:segments, rings:rings )
        }
        
        func makeSphere( device:MTLDevice, segments: Int, rings: Int) -> Mesh? {
            var boundingSphereRadius: Float = 0.0
            var vertices: [Mesh.Vertex] = []
            var indices: [UInt16] = []
            
            for i in 0...rings {
                 let phi = Float(i) * Float.pi / Float(rings)
                 for j in 0...segments {
                     let theta = Float(j) * 2.0 * Float.pi / Float(segments)
                     let x = sin(phi) * cos(theta)
                     let y = cos(phi)
                     let z = sin(phi) * sin(theta)
                     
                     // 法線は頂点の位置と同じ（単位球の場合）
                     let nx = x
                     let ny = y
                     let nz = z
                     
                     // 色を適当に設定（ここでは赤色）
                     let r: Float = 1.0
                     let g: Float = 0.0
                     let b: Float = 0.0
                     let a: Float = 1.0 // アルファ値
                     
                     let position:LLFloatv3 = .init( x, y, z )
                     let normal:LLFloatv3 = .init( nx, ny, nz )
                     let color:LLFloatv3 = .init( r, g, b )
                                      
                     let vtx = Mesh.Vertex(
                         position:position,
                         normal:normal,
                         color:color
                     )
                     
                     vertices.append(vtx)
                     boundingSphereRadius = max( boundingSphereRadius, simd.length(vtx.position) )
                 }
            }
            
            for i in 0..<rings {
                for j in 0..<segments {
                    let a = UInt16(i * (segments + 1) + j)
                    let b = UInt16((i + 1) * (segments + 1) + j)
                    let c = UInt16(i * (segments + 1) + j + 1)
                    let d = UInt16((i + 1) * (segments + 1) + j + 1)

                    // MetalはCounter-Clockwiseなので逆回りに
                    indices.append(contentsOf: [a, c, b, b, c, d])
                }
            }
            
            return .init(
                device:device, 
                boundingRadius:boundingSphereRadius, 
                vertices: vertices,
                indices: indices
            )
        }
    }
}
