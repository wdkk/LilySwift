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

public protocol LLMetalShapeVerticeProtocl
{
    associatedtype VerticeType
}

// Metal形状メモリ基本クラス
public class LLMetalShape<T> 
: LLAlignedMemory4096<T>, LLMetalBufferAllocatable, LLMetalShapeVerticeProtocl
{
    public typealias VerticeType = T
    
    fileprivate var _buffer:LLMetalBufferShapeProtocol?
    fileprivate var _buffer_type:LLMetalBufferType

    public required init( count:Int = 0, bufferType:LLMetalBufferType = .shared ) {
        _buffer_type = bufferType
        super.init( count: count )
        #if targetEnvironment(simulator)
        _buffer_type = .alloc
        _buffer = LLMetalAllocatedBuffer( amemory: self )
        #else
        _buffer = _buffer_type == .alloc ? 
            LLMetalAllocatedBuffer( amemory:self ) : LLMetalSharedBuffer( amemory:self )
        #endif
    }
    
    public var metalBuffer:MTLBuffer? {
        _buffer?.update( memory:self )
        return _buffer?.metalBuffer
    }
    
    public var memory:UnsafeMutablePointer<T>? {
        return UnsafeMutablePointer<T>( OpaquePointer( self.pointer ) )
    }
    
    public var vertice:UnsafeMutablePointer<VerticeType> {
        return UnsafeMutablePointer<VerticeType>( OpaquePointer( self.pointer! ) )
    }
}

public class LLMetalShapePainter<TShape>
{
    public var drawFunc:((MTLRenderCommandEncoder, LLMetalShape<TShape>) -> Void)?

    public init() { }
    
    public func draw( with encoder:MTLRenderCommandEncoder, index idx:Int,
                      shape:LLMetalShape<TShape> ) 
    {
        guard let metal_buffer = shape.metalBuffer else { return }
        encoder.setVertexBuffer( metal_buffer, index: idx )
        drawFunc?( encoder, shape )
    }    
}
