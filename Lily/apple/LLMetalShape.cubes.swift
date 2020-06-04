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

import Foundation
import Metal

// パネル型キューブメモリクラス
public struct LLCubePanel
{
    // パネルの向き
    public enum PanelSide {
        case front
        case back
        case left
        case right
        case top
        case bottom
    }
    public var side:PanelSide = .front
    public var pos = LLFloatv4() 
    public var uv = LLFloatv2()
}

public class CAIMCubes<T> : LLMetalShape<T>
{
    public let unit = 24
    
    public required init( count:Int = 0, bufferType:LLMetalBufferType = .shared ) {
        super.init( count: count * unit, bufferType: bufferType )
    }
    
    subscript(idx:Int) -> UnsafeMutablePointer<T> {
        let opaqueptr = OpaquePointer( self.pointer! + (idx * MemoryLayout<T>.stride * self.unit) )
        return UnsafeMutablePointer<T>(opaqueptr)
    }
    
    public override func draw( with encoder:MTLRenderCommandEncoder, index idx:Int ) {
        super.draw( with:encoder, index:idx )
        
        // パネル1枚ずつ6枚で1キューブを描く
        for j:Int in 0 ..< count {
            for i:Int in 0 ..< 6 {
                encoder.drawPrimitives(type: .triangleStrip, vertexStart: (i * 4) + (j * unit), vertexCount: 4)
            }
        }
    }
    
    public func set(idx:Int, pos:LLFloatv3, size:Float, iterator f: (Int, LLCubePanel)->T) {
        let cube = self[idx]
        let sz = size / 2.0
        let x = pos.x
        let y = pos.y
        let z = pos.z
        
        let v = [
            // Front
            LLCubePanel(side: .front, pos: LLFloatv4(-sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .front, pos: LLFloatv4( sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .front, pos: LLFloatv4(-sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .front, pos: LLFloatv4( sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(1, 0)),
            // Back
            LLCubePanel(side: .back, pos: LLFloatv4( sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .back, pos: LLFloatv4(-sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .back, pos: LLFloatv4( sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .back, pos: LLFloatv4(-sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 0)),
            // Left
            LLCubePanel(side: .left, pos: LLFloatv4(-sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .left, pos: LLFloatv4(-sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .left, pos: LLFloatv4(-sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .left, pos: LLFloatv4(-sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(1, 0)),
            // Right
            LLCubePanel(side: .right, pos: LLFloatv4( sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .right, pos: LLFloatv4( sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .right, pos: LLFloatv4( sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .right, pos: LLFloatv4( sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 0)),
            // Top
            LLCubePanel(side: .top, pos: LLFloatv4(-sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .top, pos: LLFloatv4( sz+x, sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .top, pos: LLFloatv4(-sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .top, pos: LLFloatv4( sz+x, sz+y, sz+z, 1.0), uv:LLFloatv2(1, 0)),
            // Bottom
            LLCubePanel(side: .bottom, pos: LLFloatv4(-sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(0, 1)),
            LLCubePanel(side: .bottom, pos: LLFloatv4( sz+x,-sz+y, sz+z, 1.0), uv:LLFloatv2(1, 1)),
            LLCubePanel(side: .bottom, pos: LLFloatv4(-sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(0, 0)),
            LLCubePanel(side: .bottom, pos: LLFloatv4( sz+x,-sz+y,-sz+z, 1.0), uv:LLFloatv2(1, 0)),
            ]
        
        for i:Int in 0 ..< 24 {
            cube[i] = f(i, v[i])
        }
    }
}
