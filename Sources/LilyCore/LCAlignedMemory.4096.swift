//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

// ラッパークラス実装
public class LCAlignedMemory4096SmPtr {
    fileprivate var alignedMemory:LCAlignedMemoryInternal
    
    fileprivate init() {
        alignedMemory = LCAlignedMemoryInternal(alignment: 4096 )
    }
}

public func LCAlignedMemory4096Make() -> LCAlignedMemory4096SmPtr {
    return LCAlignedMemory4096SmPtr()
};

public func LCAlignedMemory4096Pointer( _ mem_:LCAlignedMemory4096SmPtr ) -> LLBytePtr? {
    return mem_.alignedMemory.pointer
}

public func LCAlignedMemory4096Length( _ mem_:LCAlignedMemory4096SmPtr ) -> Int {
    return mem_.alignedMemory.length
}

public func LCAlignedMemory4096AllocatedLength( _ mem_:LCAlignedMemory4096SmPtr ) -> Int {
    return mem_.alignedMemory.allocatedLength
}

public func LCAlignedMemory4096Resize( _ mem_:LCAlignedMemory4096SmPtr, _ length_:Int ) {
    mem_.alignedMemory.resize( length_ )
}

public func LCAlignedMemory4096Append( _ mem_:LCAlignedMemory4096SmPtr, _ src_:LCAlignedMemory4096SmPtr ) {
    mem_.alignedMemory.append( src_.alignedMemory )
}

public func LCAlignedMemory4096AppendBytes( _ mem_:LCAlignedMemory4096SmPtr, _ bin_:LLNonNullUInt8Ptr, _ length_:Int ) {
    mem_.alignedMemory.append( bin_, length_ )
}

public func LCAlignedMemory4096Clear( _ mem_:LCAlignedMemory4096SmPtr ) {
    mem_.alignedMemory.clear()
}
