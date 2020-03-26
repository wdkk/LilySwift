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

class TestLCZ: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_deflate_and_inflate() {
        // 元データ
        let str = "こんにちわ、良い天気ですね。今日はあたたかくて気持ちがよいですね。🍆"
        let data1 = LCDataMakeWithCChars( str )
        let length1 = LCDataLength( data1 )
        
        // zlib圧縮
        let data2 = LCZDeflate( LCDataPointer( data1 )!, length1.i!, .default_compression )
        let length2 = LCDataLength( data2 )
        
        // サイズが異なることを確認
        XCTAssertNotEqual( length1, length2 )
        
        // zlib伸長
        let data3 = LCZInflate( LCDataPointer( data2 )!, length2.i! )
        let length3 = LCDataLength( data3 )
        
        // サイズが圧縮前と一緒であることを確認
        XCTAssertEqual( length1, length3 )
        
        let lcStr2 = LCStringMakeWithBytes( LCDataPointer( data3 )!, length3.i! )
        let str2 = String( lcStr2 )
        
        // 文字列の一致の確認
        XCTAssertEqual( str, str2 )
    }
}
