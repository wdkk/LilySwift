//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if LILY_FULL

import Foundation

// ラッパークラス実装
public class LCAlignedMemory16SmPtr {
    fileprivate var amemory:LCAlignedMemoryInternal
    
    fileprivate init() {
        amemory = LCAlignedMemoryInternal(alignment: 16 )
    }
}

public func LCAlignedMemory16Make() -> LCAlignedMemory16SmPtr {
    return LCAlignedMemory16SmPtr()
};

public func LCAlignedMemory16Pointer( _ mem_:LCAlignedMemory16SmPtr ) -> LLBytePtr? {
    return mem_.amemory.pointer
}

public func LCAlignedMemory16Length( _ mem_:LCAlignedMemory16SmPtr ) -> Int {
    return mem_.amemory.length
}

public func LCAlignedMemory16AllocatedLength( _ mem_:LCAlignedMemory16SmPtr ) -> Int {
    return mem_.amemory.allocatedLength
}

public func LCAlignedMemory16Resize( _ mem_:LCAlignedMemory16SmPtr, _ length_:Int ) {
    mem_.amemory.resize( length_ )
}

public func LCAlignedMemory16Append( _ mem_:LCAlignedMemory16SmPtr, _ src_:LCAlignedMemory16SmPtr ) {
    mem_.amemory.append( src_.amemory )
}

public func LCAlignedMemory16AppendBytes( _ mem_:LCAlignedMemory16SmPtr, _ bin_:LLNonNullUInt8Ptr, _ length_:Int ) {
    mem_.amemory.append( bin_, length_ )
}

public func LCAlignedMemory16Clear( _ mem_:LCAlignedMemory16SmPtr ) {
    mem_.amemory.clear()
}

#endif
