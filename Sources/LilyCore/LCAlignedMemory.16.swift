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
public class LCAlignedMemory16SmPtr {
    fileprivate var alignedMemory:LCAlignedMemoryInternal
    
    fileprivate init() {
        alignedMemory = LCAlignedMemoryInternal(alignment: 16 )
    }
}

public func LCAlignedMemory16Make() -> LCAlignedMemory16SmPtr {
    return LCAlignedMemory16SmPtr()
};

public func LCAlignedMemory16Pointer( _ mem_:LCAlignedMemory16SmPtr ) -> LLBytePtr? {
    return mem_.alignedMemory.pointer
}

public func LCAlignedMemory16Length( _ mem_:LCAlignedMemory16SmPtr ) -> Int {
    return mem_.alignedMemory.length
}

public func LCAlignedMemory16AllocatedLength( _ mem_:LCAlignedMemory16SmPtr ) -> Int {
    return mem_.alignedMemory.allocatedLength
}

public func LCAlignedMemory16Resize( _ mem_:LCAlignedMemory16SmPtr, _ length_:Int ) {
    mem_.alignedMemory.resize( length_ )
}

public func LCAlignedMemory16Append( _ mem_:LCAlignedMemory16SmPtr, _ src_:LCAlignedMemory16SmPtr ) {
    mem_.alignedMemory.append( src_.alignedMemory )
}

public func LCAlignedMemory16AppendBytes( _ mem_:LCAlignedMemory16SmPtr, _ bin_:LLNonNullUInt8Ptr, _ length_:Int ) {
    mem_.alignedMemory.append( bin_, length_ )
}

public func LCAlignedMemory16Clear( _ mem_:LCAlignedMemory16SmPtr ) {
    mem_.alignedMemory.clear()
}
