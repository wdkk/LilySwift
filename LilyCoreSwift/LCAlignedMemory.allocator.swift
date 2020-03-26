//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//


import Foundation

public class LCAlignedMemoryAllocator
{
    let alignment:Int
    var memory:LLBytePtr?
    public private(set) var length:Int
    public private(set) var allocatedLength:Int
    
    public var pointer:LLBytePtr? {
        return self.memory
    }
    
    public init( alignment:Int ) {
        self.alignment = alignment
        self.length = 0
        self.allocatedLength = 0
        self.memory = nil
    }
    
    deinit {
        clear()
    }
    
    private func alignedAllocate( alignment:Int, length:Int ) {
        if length == 0 { 
            clear()
            return
        }
        
        var mem:UnsafeMutableRawPointer? = nil
        posix_memalign( &mem, alignment, length )
        self.memory = LLBytePtr( OpaquePointer( mem ) )
    }
    
    private func clear() {
        if self.memory != nil {
            free( self.memory ) 
            self.memory = nil
        }
    }
    
    // アラインメントを含んだメモリ確保量を計算
    public func requestAlignedLength( from length:Int ) -> Int {
        let mod = length % self.alignment
        return length + ( mod > 0 ? self.alignment - mod : 0 )
    }
    
    // 前のメモリ内容を維持したままのメモリの確保
    func allocate( length:Int ) {
        if length == 0 {
            clear()
            return
        }
        
        if requestAlignedLength( from:length ) <= self.allocatedLength {
            self.length = length
            return
        }
        
        let old_length = self.length
        self.length = length
        self.allocatedLength = requestAlignedLength( from:length )
        
        if self.memory != nil {
            /*
            let tmp_data = LCDataMakeWithBytes( self.memory, self.length )
            alignedAllocate( alignment: self.alignment, length: self.allocatedLength )
            let copy_length = min( self.length, LCDataLength( tmp_data ).i! )
            memcpy( self.memory, LCDataPointer( tmp_data ), copy_length )
            */
            
            let tmp_mem = LLBytePtr( OpaquePointer( malloc( old_length ) ) )
            memcpy( tmp_mem, self.memory, old_length )
            alignedAllocate( alignment: self.alignment, length: self.allocatedLength )
            let copy_length = min( self.length, old_length )
            memcpy( self.memory, tmp_mem, copy_length )
            free( tmp_mem )
        }
        else {
            clear()
            alignedAllocate( alignment: self.alignment, length: self.allocatedLength )
        }
    }
    
    func deallocate() {
        clear()
    }
}
