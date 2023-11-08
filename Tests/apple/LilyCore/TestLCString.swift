//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import XCTest

@testable import LilySwift

class TestLCString: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_equal() {
        let ls0 = LCStringMakeWithCChars( "あいうえお" )
        let ls1 = LCStringMakeWithCChars( "あいうえお" )
        let ls2 = LCStringMakeWithCChars( "かきくけこ" )
        
        // 同じ文字列 = true
        XCTAssertTrue( LCStringIsEqual( ls0, ls1 ) )
        // 異なる文字列 = false
        XCTAssertFalse( LCStringIsEqual( ls0, ls2 ) )
    }
    
    func test_compare() {
        let ls0 = LCStringMakeWithCChars( "あいうえお" )
        let ls1 = LCStringMakeWithCChars( "かきくけこ" )
        let ls2 = LCStringMakeWithCChars( "あいうえおかきく" )
        
        // ls0 < ls1 = true
        XCTAssertTrue( LCStringCompare( ls0, ls1 ) )
        // ls0 < ls2 = true
        XCTAssertTrue( LCStringCompare( ls0, ls2 ) )
    }
    
    func test_empty() {
        let s = LCStringZero()
        XCTAssertTrue( LCStringIsEmpty( s ) )
    } 
    
    func test_length() {
        // ASCIIのみ
        let ls0 = LCStringMakeWithCChars( "abcdefg" )
        // UTF8文字列カウント
        XCTAssertEqual( LCStringCount( ls0 ), 7 )
        // バイト数
        XCTAssertEqual( LCStringByteLength( ls0 ), 7 )

        // 日本語のみ
        let ls1 = LCStringMakeWithCChars( "あいうえお" )
        // UTF8文字列カウント
        XCTAssertEqual( LCStringCount( ls1 ), 5 )
        // バイト数
        XCTAssertEqual( LCStringByteLength( ls1 ), 15 )
        
        // ASCIIと日本語混在
        let ls2 = LCStringMakeWithCChars( "あいうえおabcかきくけこ" )
        // UTF8文字列カウント
        XCTAssertEqual( LCStringCount( ls2 ), 13 )
        // バイト数
        XCTAssertEqual( LCStringByteLength( ls2 ), 33 )
    }
    
    func test_cast() {
        // プラスのオーバーフロー境界
        let str_127 = LCStringMakeWithCChars( "127" )
        let str_i8_over = LCStringMakeWithCChars( "128" )
        let str_u8_over = LCStringMakeWithCChars( "256" )
        let str_i16_over = LCStringMakeWithCChars( "32768" )
        let str_u16_over = LCStringMakeWithCChars( "65536" )
        let str_i32_over = LCStringMakeWithCChars( "2147483648" )
        let str_u32_over = LCStringMakeWithCChars( "4294967296" )
        let str_i64_over = LCStringMakeWithCChars( "9223372036854775808" )
        let str_u64_over = LCStringMakeWithCChars( "18446744073709551616" )
        // マイナスのオーバーフロー境界
        let str_m128 = LCStringMakeWithCChars( "-128" )
        let str_mi8_over = LCStringMakeWithCChars( "-257" )
        let str_mi16_over = LCStringMakeWithCChars( "-32769" )
        let str_mi32_over = LCStringMakeWithCChars( "-2147483649" )
        let str_mi64_over = LCStringMakeWithCChars( "-9223372036854775809" )
        
        let str_f = LCStringMakeWithCChars( "123456.7890123" )
        
        let str_f_i8 = LCStringMakeWithCChars( "123.4" )
        let str_f_mi8 = LCStringMakeWithCChars( "-123.4" )
        
        let str_noise = LCStringMakeWithCChars( "abc123.4" )
        
        let err = LLErrorMake()
        
        // Int8正常
        XCTAssertEqual( LCStringToI8( str_127, err ), 127 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int8オーバーフロー
        let _ = LCStringToI8( str_i8_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // UInt8正常
        XCTAssertEqual( LCStringToU8( str_i8_over, err ), 128 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // UInt8オーバーフロー
        let _ = LCStringToU8( str_u8_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 ) 
        // Int16正常
        XCTAssertEqual( LCStringToI16( str_u8_over, err ), 256 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int16オーバーフロー
        let _ = LCStringToI16( str_i16_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // UInt16正常
        XCTAssertEqual( LCStringToU16( str_i16_over, err ), 32768 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // UInt16オーバーフロー
        let _ = LCStringToU16( str_u16_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 ) 
        // Int32正常
        XCTAssertEqual( LCStringToI32( str_u16_over, err ), 65536 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int32オーバーフロー
        let _ = LCStringToI32( str_i32_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // UInt32正常
        XCTAssertEqual( LCStringToU32( str_i32_over, err ), 2147483648 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // UInt32オーバーフロー
        let _ = LCStringToU32( str_u32_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 ) 
        // Int64正常
        XCTAssertEqual( LCStringToI64( str_u32_over, err ), 4294967296 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int64オーバーフロー
        let _ = LCStringToI64( str_i64_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // UInt64正常
        XCTAssertEqual( LCStringToU64( str_i64_over, err ), 9223372036854775808 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // UInt64オーバーフロー
        let _ = LCStringToU64( str_u64_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 ) 
        
        // Int8マイナス正常
        XCTAssertEqual( LCStringToI8( str_m128, err ), -128 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int8マイナスオーバーフロー
        let _ = LCStringToI8( str_mi8_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // Int16マイナス正常
        XCTAssertEqual( LCStringToI16( str_mi8_over, err ), -257 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int16マイナスオーバーフロー
        let _ = LCStringToI16( str_mi16_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // Int32マイナス正常
        XCTAssertEqual( LCStringToI32( str_mi16_over, err ), -32769 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int32マイナスオーバーフロー
        let _ = LCStringToI32( str_mi32_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // Int64マイナス正常
        XCTAssertEqual( LCStringToI64( str_mi32_over, err ), -2147483649 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Int64マイナスオーバーフロー
        let _ = LCStringToI64( str_mi64_over, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        
        // Float正常
        XCTAssertEqual( LCStringToF( str_f, err ), 123456.7890123 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        // Double正常
        XCTAssertEqual( LCStringToD( str_f, err ), 123456.7890123 )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        
        // 小数->整数キャスト(エラーの扱い)
        let _ = LCStringToI8( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI16( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI32( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI64( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI( str_f_i8, err ) 
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // ↓符号無し
        let _ = LCStringToU8( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU16( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU32( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU64( str_f_i8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU( str_f_i8, err ) 
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // マイナス込みの小数->整数キャスト(エラー)
        let _ = LCStringToI8( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI16( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI32( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI64( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToI( str_f_mi8, err ) 
        XCTAssertEqual( LLErrorCode( err ), 1 )
        // 符号無し(エラー)
        let _ = LCStringToU8( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU16( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU32( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU64( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        let _ = LCStringToU( str_f_mi8, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
        
        // 数値以外が含まれる場合(エラー)
        let _ = LCStringToI8( str_noise, err )
        XCTAssertEqual( LLErrorCode( err ), 1 )
    }
    
    // find()のテスト
    func test_find() {
        let str1 = LCStringMakeWithCChars( "abcdefghijklmnopqrstuvwxyz" )
        let key1_1 = LCStringMakeWithCChars( "bcd" )
        let key1_2 = LCStringMakeWithCChars( "efg" )
        let key1_3 = LCStringMakeWithCChars( "hoge" )
    
        XCTAssertEqual( LCStringFind( str1, 0, key1_1 ), 1 ) // ASCII 1文字 * 1byte = 1
        XCTAssertEqual( LCStringFind( str1, 0, key1_2 ), 4 ) // ASCII 4文字 * 1byte = 4
        XCTAssertEqual( LCStringFind( str1, 0, key1_3 ), -1 ) // 存在しない = -1
    
        let str2 = LCStringMakeWithCChars( "あいうえおabcかきくけこdefghさしすせそijklmn" )
        let key2_1 = LCStringMakeWithCChars( "おab" )
        let key2_2 = LCStringMakeWithCChars( "efg" )
        let key2_3 = LCStringMakeWithCChars( "hoge" )
    
        XCTAssertEqual( LCStringFind( str2, 0, key2_1 ), 12 ) // かな4字 * 3byte = 12
        XCTAssertEqual( LCStringFind( str2, 0, key2_2 ), 34 ) // かな10字 * 3byte + ASCII 4字 * 1byte = 34
        XCTAssertEqual( LCStringFind( str2, 0, key2_3 ), -1 ) // 存在しない = -1
        
        let str3 = LCStringMakeWithCChars( "abcdefghijklmnopqrstuvwxyz" )
        let key3_1 = LCStringMakeWithCChars( "jkl" )
    
        XCTAssertEqual( LCStringFind( str3, 0, key3_1 ), 9 ) // 先頭からの検索
        XCTAssertEqual( LCStringFind( str3, 9, key3_1 ), 9 ) // 開始点が発見位置のとき
        XCTAssertEqual( LCStringFind( str3, 12, key3_1 ), -1 ) // 開始点が過ぎている = -1
    }
    
    func test_findReverse() {
        let str1 = LCStringMakeWithCChars( "abcdefghijkabcdefghijkabcdefghijk" )
        let key1_1 = LCStringMakeWithCChars( "bcd" )
        let key1_2 = LCStringMakeWithCChars( "efg" )
        let key1_3 = LCStringMakeWithCChars( "hoge" )
    
        XCTAssertEqual( LCStringFindReverse( str1, key1_1 ), 23 )
        XCTAssertEqual( LCStringFindReverse( str1, key1_2 ), 26 )
        XCTAssertEqual( LCStringFindReverse( str1, key1_3 ), -1 ) // 存在しない = -1
    }
 
    func test_rewrite() {
        let s1 = LCStringMakeWithCChars( "abc" )
        let s2 = LCStringMakeWithCChars( "def" )
        // s1を上書き
        LCStringRewrite( s1, s2 )
        XCTAssertEqual( String( s1 ), String( s2 ) )
    }
    
    func test_append() {
        let s1 = LCStringMakeWithCChars( "abc" )
        let s2 = LCStringMakeWithCChars( "def" )
        let s3 = LCStringMakeWithCChars( "abcdef" )
        // s1を上書き
        LCStringAppend( s1, s2 )
        // s1とs3を比較して一致を確認
        XCTAssertEqual( String( s1 ), String( s3 ) )
    }
    
    func test_insert() {
        let s1 = LCStringMakeWithCChars( "abcghi" )
        let s2 = LCStringMakeWithCChars( "def" )
        let s3 = LCStringMakeWithCChars( "abcdefghi" )
        // s1にs2をpos=3から挿入
        LCStringInsert( s1, s2, 3 )
        // s1とs3を比較して一致を確認
        XCTAssertEqual( String( s1 ), String( s3 ) )
    }
    
    func test_clear() {
        let s1 = LCStringMakeWithCChars( "abcdef" )
        // s1を空にする
        LCStringClear( s1 )
        // s1が空であることを確認
        XCTAssertTrue( LCStringIsEmpty( s1 ) )
    }
    
    func test_join() {
        let s1 = LCStringMakeWithCChars( "abcd" )
        let s2 = LCStringMakeWithCChars( "efgi" )
        let s3 = LCStringJoin( s1, s2 )
        let s4 = LCStringMakeWithCChars( "abcdefgi" )
        // s3とs4を比較して一致を確認
        XCTAssertEqual( String( s3 ), String( s4 ) )
    }
    
    func test_subString() {
        let str1 = LCStringMakeWithCChars( "abcdeあいうえおfghiかきくけ" )
        XCTAssertEqual( String( LCStringSubString( str1, 4, 13 ) ), "eあいうえ" )     // UTF8のバイト数に合わせた切り出し
        XCTAssertNotEqual( String( LCStringSubString( str1, 4, 5 ) ), "eあいうえ" )   // 文字数ではない
        XCTAssertEqual( String( LCStringSubString( str1, 8, 12 ) ), "いうえお" )      // UTF8のバイト数に合わせた切り出し
    }
    
    func test_split() {
        let str1 = LCStringMakeWithCChars( "abc,defg,hi,jklm,nop,あいうえお,xxx,かきくhoge,けこ" )
        let strs = LCStringSplit( str1, LCStringMakeWithCChars( "," ) )
        let checks = [ "abc", "defg", "hi", "jklm", "nop", "あいうえお", "xxx", "かきくhoge", "けこ" ]
        
        for i in 0 ..< LCStringArrayCount( strs ) {
            let s = LCStringArrayAt( strs, i )
            XCTAssertEqual( String( s ), checks[i] )
        }
    }
    
    func test_lowercased() {
        XCTAssert( true, "未テスト" )
    }
    
    func test_upperrcased() {
        XCTAssert( true, "未テスト" )
    }
}
