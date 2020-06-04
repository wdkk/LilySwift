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

public struct LLTriple<T> {
    public var p1:T, p2:T, p3:T
    public init( _ p1:T, _ p2:T, _ p3:T ) {
        self.p1 = p1; self.p2 = p2; self.p3 = p3
    }
}

// 三角形メッシュ形状メモリクラス
public class LLMetalTriangles<T> : LLMetalShape<LLTriple<T>>
{
    public typealias VerticeGroup = LLTriple<T>
  
    public required init( count:Int = 0, bufferType:LLMetalBufferType = .shared ) {
        super.init( count: count, bufferType: bufferType )
        
        drawFunc = { (encoder, index) in
            encoder.drawPrimitives( type: .triangle, vertexStart: 0, vertexCount: self.count )
        }
    }
    
    public var vertice:UnsafeMutablePointer<LLTriple<T>> {
        return UnsafeMutablePointer<LLTriple<T>>( OpaquePointer( self.pointer! ) )
    }
}
