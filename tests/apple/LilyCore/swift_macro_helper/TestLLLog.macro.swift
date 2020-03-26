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

class TestLLLog_macro: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_log() {
        let tmp = 123
        LLLog( "ログ出力テストです.tmp = \(tmp)" )
    }
    
    func test_logForce() {
        let tmp = 123
        
        LLLogSetEnableType( .all )
        LLLogForce( "強いログ出力テストです1.tmp = \(tmp)" )
        XCTAssertTrue( LLLogForceEnabled() )
        
        LLLogSetEnableType( .force )
        LLLogForce( "強いログ出力テストです2.tmp = \(tmp)" )
        XCTAssertTrue( LLLogForceEnabled() )
        
        LLLogSetEnableType( .warning )
        LLLogForce( "出てはいけない強いログです1.tmp = \(tmp)" )
        XCTAssertFalse( LLLogForceEnabled() )
        
        LLLogSetEnableType( .none )
        LLLogForce( "出てはいけない強いログです2.tmp = \(tmp)" )
        XCTAssertFalse( LLLogForceEnabled() )
    }
    
    func test_logWarning() {
        let tmp = 123
        
        LLLogSetEnableType( .all )
        LLLogWarning( "警告ログ出力テストです1.tmp = \(tmp)" )
        XCTAssertTrue( LLLogWarningEnabled() )
        
        LLLogSetEnableType( .warning )
        LLLogWarning( "強いログ出力テストです2.tmp = \(tmp)" )
        XCTAssertTrue( LLLogWarningEnabled() )
        
        LLLogSetEnableType( .force )
        LLLogWarning( "出てはいけない警告ログです1.tmp = \(tmp)" )
        XCTAssertFalse( LLLogWarningEnabled() )
        
        LLLogSetEnableType( .none )
        LLLogWarning( "出てはいけない警告ログです2.tmp = \(tmp)" )
        XCTAssertFalse( LLLogWarningEnabled() )
    }
    
}
