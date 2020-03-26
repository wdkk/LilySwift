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

class TestLCFileWriter: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        // テスト前の削除
        LCFileRemove( path )
    
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        XCTAssertNotNil( writer )
        LCFileWriterEnd( writer )
        // 後片付け
        LCFileRemove( path )
    }
    
    func test_isActive() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        // テスト前の削除
        LCFileRemove( path )
    
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        // アクティブの確認
        XCTAssertTrue( LCFileWriterIsActive( writer ) )
        LCFileWriterEnd( writer )
        // 終了後の非アクティブの確認
        XCTAssertFalse( LCFileWriterIsActive( writer ) )
        // 後片付け
        LCFileRemove( path )
        
        // 書き込めないところ(バンドルディレクトリ)に書き込もうとした場合
        let ng_path = LCPathGetBundle( "dummy.dat".lcStr )
        let ng_writer = LCFileWriterMake( ng_path, false )
        // 非アクティブの確認
        XCTAssertFalse( LCFileWriterIsActive( ng_writer ) )
        LCFileWriterEnd( ng_writer )
        // 後片付け
        LCFileRemove( ng_path )
    }

    func test_write() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        let str = "こんにちわ、お加減いかがですか"
        
        // テスト前の削除
        LCFileRemove( path )
        
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        // 書き込み内容の準備
        let lcStr = LCDataMakeWithString( str.lcStr )
        let bin = LCDataPointer( lcStr )
        let length = LCDataLength( lcStr )
        
        // 書き込みの確認
        XCTAssertTrue( LCFileWriterWrite( writer, bin!, length ) )
        LCFileWriterEnd( writer )
        
        // 書き込んだものの読み込み
        let reader = LCFileReaderMake( path )
        let read_length = LCFileGetSize( path )
        let read_data = LCDataMakeWithSize( read_length )
        let read_bin = LCDataPointer( read_data )
        LCFileReaderRead( reader, read_bin!, read_length )
        LCFileReaderEnd( reader )
        
        let result = LCStringMakeWithBytes( read_bin!, read_length.i! )
        
        // 書き込んだ文字列と読み込んだ文字列が一致するかを確認
        XCTAssertEqual( String( result ), str )
        
        // 後片付け
        LCFileRemove( path )
    }
    
    func test_writeChars() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        let str = "ご機嫌麗しゅう、ご壮健で何よりです."
        
        // テスト前の削除
        LCFileRemove( path )
        
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        let lcStr = str.lcStr
        let cchars = LCStringToCChars( lcStr )
        // FIXME: アンチパターン
        // XCTAssertTrue( LCFileWriterWriteChars( writer, LCStringToCChars( str.lcStr ) ) )
        // ↑この方法だとstr.lcStrで「新たに確保されたメモリ」が関数スコープへ移ったと時に参照解放されてNGになる。
        // 一度別の変数に保存しておけばlcStrは残るためこれを用いる
        
        // 書き込みの確認
        XCTAssertTrue( LCFileWriterWriteChars( writer, cchars ) )
        LCFileWriterEnd( writer )
        
        // 書き込んだものの読み込み
        let reader = LCFileReaderMake( path )
        let read_length = LCFileGetSize( path )
        let read_data = LCDataMakeWithSize( read_length )
        let read_bin = LCDataPointer( read_data )
        LCFileReaderRead( reader, read_bin!, read_length )
        LCFileReaderEnd( reader )
        
        let result = LCStringMakeWithBytes( read_bin!, read_length.i! )
        
        // 書き込んだ文字列と読み込んだ文字列が一致するかを確認
        XCTAssertEqual( String( result ), str )
        
        // 後片付け
        LCFileRemove( path )
    }
    
    func test_writeText() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        let str = "LCStringSmPtrのテキストを直接流し込むこともできます."
        
        // テスト前の削除
        LCFileRemove( path )
        
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        let lcStr = str.lcStr        
        // 書き込みの確認
        XCTAssertTrue( LCFileWriterWriteText( writer, lcStr ) )
        LCFileWriterEnd( writer )
        
        // 書き込んだものの読み込み
        let reader = LCFileReaderMake( path )
        let read_length = LCFileGetSize( path )
        let read_data = LCDataMakeWithSize( read_length )
        let read_bin = LCDataPointer( read_data )
        LCFileReaderRead( reader, read_bin!, read_length )
        LCFileReaderEnd( reader )
        
        let result = LCStringMakeWithBytes( read_bin!, read_length.i! )
        
        // 書き込んだ文字列と読み込んだ文字列が一致するかを確認
        XCTAssertEqual( String( result ), str )
        
        // 後片付け
        LCFileRemove( path )
    }
    
    func test_end() {
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        // テスト前の削除
        LCFileRemove( path )
    
        // 一時フォルダにダミーファイルの作成
        let writer = LCFileWriterMake( path, false )
        // アクティブの確認
        XCTAssertTrue( LCFileWriterIsActive( writer ) )
        // 終了の確認
        XCTAssertTrue( LCFileWriterEnd( writer ) )
        // 非アクティブの確認
        XCTAssertFalse( LCFileWriterIsActive( writer ) )
        // 後片付け
        LCFileRemove( path )
    }
}
