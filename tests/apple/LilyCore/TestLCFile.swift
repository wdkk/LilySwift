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

class TestLCFile: XCTestCase {

    #if targetEnvironment(macCatalyst)
    let test_bundle_path = Bundle(for:TestLCFile.self).bundlePath + "/Contents/Resources/"
    #elseif targetEnvironment(simulator)
    let test_bundle_path = Bundle(for:TestLCFile.self).bundlePath + "/"
    #elseif os(macOS)
    let test_bundle_path = Bundle(for:TestLCFile.self).bundlePath + "/Contents/Resources/"
    #endif
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_exist() {
        let path = test_bundle_path + "supportFiles/text/"
        
        // ファイルの存在チェック
        let exists = LCFileExists( ( path + "japanese_hello.txt" ).lcStr )
        XCTAssertTrue( exists )
        // ファイルの非存在チェック
        let no_exists = LCFileExists( ( path + "no_file.dat" ).lcStr )
        XCTAssertFalse( no_exists )
    }  
    
    func test_isDirectory() {
        let path = test_bundle_path + "supportFiles/text/"
        
        // ディレクトリチェック = true
        let dir = LCFileIsDirectory( path.lcStr )
        XCTAssertTrue( dir )
        // ファイルを指定 = false
        let no_dir = LCFileIsDirectory( ( path + "japanese_hello.txt" ).lcStr )
        XCTAssertFalse( no_dir )
        // ディレクトリ非存在 = false
        let no_exist_dir = LCFileIsDirectory( ( path + "dummy/").lcStr )
        XCTAssertFalse( no_exist_dir )        
    }  
    
    func test_getSize() {
        let path = test_bundle_path + "supportFiles/text/"
        
        // ファイルサイズ取得
        let size = LCFileGetSize( ( path + "japanese_hello.txt" ).lcStr )
        XCTAssertEqual( size, 42 )        
    }
    
    func test_remove() {
        // 一時フォルダにダミーファイルの作成
        let path = LCPathGetTemp( "dummy.dat".lcStr )
        let writer = LCFileWriterMake( path, false )
        XCTAssertTrue( LCFileWriterIsActive( writer ) )
        LCFileWriterWriteText( writer, "monimoni".lcStr )
        LCFileWriterEnd( writer )
        
        // ファイルを削除
        let result = LCFileRemove( path )
        // ファイル削除したか確認
        XCTAssertTrue( result )
        // ファイルがちゃんと消されているか確認
        XCTAssertFalse( LCFileExists( path ) )
    }
    
    func test_move() {
        // 一時フォルダにダミーファイルの作成
        let from_path = LCPathGetTemp( "dummy_move.dat".lcStr )
        let to_path = LCPathGetTemp( "moved.dat".lcStr )

        // テスト用クリア
        LCFileRemove( from_path )
        LCFileRemove( to_path )
        
        let writer = LCFileWriterMake( from_path, false )
        XCTAssertTrue( LCFileWriterIsActive( writer ) )
        LCFileWriterWriteText( writer, "monimoni".lcStr )
        LCFileWriterEnd( writer )

        // ファイルを移動
        let result = LCFileMove( from_path, to_path )
        // ファイルを移動したかを確認
        XCTAssertTrue( result )
        // ファイルがちゃんと移動しているか古いパスを確認
        XCTAssertFalse( LCFileExists( from_path ) )
        // ファイルがちゃんと移動しているか新しいパスを確認
        XCTAssertTrue( LCFileExists( to_path ) )
        // 移動後のファイルを削除
        XCTAssertTrue( LCFileRemove( to_path ) )
    }
    
    func test_copy() {
        // 一時フォルダにダミーファイルの作成
        let from_path = LCPathGetTemp( "dummy_move.dat".lcStr )
        let to_path = LCPathGetTemp( "moved.dat".lcStr )
       
        // テスト用クリア
        LCFileRemove( from_path )
        LCFileRemove( to_path )
        
        let writer = LCFileWriterMake( from_path, false )
        XCTAssertTrue( LCFileWriterIsActive( writer ) )
        LCFileWriterWriteText( writer, "monimoni".lcStr )
        LCFileWriterEnd( writer )
        
        // ファイルを移動
        let result = LCFileCopy( from_path, to_path )
        // ファイルを移動したかを確認
        XCTAssertTrue( result )
        // 古いパスの存在を確認
        XCTAssertTrue( LCFileExists( from_path ) )
        // 新しいパスの存在を確認
        XCTAssertTrue( LCFileExists( to_path ) )
        // コピー前のファイルを削除
        XCTAssertTrue( LCFileRemove( from_path ) )
        // コピー後のファイルを削除
        XCTAssertTrue( LCFileRemove( to_path ) )
    }
    
    func test_create_and_removeDirectory() {
        // 一時フォルダにダミーで入れクトリの作成
        let dir_path = LCPathGetTemp( "dummy/".lcStr )
        
        // テスト用クリア
        LCFileRemoveDirectory( dir_path )
        
        // ディレクトリ作成を確認
        XCTAssertTrue( LCFileCreateDirectory( dir_path ) )
        // ディレクトリ存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_path ) )
        // ディレクトリの削除
        XCTAssertTrue( LCFileRemoveDirectory( dir_path ) )
        // ディレクトリ非存在を確認
        XCTAssertFalse( LCFileIsDirectory( dir_path ) )
    }
    
    func test_moveDirectory() {
        // 一時フォルダにダミーで入れクトリの作成
        let dir_from_path = LCPathGetTemp( "dummy/".lcStr )
        let dir_to_path = LCPathGetTemp( "monimoni/".lcStr )
    
        // テスト用クリア
        LCFileRemoveDirectory( dir_from_path )
        LCFileRemoveDirectory( dir_to_path )
        
        // ディレクトリ作成を確認
        XCTAssertTrue( LCFileCreateDirectory( dir_from_path ) )
        // ディレクトリ存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_from_path ) )
        // ディレクトリ移動を確認
        XCTAssertTrue( LCFileMoveDirectory( dir_from_path, dir_to_path ) )
        // 新しいディレクトリ存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_to_path ) )  
        // 古いディレクトリ非存在を確認
        XCTAssertFalse( LCFileIsDirectory( dir_from_path ) )  
        // 新しいディレクトリを削除
        XCTAssertTrue( LCFileRemoveDirectory( dir_to_path ) )
        // 新しいディレクトリの非存在を確認
        XCTAssertFalse( LCFileIsDirectory( dir_to_path ) ) 
    }
    
    func test_copyDirectory() {
        // 一時フォルダにダミーで入れクトリの作成
        let dir_from_path = LCPathGetTemp( "dummy/".lcStr )
        let dir_to_path = LCPathGetTemp( "monimoni/".lcStr )
        
        // テスト用クリア
        LCFileRemoveDirectory( dir_from_path )
        LCFileRemoveDirectory( dir_to_path )
        
        // ディレクトリ作成を確認
        XCTAssertTrue( LCFileCreateDirectory( dir_from_path ) )
        // ディレクトリ存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_from_path ) )
        // ディレクトリ移動を確認
        XCTAssertTrue( LCFileCopyDirectory( dir_from_path, dir_to_path ) )
        // 新しいディレクトリの存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_to_path ) )  
        // 古いディレクトリの存在を確認
        XCTAssertTrue( LCFileIsDirectory( dir_from_path ) )  
        // 新しいディレクトリを削除
        XCTAssertTrue( LCFileRemoveDirectory( dir_to_path ) )
        // 古いディレクトリを削除
        XCTAssertTrue( LCFileRemoveDirectory( dir_from_path ) )
        // 新しいディレクトリの非存在を確認
        XCTAssertFalse( LCFileIsDirectory( dir_to_path ) ) 
        // 新しいディレクトリの非存在を確認
        XCTAssertFalse( LCFileIsDirectory( dir_from_path ) )
    }
}
