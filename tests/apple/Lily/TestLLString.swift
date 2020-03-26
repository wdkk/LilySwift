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

class TestLLString: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_length() {
        let str = "あいうえお"
        XCTAssertEqual( str.count, 5 )
        XCTAssertEqual( str.lengthOfBytes(using: .utf8 ), 15 )
    }
    
    // 初期化のテストs
    func test_init() {
        // 英語文字列初期化(Lily - LilyCore)
        let s1_1 = "test string"
        let s1_2 = LLString( "test string" )
        let s1_3 = LLString( LCStringMakeWithCChars( "test string" ) )
        XCTAssertEqual( s1_1, s1_2 )
        XCTAssertEqual( s1_1, s1_3 )
        
        // 日本語文字列初期化(Lily - LilyCore)
        let s2_1 = LLString( "あいうえおabcかきくけこ" )
        let s2_2 = LLString( LCStringMakeWithCChars( "あいうえおabcかきくけこ" ) )
        XCTAssertEqual( s2_1, s2_2 )
    }
    
    // C文字列変換のテスト(Lily - LilyCore)
    func test_cChar() {
        let s1_1 = "test characters"
        let s1_2 = LCStringMakeWithCChars( "test characters" )
        let c1_1 = s1_1.cChar
        let c1_2 = LCStringToCChars( s1_2 )
        // Stringに戻しての比較で確認
        XCTAssertEqual( String( cString: c1_1 ), String( cString: c1_2 ) )
    }
    
    // lcStr変換のテスト
    func test_lcStr() {
        let c1_1 = LLString( "hogehugahoge" ).lcStr
        let c1_2 = LCStringMakeWithCChars( "hogehugahoge" )
        XCTAssertTrue( LCStringIsEqual( c1_1, c1_2 ) )
    }
    
    // 各種キャスティングのテスト
    func test_cast() {
        let s = [ "123", "123.4", "aaa123", "abc", "-53", "123456789012345678901234567890" ]

        XCTAssertEqual( s[0].i, 123 )
        XCTAssertNil( s[1].i )
        XCTAssertNil( s[2].i )
        XCTAssertNil( s[3].i )
        XCTAssertEqual( s[4].i, -53 )
        XCTAssertNil( s[5].i )
        
        XCTAssertEqual( s[0].i8, 123 )
        XCTAssertNil( s[1].i8 )
        XCTAssertNil( s[2].i8 )
        XCTAssertNil( s[3].i8 )
        XCTAssertEqual( s[4].i8, -53 )
        XCTAssertNil( s[5].i8 )
        
        XCTAssertEqual( s[0].i16, 123 )
        XCTAssertNil( s[1].i16 )
        XCTAssertNil( s[2].i16 )
        XCTAssertNil( s[3].i16 )
        XCTAssertEqual( s[4].i16, -53 )
        XCTAssertNil( s[5].i16 )
        
        XCTAssertEqual( s[0].i32, 123 )
        XCTAssertNil( s[1].i32 )
        XCTAssertNil( s[2].i32 )
        XCTAssertNil( s[3].i32 )
        XCTAssertEqual( s[4].i32, -53 )
        XCTAssertNil( s[5].i32 )
        
        XCTAssertEqual( s[0].i64, 123 )
        XCTAssertNil( s[1].i64 )
        XCTAssertNil( s[2].i64 )
        XCTAssertNil( s[3].i64 )
        XCTAssertEqual( s[4].i64, -53 )
        XCTAssertNil( s[5].i64 )
        
        XCTAssertEqual( s[0].u, 123 )
        XCTAssertNil( s[1].u )
        XCTAssertNil( s[2].u )
        XCTAssertNil( s[3].u )
        XCTAssertNil( s[4].u )
        XCTAssertNil( s[5].u )
        
        XCTAssertEqual( s[0].u8, 123 )
        XCTAssertNil( s[1].u8 )
        XCTAssertNil( s[2].u8 )
        XCTAssertNil( s[3].u8 )
        XCTAssertNil( s[4].u8 )
        XCTAssertNil( s[5].u8 )
        
        XCTAssertEqual( s[0].u16, 123 )
        XCTAssertNil( s[1].u16 )
        XCTAssertNil( s[2].u16 )
        XCTAssertNil( s[3].u16 )
        XCTAssertNil( s[4].u16 )
        XCTAssertNil( s[5].u16 )
        
        XCTAssertEqual( s[0].u32, 123 )
        XCTAssertNil( s[1].u32 )
        XCTAssertNil( s[2].u32 )
        XCTAssertNil( s[3].u32 )
        XCTAssertNil( s[4].u32 )
        XCTAssertNil( s[5].u32 )
        
        XCTAssertEqual( s[0].u64, 123 )
        XCTAssertNil( s[1].u64 )
        XCTAssertNil( s[2].u64 )
        XCTAssertNil( s[3].u64 )
        XCTAssertNil( s[4].u64 )
        XCTAssertNil( s[5].u64 )
        
        XCTAssertEqual( s[0].f, 123.0 )
        XCTAssertEqual( s[1].f, 123.4 )
        XCTAssertNil( s[2].f )
        XCTAssertNil( s[3].f )
        XCTAssertEqual( s[4].f, -53.0 )
        XCTAssertEqual( s[5].f, 1.234567890123456789e+29 )
        
        XCTAssertEqual( s[0].d, 123.0 )
        XCTAssertEqual( s[1].d, 123.4 )
        XCTAssertNil( s[2].d )
        XCTAssertNil( s[3].d )
        XCTAssertEqual( s[4].d, -53.0 )
        XCTAssertEqual( s[5].d, 1.234567890123456789e+29 )
        
        XCTAssertEqual( s[0].cgf, 123.0 )
        XCTAssertEqual( s[1].cgf, 123.4 )
        XCTAssertNil( s[2].cgf )
        XCTAssertNil( s[3].cgf )
        XCTAssertEqual( s[4].cgf, -53.0 )
        XCTAssertEqual( s[5].cgf, 1.234567890123456789e+29 )
    }
    
    // find()のテスト
    func test_find() {
        let str1 = "abcdefghijklmnopqrstuvwxyz"
        let key1_1 = "bcd"
        let key1_2 = "efg"
        let key1_3 = "hoge"
    
        XCTAssertEqual( str1.find( 0, key: key1_1 ), 1 ) // ASCII 1文字 * 1byte = 1
        XCTAssertEqual( str1.find( 0, key: key1_2 ), 4 ) // ASCII 4文字 * 1byte = 4
        XCTAssertEqual( str1.find( 0, key: key1_3 ), -1 ) // 存在しない = -1
    
        let str2 = "あいうえおabcかきくけこdefghさしすせそijklmn"
        let key2_1 = "おab"
        let key2_2 = "efg"
        let key2_3 = "hoge"
    
        XCTAssertEqual( str2.find( 0, key: key2_1 ), 12 ) // かな4字 * 3byte = 12
        XCTAssertEqual( str2.find( 0, key: key2_2 ), 34 ) // かな10字 * 3byte + ASCII 4字 * 1byte = 34
        XCTAssertEqual( str2.find( 0, key: key2_3 ), -1 ) // 存在しない = -1
        
        let str3 = "abcdefghijklmnopqrstuvwxyz"
        let key3_1 = "jkl"
    
        XCTAssertEqual( str3.find( 0, key: key3_1 ), 9 ) // 先頭からの検索
        XCTAssertEqual( str3.find( 9, key: key3_1 ), 9 ) // 開始点が発見位置のとき
        XCTAssertEqual( str3.find( 12, key: key3_1 ), -1 ) // 開始点が過ぎている = -1
    }
    
    func test_findReverse() {
        let str1 = "abcdefghijkabcdefghijkabcdefghijk"
        let key1_1 = "bcd"
        let key1_2 = "efg"
        let key1_3 = "hoge"
    
        XCTAssertEqual( str1.findReverse( key1_1 ), 23 )
        XCTAssertEqual( str1.findReverse( key1_2 ), 26 )
        XCTAssertEqual( str1.findReverse( key1_3 ), -1 ) // 存在しない = -1
    }
    
    func test_subString() {
        let str1 = "abcdeあいうえおfghiかきくけ"
        XCTAssertEqual( str1.subString(from: 4, length: 13 ), "eあいうえ" )     // UTF8のバイト数に合わせた切り出し
        XCTAssertNotEqual( str1.subString(from: 4, length: 5 ), "eあいうえ" )   // 文字数ではない
        XCTAssertEqual( str1.subString(from: 8, length: 12 ), "いうえお" )      // UTF8のバイト数に合わせた切り出し
    }
    
    func test_split() {
        let str1 = "abc,defg,hi,jklm,nop,あいうえお,xxx,かきくhoge,けこ"
        let strs = str1.split( "," )
        let checks = [ "abc", "defg", "hi", "jklm", "nop", "あいうえお", "xxx", "かきくhoge", "けこ" ]
        
        var i:Int = 0
        for s in strs {
            XCTAssertEqual( s, checks[i] )
            i += 1
        }
    }
}
