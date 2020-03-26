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

class TestLCFileReader: XCTestCase {

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
        let path = test_bundle_path + "supportFiles/text/" + "japanese_hello.txt"
        let reader = LCFileReaderMake( path.lcStr )
        XCTAssertNotNil( reader )
        LCFileReaderEnd( reader )
    }
    
    func test_isActive() {
        let path = test_bundle_path + "supportFiles/text/" + "japanese_hello.txt"
        let reader = LCFileReaderMake( path.lcStr )
        // アクティブの確認
        XCTAssertTrue( LCFileReaderIsActive( reader ) )
        LCFileReaderEnd( reader )
        // 終了後の非アクティブの確認
        XCTAssertFalse( LCFileReaderIsActive( reader ) )
        
        // ダメなパスを開いた時のアクティブのチェック
        let ng_path = test_bundle_path + "supportFiles/text/" + "nonfile.dat"
        let ng_reader = LCFileReaderMake( ng_path.lcStr )
        XCTAssertFalse( LCFileReaderIsActive( ng_reader ) )
    }
    
    func test_read() {
        let path = test_bundle_path + "supportFiles/text/" + "japanese_hello.txt"
        let reader = LCFileReaderMake( path.lcStr )
        let length = LCFileGetSize( path.lcStr )
        let data = LCDataMakeWithSize( length )
        let bin = LCDataPointer( data )
        // 読み込み成功の確認
        XCTAssertTrue( LCFileReaderRead( reader, bin!, length ) )
        // 読み込み内容の確認
        let lcStr = LCStringMakeWithBytes( bin!, length.i! )
        XCTAssertEqual( String( lcStr ), "こんにちわ、良い天気ですね。" )
    }
    
    func test_end() {
        let path = test_bundle_path + "supportFiles/text/" + "japanese_hello.txt"
        let reader = LCFileReaderMake( path.lcStr )
        // アクティブの確認
        XCTAssertTrue( LCFileReaderIsActive( reader ) )
        // 読み込み終了の確認
        XCTAssertTrue( LCFileReaderEnd( reader ) )
        // 非アクティブの確認
        XCTAssertFalse( LCFileReaderIsActive( reader ) )
    }
}
