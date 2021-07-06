//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

public enum LLMetalBufferType : Int
{
    case alloc
    case shared
}

/// Metalバッファを出力できるようにするプロトコル
public protocol LLMetalBufferAllocatable 
{
    var metalBuffer:MTLBuffer? { get }
}

public protocol LLMetalBufferShapeProtocol
{
    var metalBuffer:MTLBuffer? { get }
    func update( memory:LLAlignedMemoryAllocatable )
}

public class LLMetalAllocatedBuffer 
: LLMetalBufferAllocatable
, LLMetalBufferShapeProtocol
{
    private var _length:Int
    private var _mtlbuf:MTLBuffer?
    public var metalBuffer:MTLBuffer? { return _mtlbuf }
    
    // 指定したオブジェクトのサイズで確保＆初期化
    public init<T>( obj:T ) {
        _length = MemoryLayout<T>.stride
        _mtlbuf = self.allocate( [obj], length:_length )
    }
    // 指定したオブジェクト配列で確保＆初期化
    public init<T>( elements:[T] ) {
        _length = MemoryLayout<T>.stride * elements.count
        _mtlbuf = self.allocate( elements, length:_length )
    }
    // 指定したバイト数を確保（初期化はなし）
    public init( length:Int ) {
        _length = length
        _mtlbuf = self.allocate( _length )
    }
    // 指定したバイト数で確保＆ポインタ先からコピーして初期化
    public init( _ buf:UnsafeRawPointer, length:Int ) {
        _length = length
        _mtlbuf = self.allocate( buf, length: _length )
    }
    
    // 指定した頂点プールの内容とサイズで確保＆初期化
    public init( amemory:LLAlignedMemoryAllocatable ) {
        _length = amemory.allocatedLength
        _mtlbuf = self.allocate( amemory.pointer, length:_length )
    }
    
    // 更新
    public func update<T>( _ obj:T ) {
        let sz:Int = MemoryLayout<T>.stride
        if _length != sz { _mtlbuf = self.allocate( sz ) }
        memcpy( _mtlbuf!.contents(), [obj], sz )
    }
    
    public func update<T>( elements:[T] ) {
        let sz:Int = MemoryLayout<T>.stride * elements.count
        if _length != sz { _mtlbuf = self.allocate( sz ) }
        if sz == 0 { return }
        memcpy( _mtlbuf!.contents(), elements, sz )
    }
    
    public func update( _ buf:UnsafeRawPointer?, length:Int ) {
        let sz:Int = length
        if _length != sz { _mtlbuf = self.allocate( sz ) }
        if buf == nil { return }
        if sz == 0 { return }
        memcpy( _mtlbuf!.contents(), buf, sz )
    }

    public func update( memory:LLAlignedMemoryAllocatable ) {
        let sz:Int = memory.allocatedLength
        if _length != sz { _mtlbuf = self.allocate( sz ) }
        memcpy( _mtlbuf!.contents(), memory.pointer, sz )
    }
    
    /// メモリ確保
    private func allocate( _ buf:UnsafeRawPointer?, length:Int ) -> MTLBuffer? {
        if length == 0 { return nil }
        if buf == nil { return nil }
        return LLMetalManager.shared.device?.makeBuffer( bytes: buf!, length: length, options: .storageModeShared )
    }
    
    private func allocate( _ length:Int ) -> MTLBuffer? {
        if length == 0 { return nil }
        return LLMetalManager.shared.device?.makeBuffer( length: length, options: .storageModeShared )
    }
}

public class LLMetalSharedBuffer : LLMetalBufferAllocatable, LLMetalBufferShapeProtocol
{    
    private var _length:Int
    private var _mtlbuf:MTLBuffer?
    public var metalBuffer:MTLBuffer? { return _mtlbuf }
    
    private var _mtlbuf_length:Int = 0
    private var _mtlbuf_current_pointer:UnsafeMutableRawPointer?
    
    // 指定したオブジェクト全体を共有して確保・初期化
    public init<T>( amemory:LLAlignedMemory4096<T> ) {
        _length = amemory.length
        if _length == 0 { _mtlbuf = nil }
        else { 
            _mtlbuf = self.nocopy(
                amemory.pointer!,
                length:_length, 
                allocatedLength:amemory.allocatedLength
            )
        }
    }
    
    // 指定したバイト数で確保＆ポインタ先からコピーして初期化
    public init( _ buf:UnsafeRawPointer, length:Int ) {
        _length = length
        _mtlbuf = self.nocopy(
            UnsafeMutableRawPointer(mutating: buf), 
            length: _length, 
            allocatedLength:_length 
        )
    }
    
    public func update( memory:LLAlignedMemoryAllocatable ) {
        _mtlbuf = self.nocopy( 
            memory.pointer!,
            length: memory.length,
            allocatedLength:memory.allocatedLength 
        )
    }
    
    private func nocopy( _ buf:UnsafeMutableRawPointer, length:Int, allocatedLength:Int ) -> MTLBuffer? {
        if _mtlbuf_current_pointer != nil {
            if _mtlbuf_current_pointer! == buf && _mtlbuf_length == length { return _mtlbuf }
        }
        
        _mtlbuf_current_pointer = buf
        _mtlbuf_length = length

        return LLMetalManager.shared.device?.makeBuffer(
            bytesNoCopy:buf, 
            length:allocatedLength, 
            options:.storageModeShared,
            deallocator: nil 
        )
    }
}

#if targetEnvironment(simulator)
public typealias LLMetalStandardBuffer = LLMetalAllocatedBuffer
#else 
public typealias LLMetalStandardBuffer = LLMetalSharedBuffer
#endif
