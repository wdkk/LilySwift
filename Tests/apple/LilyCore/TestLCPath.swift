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

class TestLCPath: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_getLaunching() {
        // Catalyst: /Users/ユーザ名/
        // Simulator: /Users/ユーザ名/Library/Developer/CoreSimulator/Devices/ランダム文字列/data/
        // Device: Simulatorで代用
        // macOS: */Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/
        
        let path = LCPathGetLaunching( LCStringZero() )
        #if targetEnvironment(macCatalyst)
        let check_path = LCStringMakeWithCChars( "/Users/*/" )
        #elseif targetEnvironment(simulator)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Developer/CoreSimulator/Devices/*/data/" )
        #elseif os(macOS)
        let check_path = LCStringMakeWithCChars( "*/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/" )
        #endif

        // マッチフィルタを使って適切なフォルダが取れているか確認
        XCTAssertTrue( LCPathIsMatchFilter( path, check_path ) )
    }
    
    func test_getBundle() {
        // Catalyst: */Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/Agents/Contents/Resources/
        // Simulator: */Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Agents/
        // Device: Simulatorで代用
        // macOS: */Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/Agents/
        
        let path = LCPathGetBundle( LCStringZero() )
        #if targetEnvironment(macCatalyst)
        let check_path = LCStringMakeWithCChars( "*/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/Agents/Contents/Resources/" )
        #elseif targetEnvironment(simulator)
        let check_path = LCStringMakeWithCChars( "*/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/Library/Xcode/Agents/" )
        #elseif os(macOS)
        let check_path = LCStringMakeWithCChars( "*/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Xcode/Agents/" )
        #endif

        // マッチフィルタを使って適切なフォルダが取れているか確認
        XCTAssertTrue( LCPathIsMatchFilter( path, check_path ) )
    }
    
    func test_getDocuments() {
        // Catalyst: /Users/ユーザ名/Documents/
        // Simulator: /Users/ユーザ名/Library/Developer/CoreSimulator/Devices/ランダム文字列/data/Documents/
        // Device: Simulatorで代用
        // macOS: /Users/ユーザ名/Documents/
        
        let path = LCPathGetDocuments( LCStringZero() )
        #if targetEnvironment(macCatalyst)
        let check_path = LCStringMakeWithCChars( "/Users/*/Documents/" )
        #elseif targetEnvironment(simulator)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Developer/CoreSimulator/Devices/*/data/Documents/" )
        #elseif os(macOS)
        let check_path = LCStringMakeWithCChars( "/Users/*/Documents/" )
        #endif

        // マッチフィルタを使って適切なフォルダが取れているか確認
        XCTAssertTrue( LCPathIsMatchFilter( path, check_path ) )
    }
    
    func test_getTemp() {
        // Catalyst: /Users/ユーザ名/tmp/
        // Simulator: /Users/ユーザ名/Library/Developer/CoreSimulator/Devices/ランダム文字列/data/tmp/
        // Device: Simulatorで代用
        // macOS: /var/folders/ランダム文字列/ランダム文字列/T/
        
        let path = LCPathGetTemp( LCStringZero() )
        #if targetEnvironment(macCatalyst)
        let check_path = LCStringMakeWithCChars( "/Users/*/tmp/" )
        #elseif targetEnvironment(simulator)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Developer/CoreSimulator/Devices/*/data/tmp/" )
        #elseif os(macOS)
        let check_path = LCStringMakeWithCChars( "/var/folders/*/*/T/" )
        #endif

        // マッチフィルタを使って適切なフォルダが取れているか確認
        XCTAssertTrue( LCPathIsMatchFilter( path, check_path ) )
    }
    
    func test_getCache() {
        // Catalyst: /Users/ユーザ名/Library/Caches/
        // Simulator: /Users/ユーザ名/Library/Developer/CoreSimulator/Devices/ランダム文字列/data/Library/Caches/
        // Device: Simulatorで代用
        // macOS: /Users/ユーザ名/Library/Caches/
        
        let path = LCPathGetCache( LCStringZero() )
        #if targetEnvironment(macCatalyst)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Caches/" )
        #elseif targetEnvironment(simulator)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Developer/CoreSimulator/Devices/*/data/Library/Caches/" )
        #elseif os(macOS)
        let check_path = LCStringMakeWithCChars( "/Users/*/Library/Caches/" )
        #endif

        // マッチフィルタを使って適切なフォルダが取れているか確認
        XCTAssertTrue( LCPathIsMatchFilter( path, check_path ) )
    }
    
    func test_pickFilename() {
        let path = LCStringMakeWithCChars( "/User/hoge/Desktop/abc.jpg" )
        let result = LCStringMakeWithCChars( "abc" )
        
        XCTAssertEqual( String( LCPathPickFilename( path ) ), String( result ) )
    }
    
    func test_pickFilenameFull() {
        let path = LCStringMakeWithCChars( "/User/hoge/Desktop/abc.jpg" )
        let result = LCStringMakeWithCChars( "abc.jpg" )
        
        XCTAssertEqual( String( LCPathPickFilenameFull( path ) ), String( result ) )
    }
    
    func test_pickExtension() {
        let path = LCStringMakeWithCChars( "/User/hoge/Desktop/abc.jpg" )
        let result = LCStringMakeWithCChars( "jpg" )
        
        XCTAssertEqual( String( LCPathPickExtension( path ) ), String( result ) )
    }
    
    func test_enumrateFiles() {
        // バンドルしたファイルを一覧する(XCTestのパッケージ内の一覧)
        let path = Bundle(for:TestLCPath.self).bundlePath + "/Contents/Resources/supportFiles/images/"
        
        let results1 = LCPathEnumerateFiles( path.lcStr, LCStringArrayMake() )
        
        var checks1 = [ 
            "bit16.png",
            "lena.jpg",
            "lena.png",
            "bit8alpha.tga",
            "bit8alpha.png",
            "LilyNoAlpha.png",
            "bit8.gif",
            "bit8lzw.tif",
            "Lily.bmp",
            "test1.jpg",
            "test1.png",
            "lenaalpha.png",
            "lena647x681.png",
            "Lily359x257.png",
            "bit16alpha.png",
            "lena.bmp",
            "bit8.tif",
            "Lily.png",
            "Lily.jpg",
            "bit8.tga",
            "bit8.jpg",
            "bit8.png",
            "test16alpha.png"
        ]
        
        // チェック個数と取得個数が一致するか確認
        XCTAssertEqual( LCStringArrayCount( results1 ), checks1.count )
        
        for i in 0 ..< LCStringArrayCount( results1 ) {
            let fn = String( LCStringArrayAt( results1, i ) )
            for j in 0 ..< checks1.count {
                // 一致したものを一覧から削除
                if fn == checks1[j] { checks1.remove( at: j ); break }
            }
        }
    
        // チェック欄がなくなっているか確認
        XCTAssertTrue( checks1.count == 0 )
        
        // フィルタのチェック
        let filters = LCStringArrayMake()
        LCStringArrayAppend( filters, LCStringMakeWithCChars( "*.png" ) )
        let results2 = LCPathEnumerateFiles( path.lcStr, filters )
        
        var checks2 = [ 
            "bit16.png",
            "lena.png",
            "bit8alpha.png",
            "LilyNoAlpha.png",
            "test1.png",
            "lenaalpha.png",
            "lena647x681.png",
            "Lily359x257.png",
            "bit16alpha.png",
            "Lily.png",
            "bit8.png",
            "test16alpha.png"
        ]
        
        // チェック個数と取得個数が一致するか確認
        XCTAssertEqual( LCStringArrayCount( results2 ), checks2.count )
        
        for i in 0 ..< LCStringArrayCount( results2 ) {
            let fn = String( LCStringArrayAt( results2, i ) )
            for j in 0 ..< checks2.count {
                // 一致したものを一覧から削除
                if fn == checks2[j] { checks2.remove( at: j ); break }
            }
        }
    
        // チェック欄がなくなっているか確認
        XCTAssertTrue( checks2.count == 0 )
    }

    func test_enumrateDirectories() {
          // バンドルしたファイルを一覧する(XCTestのパッケージ内の一覧)
          let path = Bundle(for:TestLCPath.self).bundlePath + "/Contents/Resources/supportFiles/"
          
          let results1 = LCPathEnumerateDirectories( path.lcStr )
          
          var checks1 = [ 
              "images",
              "text"
          ]
          
          // チェック個数と取得個数が一致するか確認
          XCTAssertEqual( LCStringArrayCount( results1 ), checks1.count )
          
          for i in 0 ..< LCStringArrayCount( results1 ) {
              let fn = String( LCStringArrayAt( results1, i ) )
              for j in 0 ..< checks1.count {
                  // 一致したものを一覧から削除
                  if fn == checks1[j] { checks1.remove( at: j ); break }
              }
          }
    
          // チェック欄がなくなっているか確認
          XCTAssertTrue( checks1.count == 0 )
    }
    
    func test_matchFilter() {
        let path1 = LCStringMakeWithCChars( "/User/wdkk/Desktop/abc.jpg" )
        let filter0 = LCStringMakeWithCChars( "Desktop/*.jpg" )
        let filter1 = LCStringMakeWithCChars( "*/Desktop/*.jpg" )
        let filter2 = LCStringMakeWithCChars( "*.*" )
        let filter3 = LCStringMakeWithCChars( "*.png" )
        
        // ワイルドカードの妥当性のチェック
        XCTAssertFalse( LCPathIsMatchFilter( path1, filter0 ) )
        XCTAssertTrue( LCPathIsMatchFilter( path1, filter1 ) )
        XCTAssertTrue( LCPathIsMatchFilter( path1, filter2 ) )
        XCTAssertFalse( LCPathIsMatchFilter( path1, filter3 ) )
    }
}
