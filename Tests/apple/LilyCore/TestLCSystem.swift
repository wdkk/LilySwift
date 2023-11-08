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

class TestLCSystem: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_init() {
        LCSystemInit()
    }
    
    func test_getFreeMemory() {
        XCTAssertGreaterThan( LCSystemGetFreeMemory(), 0.0 )
    }
    
    func test_getFreeStorage() {
        XCTAssertGreaterThan( LCSystemGetFreeStorage( "/" ), 0.0 )
    }
    
    func test_getRetinaScale() {
        XCTAssertGreaterThan( LCSystemGetRetinaScale(), 0.0 )
    }
    
    func test_getDpiScale() {
        XCTAssertGreaterThan( LCSystemGetDpiScale().width, 0.0 )
        XCTAssertGreaterThan( LCSystemGetDpiScale().height, 0.0 )
    }
    
    func test_sleep() {
        LCSystemSleep( 100 )
    }
    
    func test_wait() {
        LCSystemWait( 100 )
    }
}
