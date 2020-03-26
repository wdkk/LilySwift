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

// Metal形状メモリ基本クラス
public class LLMetalShape<T> : LLAlignedMemory4096<T>, LLMetalDrawable, LLMetalBufferAllocatable
{
    fileprivate var _buffer:LLMetalBufferShapeProtocol?
    fileprivate var _buffer_type:LLMetalBufferType
    public var drawFunc:((MTLRenderCommandEncoder, Int) -> Void)?

    public init( count:Int, bufferType:LLMetalBufferType = .shared ) {
        _buffer_type = bufferType
        super.init( type:T.self, count: count )
        #if targetEnvironment(simulator)
        _buffer_type = .alloc
        _buffer = LLMetalAllocatedBuffer( vertice: self )
        #else
        _buffer = _buffer_type == .alloc ? 
            LLMetalAllocatedBuffer( vertice: self ) : 
            LLMetalSharedBuffer( vertice: self )
        #endif
    }
    
    public var metalBuffer:MTLBuffer? {
        _buffer?.update( vertice: self )
        return _buffer?.metalBuffer
    }
    
    public var memory:UnsafeMutablePointer<T>? {
        return UnsafeMutablePointer<T>( OpaquePointer( self.pointer ) )
    }
    
    public func draw( with encoder:MTLRenderCommandEncoder, index idx:Int ) {
        guard let metal_buffer = self.metalBuffer else { return }
        encoder.setVertexBuffer( metal_buffer, index: idx )
        drawFunc?( encoder, idx )
    }
}
