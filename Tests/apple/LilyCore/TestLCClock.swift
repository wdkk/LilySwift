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

class TestLCClock : XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_init() {
        LCClockInit()
    }
    
    func test_now() {
        // 時間が取れているかを取得
        XCTAssertTrue( 0 < LCClockNow() )
    }
    
    func test_fps() {
        LCClockFPS()
    }
}
