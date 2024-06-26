//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal

extension Lily.Stage.Model
{
    open class Shape<VerticeType>
    : LLAlignedMemory4096<VerticeType>
    , MetalBufferAllocatable
    {
        fileprivate var buffer:MetalBufferShapeProtocol?
        fileprivate var bufferType:Lily.Metal.BufferType
        
        public required init( device:MTLDevice?, count:Int = 0, bufferType:Lily.Metal.BufferType = .shared ) {
            self.bufferType = bufferType
            super.init( count:count )
            #if !targetEnvironment(simulator)
            buffer = (self.bufferType == .alloc) ?
                Lily.Metal.AllocatedBuffer( device:device, alignedMemory:self ) :
                Lily.Metal.SharedBuffer( device:device, alignedMemory:self )
            #else
            self.bufferType = .alloc
            buffer = Lily.Metal.AllocatedBuffer( device:device, alignedMemory: self )
            #endif
        }

        public var metalBuffer:MTLBuffer? {
            return buffer?.metalBuffer
        }
        
        public var memory:UnsafeMutablePointer<VerticeType>? {
            return UnsafeMutablePointer<VerticeType>( OpaquePointer( self.pointer ) )
        }

        public func commit() {
            buffer?.update( memory:self )
        }
        
        public func updateWithoutCommit( action:( UnsafeMutableBufferPointer<VerticeType>, Int )->() ) {
            guard let accessor = accessor else { return }
            action( accessor, accessor.count )
        }
        
        public func updateWithoutCommit( at index:Int, iteration:( _ accessor:inout VerticeType )->() ) {
            guard let accessor = accessor else { return }
            iteration( &accessor[index] )
        }
        
        public func updateWithoutCommit( range:Range<Int>, iteration:( _ accessor:inout VerticeType, _ index:Int )->() ) {
            guard let accessor = accessor else { return }
            range.forEach { iteration( &accessor[$0], $0 ) }
        }
        
        
        public func update( action:( UnsafeMutableBufferPointer<VerticeType>, Int )->() ) {
            guard let accessor = accessor else { return }
            action( accessor, accessor.count )
            commit()
        }
        
        public func update( at index:Int, iteration:( _ accessor:inout VerticeType )->() ) {
            guard let accessor = accessor else { return }
            iteration( &accessor[index] )
            commit()
        }
        
        public func update( range:Range<Int>, iteration:( _ accessor:inout VerticeType, _ index:Int )->() ) {
            guard let accessor = accessor else { return }
            range.forEach { iteration( &accessor[$0], $0 ) }
            commit()
        }
    }
}

#endif
