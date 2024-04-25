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

#if !os(watchOS)

import Foundation
import Metal

extension Lily.Metal
{    
    open class RingBuffer<T>
    {
        open var buffers:[Buffer<T>] = []
        private let ringLength:Int
        private var ringIndex:Int = 0
        
        public init( device:MTLDevice, ringSize:Int ) {
            ringLength = ringSize
            for _ in 0 ..< ringSize {
                buffers.append( .init( device:device, count:1 ) )
            }
        }
        
        public func update( action:( inout T )->() ) {
            buffers[ringIndex].update( at:0, iteration:action )
        }
    
        public var current:T? { buffers[ringIndex].accessor?.first }
        
        public var metalBuffer:MTLBuffer? { buffers[ringIndex].metalBuffer }
        
        public func next() {
            ringIndex = ( ringIndex + 1 ) % ringLength
        }
    }
}

#endif
