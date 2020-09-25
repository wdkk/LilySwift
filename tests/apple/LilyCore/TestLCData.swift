//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import XCTest

@testable import LilySwift

class TestLCData : XCTestCase {

    #if targetEnvironment(macCatalyst)
    let test_bundle_path = Bundle(for:TestLCData.self).bundlePath + "/Contents/Resources/"
    #elseif targetEnvironment(simulator)
    let test_bundle_path = Bundle(for:TestLCData.self).bundlePath + "/"
    #elseif os(macOS)
    let test_bundle_path = Bundle(for:TestLCData.self).bundlePath + "/Contents/Resources/"
    #endif
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        let data = LCDataMake()
        // ポインタnilの確認
        XCTAssertTrue( LCDataPointer( data ) == nil )
        // サイズ0の確認
        XCTAssertEqual( LCDataLength( data ) , 0 )
    }
    
    func test_initWithSize() {
        let data = LCDataMakeWithSize( 100 )
        // ポインタnilの確認
        XCTAssertTrue( LCDataPointer( data ) != nil )
        // サイズ0の確認
        XCTAssertEqual( LCDataLength( data ) , 100 )
    }
    
    func test_initWithCChars() {
        let str = "こんにちわ"
        let data = LCDataMakeWithCChars( "こんにちわ" )
        
        // サイズの確認
        XCTAssertEqual( LCDataLength( data ), str.lengthOfBytes(using: .utf8 ).i64 )
        
        // データ復元の確認
        let ptr = LCDataPointer( data )!
        let length = LCDataLength( data )
        let result = LCStringMakeWithBytes( ptr, length.i! )
        XCTAssertEqual( String( result ), String( str ) )
    }
    
    func test_initWithString() {
        let str = LCStringMakeWithCChars( "こんにちわ" )
        let length = LCStringByteLength( str )
        let data = LCDataMakeWithString( str )

        // サイズの確認
        XCTAssertEqual( LCDataLength( data ), length.i64 )
        
        // データ復元の確認
        let ptr = LCDataPointer( data )!
        let result = LCStringMakeWithBytes( ptr, length )
        XCTAssertEqual( String( result ), String( str ) )
    }
    
    func test_initWithFile() {
        let path = test_bundle_path + "supportFiles/text/"
        
        // ファイルから読み出す
        let data = LCDataMakeWithFile( ( path + "japanese_hello.txt" ).lcStr )
        let length = LCDataLength( data )

        // データ復元の確認
        let ptr = LCDataPointer( data )!
        let result = LCStringMakeWithBytes( ptr, length.i! )
        XCTAssertEqual( String( result ), "こんにちわ、良い天気ですね。" )
    }
    
    func test_pointer() {
        // 文字列からのデータ化
        let str = LCStringMakeWithCChars( "こんにちわ" )
        let data = LCDataMakeWithString( str )
        // nullでない確認
        XCTAssertTrue( LCDataPointer( data ) != nil )
    
        // サイズ指定でのデータ化
        let data2 = LCDataMakeWithSize( 1 )
        // nullでない確認
        let ptr = LCDataPointer( data2 )
        XCTAssertTrue( ptr != nil )
        ptr![0] = 135 
        // 文字列一致の確認
        XCTAssertEqual( ptr![0], 135 )
    }
    
    func test_length() {
        let str = LCStringMakeWithCChars( "こんにちわ" )
        let data = LCDataMakeWithString( str )
        
        // サイズの確認
        XCTAssertEqual( LCDataLength( data ), 15 )
    }
    
    func test_appendData() {
        let str1 = LCStringMakeWithCChars( "こんにちわ、" )
        let data1 = LCDataMakeWithString( str1 )
        
        let str2 = LCStringMakeWithCChars( "良い天気ですね。" )
        let data2 = LCDataMakeWithString( str2 )
        
        // データの追記
        LCDataAppend( data1, data2 )
        
        // 追記データと文字列の比較
        let ptr = LCDataPointer( data1 )!
        let result = LCStringMakeWithBytes( ptr, LCDataLength( data1 ).i! )
        XCTAssertEqual( String( result ), "こんにちわ、良い天気ですね。" )
    }
    
    func test_appenBytes() {
        let str1 = LCStringMakeWithCChars( "こんにちわ、" )
        let data1 = LCDataMakeWithString( str1 )
        
        let str2 = "良い天気ですね。"
        let buffer2 = str2.cChar.withUnsafeBytes { $0 }
        let bin2 = LLNonNullUInt8Ptr( OpaquePointer( buffer2.baseAddress ) )
        let length = buffer2.count.i64
        
        // データの追記
        LCDataAppendBytes( data1, bin2, length )
        
        // 追記データと文字列の比較
        let ptr = LCDataPointer( data1 )!
        let result = LCStringMakeWithBytes( ptr, LCDataLength( data1 ).i! )
        XCTAssertEqual( String( result ), "こんにちわ、良い天気ですね。" )
    }
    
    func test_appenChars() {
        let str1 = LCStringMakeWithCChars( "こんにちわ、" )
        let data1 = LCDataMakeWithString( str1 )
        
        // データの追記
        LCDataAppendChars( data1, "良い天気ですね。".cChar )
        
        // 追記データと文字列の比較
        let ptr = LCDataPointer( data1 )!
        let result = LCStringMakeWithBytes( ptr, LCDataLength( data1 ).i! )
        XCTAssertEqual( String( result ), "こんにちわ、良い天気ですね。" )
    }
}
