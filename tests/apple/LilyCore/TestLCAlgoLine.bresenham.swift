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

class TestLCAlgoLine_bresenham: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_init() {
        let line = LCAlgoLineBresenhamMake()
        XCTAssertNotNil( line )
    }
    
    func test_start() {
        let line = LCAlgoLineBresenhamMake()
        let pt = LLPointMake( 50.0, 100.0 )
        LCAlgoLineBresenhamStart( line, pt, 1.2 )
        // 現在位置の確認
        let step = LCAlgoLineBresenhamNow( line )
        XCTAssertEqual( step.pt.x, 50.0 )
        XCTAssertEqual( step.pt.y, 100.0 )
        // 次をターゲットしていないのでStopped = true
        XCTAssertTrue( LCAlgoLineBresenhamIsStopped( line ) )
    }
    
    func test_retarget() {
        let line = LCAlgoLineBresenhamMake()
        // 初期点と初期スパン
        let pt1 = LLPointMake( 50.0, 100.0 )
        LCAlgoLineBresenhamStart( line, pt1, 1.2 )

        // 次の点と変化後スパン(線形に変化していく)
        let pt2 = LLPointMake( 120.0, 200.0 )
        LCAlgoLineBresenhamRetarget( line, pt2, 3.8 )
        
        // 次をターゲットしたのでStopped = false
        XCTAssertFalse( LCAlgoLineBresenhamIsStopped( line ) )
        
        var prev_step = LCAlgoLineBresenhamNow( line )
        var now_step = LCAlgoLineBresenhamNow( line )

        // ステップのチェック
        while !LCAlgoLineBresenhamIsStopped( line ) {
            // 次のポイント種t区
            now_step = LCAlgoLineBresenhamNext( line )
            // 移動距離を取得
            let dx = (now_step.pt.x - prev_step.pt.x)
            let dy = (now_step.pt.y - prev_step.pt.y)
            let dx2 = dx * dx
            let dy2 = dy * dy
            let dist = sqrt( dx2 + dy2 )
            //print( "\(dist), \(now_step.span)" )
            //print( dist.withinRange( of:now_step.span, plus_or_minus:0.01 ) )
            print( "\(now_step.pt.x),\(now_step.pt.y)")
            // 移動距離がスパンの誤差範囲であるか確認(ただし初期点はdist = 0になるので除外)
            if( 0.0 < dist ) {
                XCTAssertTrue( dist.withinRange( of:now_step.span, plus_or_minus:0.01 ) )
            }
            // 前回の点を更新
            prev_step = now_step
        }
    }
    
}
