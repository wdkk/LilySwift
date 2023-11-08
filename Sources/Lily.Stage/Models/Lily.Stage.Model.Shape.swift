//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

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
        
        public func update() {
            buffer?.update( memory:self )
        }
        
        public var metalBuffer:MTLBuffer? {
            return buffer?.metalBuffer
        }
        
        public var memory:UnsafeMutablePointer<VerticeType>? {
            return UnsafeMutablePointer<VerticeType>( OpaquePointer( self.pointer ) )
        }
        
        public var vertice:UnsafeMutablePointer<VerticeType> {
            return UnsafeMutablePointer<VerticeType>( OpaquePointer( self.pointer! ) )
        }
    }
}
