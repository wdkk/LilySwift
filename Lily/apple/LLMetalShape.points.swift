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

/// 点形状クラス
public class LLMetalPoints<T> : LLMetalShape<T>
{
    public required init( count:Int = 0, bufferType:LLMetalBufferType = .shared ) {
        super.init( count: count, bufferType: bufferType )
        
        drawFunc = { (encoder, index) in
            encoder.drawPrimitives(type: .point, vertexStart: 0, vertexCount: count )
        }
    }
    
    public var vertex:UnsafeMutablePointer<T> {
        return UnsafeMutablePointer<T>( OpaquePointer( self.pointer! ) )
    }
}
