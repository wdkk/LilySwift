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

public protocol LLAlignedMemoryAllocatable
{
    var count:Int { get }
    
    var length:Int { get }
    
    var allocatedLength:Int { get } 
    
    var pointer:LLBytePtr? { get }
}

/// 16バイトアラインメントされたメモリオブジェクトクラス
open class LLAlignedMemory16<T> : LLAlignedMemoryAllocatable
{
    /// LilyCoreオブジェクト
    fileprivate var lcmemory = LCAlignedMemory16Make()
    public private(set) var typeSize:Int = 0
    
    public init( type:T.Type, count:Int = 0 ) {
        self.typeSize = MemoryLayout<T>.stride
        self.resize( count:count )
    }

    public var count:Int { return length / self.typeSize }
    
    public var length:Int { return LCAlignedMemory16Length( lcmemory ) }
    
    public var allocatedLength:Int { return LCAlignedMemory16AllocatedLength( lcmemory ) } 
    
    public var pointer:LLBytePtr? { return LCAlignedMemory16Pointer( lcmemory ) }
    
    public func clear() { LCAlignedMemory16Clear( lcmemory ) }

    public func resize( count:Int ) {
        LCAlignedMemory16Resize( lcmemory, self.typeSize * count )
    }
    
    // メモリの追加
    public func append( _ element:T ) {
        withUnsafePointer( to: element ) { 
            let opaque_ptr = OpaquePointer( $0 )
            let nonnull_ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory16AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
    
    // メモリの追加
    public func append( _ elements:[T] ) {
        withUnsafePointer( to: elements ) {
            let opaque_ptr = OpaquePointer( $0 )
            let nonnull_ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory16AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
}

/// 4096バイトアラインメントされたメモリオブジェクトクラス
open class LLAlignedMemory4096<T> : LLAlignedMemoryAllocatable
{
    /// LilyCoreオブジェクト
    fileprivate var lcmemory = LCAlignedMemory4096Make()
    public private(set) var typeSize:Int = 0
    
    public init( type:T.Type, count:Int = 0 ) {
        self.typeSize = MemoryLayout<T>.stride
        self.resize( count:count )
    }

    public var count:Int { return length / self.typeSize }
    
    public var length:Int { return LCAlignedMemory4096Length( lcmemory ) }
    
    public var allocatedLength:Int { return LCAlignedMemory4096AllocatedLength( lcmemory ) } 
    
    public var pointer:LLBytePtr? { return LCAlignedMemory4096Pointer( lcmemory ) }
    
    public func clear() { LCAlignedMemory4096Clear( lcmemory ) }

    public func resize( count:Int ) {
        LCAlignedMemory4096Resize( lcmemory, self.typeSize * count )
    }
    
    // メモリの追加
    public func append( _ element:T ) {
        withUnsafePointer( to: element ) { 
            let opaque_ptr = OpaquePointer( $0 )
            let nonnull_ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory4096AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
    
    // メモリの追加
    public func append( _ elements:[T] ) {
        withUnsafePointer( to: elements ) {
            let opaque_ptr = OpaquePointer( $0 )
            let nonnull_ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory4096AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
}

/*
public class LLAlignedAllocator {
    fileprivate var _memory:LLUInt8Ptr? 
    public var pointer:LLUInt8Ptr? { return _memory }
    
    public private(set) var alignment:Int
    public private(set) var length:Int
    public private(set) var allocatedLength:Int
    
    // アラインメントを含んだメモリ確保量を計算
    private func calcAlignedSize( length:Int ) -> Int {
        let mod = length % alignment
        return length + ( mod > 0 ? alignment - mod : 0 )
    }
    
    // メモリの確保
    private func allocate( length:Int ) {
        if( length == 0 ) {
            self.length = 0
            self.allocatedLength = 0
            _memory?.deallocate()
            _memory = nil
            return
        }
        
        if( calcAlignedSize( length: length ) <= self.allocatedLength ) { return }
        
        let copy_length = min( self.length, length )
        self.length = length
        self.allocatedLength = calcAlignedSize( length: self.length )
        
        if _memory != nil {
            let tmp_memory = UnsafeMutableRawPointer.allocate( byteCount: self.allocatedLength, alignment: alignment )
            memcpy( tmp_memory, _memory, copy_length )
            _memory?.deallocate()
            _memory = LLUInt8Ptr( OpaquePointer( tmp_memory ) )
        }
        else {
            _memory = LLUInt8Ptr( OpaquePointer(
                UnsafeMutableRawPointer.allocate( byteCount: self.allocatedLength, alignment: alignment ) ) )
        }
    }
    
    // メモリの追加
    private func allocateAppending( length newleng:Int ) {
        let new_aligned_length = calcAlignedSize( length: newleng )
        // もし余分も含めてオーバーした場合メモリの再確保
        var next_length = self.allocatedLength
        while(true) {
            if( new_aligned_length <= next_length ) { break }
            next_length *= 2
        }
        allocate( length: next_length )
    }
    
    public init( alignment:Int, length:Int ) {
        self.alignment = alignment
        self.length = 0
        self.allocatedLength = 0
        allocate( length: length )
    }
    
    deinit {
        clear()
    }
    
    public func resize( length:Int ) {
        allocate( length: length )
    }
    
    public func clear() {
        allocate( length: 0 )
    }
    
    public func append( _ buf:UnsafeRawPointer, length add_length:Int ) {
        let new_length = self.length + add_length
        let last_ptr = self.length
        allocateAppending( length: new_length )
        memcpy( _memory! + last_ptr, buf, add_length )
    }
}

// アラインメントを考慮したメモリクラス
public class LLAlignedMemory4096<T> : LLAlignedMemoryAllocatable
{
    fileprivate var _allocator:LLAlignedAllocator?
    public private(set) var count:Int = 0
    public private(set) var unitSize:Int = 0
    
    public var length:Int { return _allocator!.length }
    public var allocatedLength:Int { return _allocator!.allocatedLength }
    public var pointer:LLUInt8Ptr? { return LLUInt8Ptr( _allocator?.pointer ) }
    
    public init( type:Int, count:Int = 0 ) {
        _allocator = LLAlignedAllocator( alignment: 4096, length: 0 )
        self.unitSize = type
        self.resize( count: count )
    }
    
    // メモリのクリア
    public func clear() { _allocator?.clear() }
    
    // メモリのリサイズ
    public func resize( count:Int ) {
        self.count = count
        _allocator?.resize( length: count * MemoryLayout<T>.stride * unitSize )
    }
    
    // メモリの追加
    public func append( _ element:T ) {
        self.count += 1
        withUnsafePointer( to: element ) {
            _allocator?.append( $0, length: MemoryLayout<T>.stride )
        }
    }
    
    // メモリの追加
    public func append( _ elements:[T] ) {
        self.count += elements.count
        withUnsafePointer( to: elements ) {
            _allocator?.append( $0, length: MemoryLayout<T>.stride * elements.count )
        }
    }
}

// アラインメントを考慮したメモリクラス
public class LLAlignedMemory16<T> : LLAlignedMemoryAllocatable
{
    fileprivate var _allocator:LLAlignedAllocator?
    public private(set) var count:Int = 0
    public private(set) var unitSize:Int = 0
    
    public var length:Int { return _allocator!.length }
    public var allocatedLength:Int { return _allocator!.allocatedLength }
    public var pointer:LLUInt8Ptr? { return _allocator?.pointer }
    
    public init( type:Int, count:Int = 0 ) {
        _allocator = LLAlignedAllocator( alignment: 16, length: 0 )
        self.unitSize = type
        self.resize( count: count )
    }
    
    // メモリのクリア
    public func clear() { _allocator?.clear() }
    
    // メモリのリサイズ
    public func resize( count:Int ) {
        self.count  = count
        _allocator?.resize( length: count * MemoryLayout<T>.stride * unitSize )
    }
    
    // メモリの追加
    public func append( _ element:T ) {
        self.count += 1
        withUnsafePointer(to: element ) {
            _allocator?.append( $0, length: MemoryLayout<T>.stride )
        }
    }
    
    // メモリの追加
    public func append( _ elements:[T] ) {
        self.count += elements.count
        withUnsafePointer(to: elements) {
            _allocator?.append( $0, length: MemoryLayout<T>.stride * elements.count )
        }
    }
}
*/
