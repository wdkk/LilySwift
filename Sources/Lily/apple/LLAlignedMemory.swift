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
    fileprivate var lcmemory:LCAlignedMemory16SmPtr = LCAlignedMemory16Make()
    public private(set) var typeSize:Int = 0
    
    public init( count:Int = 0 ) {
        self.typeSize = MemoryLayout<T>.stride
        self.resize( count:count )
    }

    public var count:Int { return length / self.typeSize }
    
    public var length:Int { return LCAlignedMemory16Length( lcmemory ) }
    
    public var allocatedLength:Int { return LCAlignedMemory16AllocatedLength( lcmemory ) } 
    
    public var pointer:LLBytePtr? { return LCAlignedMemory16Pointer( lcmemory ) }
    
    public var mutablePointer:UnsafeMutablePointer<T>? { return UnsafeMutablePointer<T>( OpaquePointer( pointer ) ) }
   
    public var accessor:UnsafeMutableBufferPointer<T>? { return UnsafeMutableBufferPointer<T>( start:mutablePointer, count:count ) }
    
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
    fileprivate var lcmemory:LCAlignedMemory4096SmPtr = LCAlignedMemory4096Make()
    public private(set) var typeSize:Int = 0
    
    public init( count:Int = 0 ) {
        self.typeSize = MemoryLayout<T>.stride
        self.resize( count:count )
    }

    public var count:Int { return length / self.typeSize }
    
    public var length:Int { return LCAlignedMemory4096Length( lcmemory ) }
    
    public var allocatedLength:Int { return LCAlignedMemory4096AllocatedLength( lcmemory ) } 
    
    public var pointer:LLBytePtr? { return LCAlignedMemory4096Pointer( lcmemory ) }
    
    public var mutablePointer:UnsafeMutablePointer<T>? { return UnsafeMutablePointer<T>( OpaquePointer( pointer ) ) }
   
    public var accessor:UnsafeMutableBufferPointer<T>? { return UnsafeMutableBufferPointer<T>( start:mutablePointer, count:count ) }
    
    public func clear() { LCAlignedMemory4096Clear( lcmemory ) }

    public func resize( count:Int ) {
        LCAlignedMemory4096Resize( lcmemory, self.typeSize * count )
    }
    
    // メモリの追加
    public func append( _ element:T ) {
        withUnsafePointer( to: element ) { 
            let opaque_ptr:OpaquePointer = OpaquePointer( $0 )
            let nonnull_ptr:LLNonNullUInt8Ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory4096AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
    
    // メモリの追加
    public func append( _ elements:[T] ) {
        withUnsafePointer( to: elements ) {
            let opaque_ptr:OpaquePointer = OpaquePointer( $0 )
            let nonnull_ptr:LLNonNullUInt8Ptr = LLNonNullUInt8Ptr( opaque_ptr )
            LCAlignedMemory4096AppendBytes( lcmemory, nonnull_ptr, self.typeSize )
        }
    }
}
