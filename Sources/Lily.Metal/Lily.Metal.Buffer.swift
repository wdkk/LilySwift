//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

/// Metalバッファを出力できるようにするプロトコル
public protocol MetalBufferAllocatable 
{
    var metalBuffer:MTLBuffer? { get }
}

public protocol MetalBufferShapeProtocol
{
    var metalBuffer:MTLBuffer? { get }
    func update( memory:LLAlignedMemoryAllocatable )
}

extension Lily.Metal
{    
    public enum BufferType : Int
    {
        case alloc
        case shared
    }
    
    open class AllocatedBuffer 
    : MetalBufferAllocatable
    , MetalBufferShapeProtocol
    {
        var device:MTLDevice?
        private var _length:Int
        private var _mtlbuf:MTLBuffer?
        public var metalBuffer:MTLBuffer? { return _mtlbuf }
        
        public var label:String { 
            get { _mtlbuf?.label ?? "" }
            set { _mtlbuf?.label = newValue }
        }
        
        // 指定したオブジェクトのサイズで確保＆初期化
        public init<T>( device:MTLDevice?, obj:T ) {
            self.device = device
            _length = MemoryLayout<T>.stride
            let _ = withUnsafePointer(to:obj ) { ptr in
                _mtlbuf = self.allocate( ptr, length:_length )
            }
        }
        
        // 指定したオブジェクト配列で確保＆初期化
        public init<T>( device:MTLDevice?, elements:[T] ) {
            self.device = device
            _length = MemoryLayout<T>.stride * elements.count
            let _ = withUnsafePointer(to:elements ) { ptr in
                _mtlbuf = self.allocate( ptr, length:_length )
            }
        }
        
        // 指定したバイト数を確保（初期化はなし）
        public init( device:MTLDevice?, length:Int ) {
            self.device = device
            _length = length
            _mtlbuf = self.allocate( _length )
        }
        
        // 指定したバイト数で確保＆ポインタ先からコピーして初期化
        public init( device:MTLDevice?, buf:UnsafeRawPointer, length:Int ) {
            self.device = device
            _length = length
            _mtlbuf = self.allocate( buf, length: _length )
        }
        
        // 指定した頂点プールの内容とサイズで確保＆初期化
        public init( device:MTLDevice?, alignedMemory:LLAlignedMemoryAllocatable ) {
            self.device = device
            _length = alignedMemory.allocatedLength
            _mtlbuf = self.allocate( alignedMemory.pointer, length:_length )
        }
        
        // 更新
        public func update<T>( _ obj:T ) {
            let sz:Int = MemoryLayout<T>.stride
            if _length != sz { _mtlbuf = self.allocate( sz ) }
            let _ = withUnsafePointer(to: obj) { ptr in
                memcpy( _mtlbuf!.contents(), ptr, sz )
            }
        }
        
        public func update<T>( elements:[T] ) {
            let sz:Int = MemoryLayout<T>.stride * elements.count
            if _length != sz { _mtlbuf = self.allocate( sz ) }
            if sz == 0 { return }
            let _ = withUnsafePointer( to:elements ) { ptr in
                memcpy( _mtlbuf!.contents(), ptr, sz )
            }
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
            return device?.makeBuffer( bytes: buf!, length: length, options: .storageModeShared )
        }
        
        private func allocate( _ length:Int ) -> MTLBuffer? {
            if length == 0 { return nil }
            return device?.makeBuffer( length: length, options: .storageModeShared )
        }
    }
    
    open class SharedBuffer
    : MetalBufferAllocatable
    , MetalBufferShapeProtocol
    {    
        var device:MTLDevice?
        private var _length:Int
        private var _mtlbuf:MTLBuffer?
        public var metalBuffer:MTLBuffer? { return _mtlbuf }
        
        public var label:String { 
            get { _mtlbuf?.label ?? "" }
            set { _mtlbuf?.label = newValue }
        }
        
        private var _mtlbuf_length:Int = 0
        private var _mtlbuf_current_pointer:UnsafeMutableRawPointer?
        
        // 指定したオブジェクト全体を共有して確保・初期化
        public init<T>( device:MTLDevice?, alignedMemory:LLAlignedMemory4096<T>? ) {
            self.device = device
            guard let a_mem = alignedMemory else {
                _length = 0
                _mtlbuf = nil
                return
            }
            
            _length = a_mem.length
            if _length == 0 { _mtlbuf = nil }
            else { 
                _mtlbuf = self.nocopy(
                    a_mem.pointer!,
                    length:_length, 
                    allocatedLength:a_mem.allocatedLength
                )
            }
        }
        
        // 指定したバイト数で確保＆ポインタ先からコピーして初期化
        public init( device:MTLDevice?, buf:UnsafeRawPointer, length:Int ) {
            self.device = device
            _length = length
            _mtlbuf = self.nocopy(
                UnsafeMutableRawPointer( mutating:buf ), 
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
            
            return device?.makeBuffer(
                bytesNoCopy:buf, 
                length:allocatedLength, 
                options:.storageModeShared,
                deallocator: nil 
            )
        }
    }
    
#if targetEnvironment(simulator)
    public typealias DefaultBuffer = AllocatedBuffer
#else 
    public typealias DefaultBuffer = SharedBuffer
#endif
    
    // CPUバッファとGPUバッファの処理をどちらも持つ
    open class Buffer<T>
    {
        open var cpuBuffer:LLAlignedMemory4096<T>
        open var gpuBuffer:DefaultBuffer
        
        public var label:String { 
            get { gpuBuffer.label }
            set { gpuBuffer.label = newValue }
        }
        
        public init( device:MTLDevice, count:Int ) {
            cpuBuffer = .init( count:count )
            gpuBuffer = .init( device:device, alignedMemory:cpuBuffer )
        }
        
        public func update( action:( UnsafeMutableBufferPointer<T> )->() ) {
            guard let accessor = cpuBuffer.accessor else { return }
            action( accessor )
            gpuBuffer.update( memory:cpuBuffer )
        }
        
        public func update( at index:Int, iteration:( _ accessor:inout T )->() ) {
            guard let accessor = cpuBuffer.accessor else { return }
            iteration( &accessor[index] )
            gpuBuffer.update( memory:cpuBuffer )
        }
        
        public func update( range:Range<Int>, iteration:( _ accessor:inout T, _ index:Int )->() ) {
            guard let accessor = cpuBuffer.accessor else { return }
            range.forEach { iteration( &accessor[$0], $0 ) }
            gpuBuffer.update( memory:cpuBuffer )
        }
        
        public var accessor:UnsafeMutableBufferPointer<T>? { cpuBuffer.accessor }
        
        public var metalBuffer:MTLBuffer? { gpuBuffer.metalBuffer }
    }
}
