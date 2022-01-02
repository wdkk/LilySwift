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

class TestLCAlignedMemory: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_allocate_memory166() {
        let memory = LCAlignedMemory16Make()
        
        LCAlignedMemory16Resize( memory, 100 )
       
        XCTAssertEqual( LCAlignedMemory16Length( memory ), 100 )
        XCTAssertEqual( LCAlignedMemory16AllocatedLength( memory ), 112 )
    }
    
    func test_allocate_memory4096() {
        let memory = LCAlignedMemory4096Make()
        
        LCAlignedMemory4096Resize( memory, 100 )
       
        XCTAssertEqual( LCAlignedMemory4096Length( memory ), 100 )
        XCTAssertEqual( LCAlignedMemory4096AllocatedLength( memory ), 4096 )
    }
}
