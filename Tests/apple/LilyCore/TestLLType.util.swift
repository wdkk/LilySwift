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

class TestLLType_util: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_pointZero() {
        let pt = LLPointZero()
        XCTAssertEqual( pt.x, 0.0 )
        XCTAssertEqual( pt.y, 0.0 )
    }
    
    func test_pointMake() {
        let pt = LLPointMake( 123.0, 456.0 )
        XCTAssertEqual( pt.x, 123.0 )
        XCTAssertEqual( pt.y, 456.0 )
    }
    
    func test_pointIntZero() {
        let pt = LLPointIntZero()
        XCTAssertEqual( pt.x, 0 )
        XCTAssertEqual( pt.y, 0 )
    }
    
    func test_pointIntMake() {
        let pt = LLPointIntMake( 123, 456 )
        XCTAssertEqual( pt.x, 123 )
        XCTAssertEqual( pt.y, 456 )
    }
    
    func test_coordZero() {
        XCTAssertEqual( LLCoordZero().x, 0.0 )
        XCTAssertEqual( LLCoordZero().y, 0.0 )
        XCTAssertEqual( LLCoordZero().z, 0.0 )
    }
    
    func test_coordMake() {
        let coord = LLCoordMake( 123.0, 456.0, 789.0 )
        XCTAssertEqual( coord.x, 123 )
        XCTAssertEqual( coord.y, 456 )
        XCTAssertEqual( coord.z, 789 )
    }
    
    func test_sizeZero() {
        let sz = LLSizeZero()
        XCTAssertEqual( sz.width, 0.0 )
        XCTAssertEqual( sz.height, 0.0 )
    }
    
    func test_sizeMake() {
        let pt = LLSizeMake( 123.0, 456.0 )
        XCTAssertEqual( pt.width, 123.0 )
        XCTAssertEqual( pt.height, 456.0 )
    }
    
    func test_rectZero() {
        let rc = LLRectZero()
        XCTAssertEqual( rc.x, 0.0 )
        XCTAssertEqual( rc.y, 0.0 )
        XCTAssertEqual( rc.width, 0.0 )
        XCTAssertEqual( rc.height, 0.0 )
    }
    
    func test_rectMake() {
        let rc = LLRectMake( 50, 100, 150, 200 )
        XCTAssertEqual( rc.x, 50 )
        XCTAssertEqual( rc.y, 100 )
        XCTAssertEqual( rc.width, 150 )
        XCTAssertEqual( rc.height, 200 )
    }
    
    func test_rectInset() {
        let rc = LLRectMake( 50, 100, 150, 200 )
        let rc_inset = LLRectInset( rc, 12.3 )
        XCTAssertEqual( rc_inset.x, 62.3 )
        XCTAssertEqual( rc_inset.y, 112.3 )
        XCTAssertEqual( rc_inset.width, 150.0 - 12.3 * 2.0 )
        XCTAssertEqual( rc_inset.height, 200.0 - 12.3 * 2.0 )
    }
    
    func test_regionZero() {
        let rc = LLRegionZero()
        XCTAssertEqual( rc.left, 0.0 )
        XCTAssertEqual( rc.top, 0.0 )
        XCTAssertEqual( rc.right, 0.0 )
        XCTAssertEqual( rc.bottom, 0.0 )
    }
    
    func test_regionMake() {
        let rc = LLRegionMake( 20, 50, 110, 170 )
        XCTAssertEqual( rc.left, 20.0 )
        XCTAssertEqual( rc.top, 50.0 )
        XCTAssertEqual( rc.right, 110.0 )
        XCTAssertEqual( rc.bottom, 170.0 )
    }
    
    func test_regionAnd() {
        let rc1 = LLRegionMake( 20, 50, 110, 170 )
        let rc2 = LLRegionMake( 60, 30, 90, 200 )
        let rc3 = LLRegionAnd( rc1, rc2 )
        XCTAssertEqual( rc3.left, 60.0 )
        XCTAssertEqual( rc3.top, 50.0 )
        XCTAssertEqual( rc3.right, 90.0 )
        XCTAssertEqual( rc3.bottom, 170.0 )
    }
    
    func test_regionOr() {
        let rc1 = LLRegionMake( 20, 50, 110, 170 )
        let rc2 = LLRegionMake( 60, 30, 90, 200 )
        let rc3 = LLRegionOr( rc1, rc2 )
        XCTAssertEqual( rc3.left, 20.0 )
        XCTAssertEqual( rc3.top, 30.0 )
        XCTAssertEqual( rc3.right, 110.0 )
        XCTAssertEqual( rc3.bottom, 200.0 )
    }
    
    func test_regionExpand() {
        let rc = LLRegionMake( 20, 50, 110, 170 )
        let rc_expand = LLRegionExpand( rc, 15.3 )
        XCTAssertEqual( rc_expand.left, 20.0 - 15.3 )
        XCTAssertEqual( rc_expand.top, 50.0 - 15.3 )
        XCTAssertEqual( rc_expand.right, 110.0 + 15.3 )
        XCTAssertEqual( rc_expand.bottom, 170.0 + 15.3 )
    }
    
    func test_charByteLength() {
        let length0 = LLCharByteLength( "a" )
        XCTAssertEqual( length0, 1 )
        
        let length1 = LLCharByteLength( "あ" )
        XCTAssertEqual( length1, 3 )
        
        let length2 = LLCharByteLength( "こんにちわ" )
        XCTAssertEqual( length2, 15 )
        
        let length3 = LLCharByteLength( "こんにちわ、良い天気ですね。" )
        XCTAssertEqual( length3, 42 )
        
        let length4 = LLCharByteLength( "Lilyは15年寝かせてきたLibraryです" )
        XCTAssertEqual( length4, 43 )
    }
    
    func test_charUTF8Count() {
        let length0 = LLCharUTF8Count( "a" )
        XCTAssertEqual( length0, 1 )
        
        let length1 = LLCharUTF8Count( "あ" )
        XCTAssertEqual( length1, 1 )
        
        let length2 = LLCharUTF8Count( "こんにちわ" )
        XCTAssertEqual( length2, 5 )
        
        let length3 = LLCharUTF8Count( "こんにちわ、良い天気ですね。" )
        XCTAssertEqual( length3, 14 )
    
        let length4 = LLCharUTF8Count( "Lilyは15年寝かせてきたLibraryです" )
        XCTAssertEqual( length4, 23 )
    }
}
