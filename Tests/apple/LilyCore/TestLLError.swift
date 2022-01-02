//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import XCTest

@testable import LilySwift

class TestLLError: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        let err = LLErrorMake()
        XCTAssertEqual( LLErrorCode( err ), 0 )
        XCTAssertTrue( LCStringIsEqual( LLErrorDescription( err ), LCStringZero() ) )
    }
    
    func test_NONE() {
        let err = LLErrorMake()
        LLErrorNone( err )
        XCTAssertEqual( LLErrorCode( err ), 0 )
        XCTAssertTrue( LCStringIsEqual( LLErrorDescription( err ), LCStringZero() ) )
    }
    
    func test_set() {
        let err = LLErrorMake()
        LLErrorSet( err, 1, "エラーを発生させました" )
        
        XCTAssertEqual( LLErrorCode( err ), 1 )
        XCTAssertEqual( String( LLErrorDescription( err ) ), "エラーを発生させました" )
    }
    
    // LLErrorCodeとLLErrorDescriptionは上のテストで同時に用いるため省略
}
