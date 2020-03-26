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

class TestLLMath_macro: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_min() {
        let v1 = 123
        let v2 = 124
        XCTAssertEqual( LLMin( v1, v2 ), v1 )
    }
    
    func test_max() {
        let v1 = 123
        let v2 = 124
        XCTAssertEqual( LLMax( v1, v2 ), v2 )
    }
    
    func test_within() {
        let minv = 100
        let maxv = 200
        let v1 = 150
        let v2 = 80
        let v3 = 208
        
        XCTAssertEqual( LLWithin( min:minv, v1, max:maxv ), v1 )
        XCTAssertEqual( LLWithin( min:minv, v2, max:maxv ), minv )
        XCTAssertEqual( LLWithin( min:minv, v3, max:maxv ), maxv )
    }
    
    func test_swap() {
        var v1 = 150
        var v2 = 80
        
        LLSwap( &v1, &v2 )
        XCTAssertEqual( v1, 80 )
        XCTAssertEqual( v2, 150 )
    }
}
