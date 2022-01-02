//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

class LCAlignedMemoryInternal
{
    private(set) var allocator:LCAlignedMemoryAllocator
    
    init( alignment:Int ) {
        self.allocator = LCAlignedMemoryAllocator( alignment: alignment )
    }
    
    // メモリの追加
    private func allocate( length newleng:Int ) {
        self.allocator.allocate( length: newleng )
    }
    
    var pointer:LLBytePtr? {
        return self.allocator.pointer
    }
    
    var alignment:Int {
        return self.allocator.alignment
    }
    
    var length:Int {
        return self.allocator.length
    }
    
    var allocatedLength:Int {
        return self.allocator.allocatedLength
    }
    
    func resize( _ size:Int ) {
        self.allocate( length: size )
    }
    
    func append( _ src:LCAlignedMemoryInternal ) {
        let old_length:Int = self.length
        let new_length:Int = old_length + src.length
        self.allocate( length: new_length )
        guard let offset_ptr:LLBytePtr = self.pointer?.advanced(by: old_length ) else {
            LLLogWarning( "新たに取得したメモリのポインタを取得できませんでした." )
            return
        }
        memcpy( offset_ptr, src.pointer, src.length )
    }
    
    func append( _ bin:LLUInt8Ptr, _ length:Int ) {
        let old_length:Int = self.allocator.length
        let new_length:Int = old_length + length
        self.allocate( length: new_length )
        guard let offset_ptr:LLBytePtr = self.pointer?.advanced(by: old_length ) else {
            LLLogWarning( "新たに取得したメモリのポインタを取得できませんでした." )
            return
        }
        memcpy( offset_ptr, bin, length )
    }
    
    func clear() {
        self.allocator.deallocate()
    }
}
