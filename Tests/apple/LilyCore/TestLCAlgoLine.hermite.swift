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

class TestLCAlgoLine_hermite: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_init() {
        let line = LCAlgoLineHermiteMake()
        XCTAssertNotNil( line )
    }
    
    func test_start() {
        let line = LCAlgoLineHermiteMake()
        let pt = LLPointMake( 50.0, 100.0 )
        LCAlgoLineHermiteStart( line, pt, 1.2 )
        // 現在位置の確認
        let step = LCAlgoLineHermiteNow( line )
        XCTAssertEqual( step.pt.x, 50.0 )
        XCTAssertEqual( step.pt.y, 100.0 )
        // 次をターゲットしていないのでStopped = true
        XCTAssertTrue( LCAlgoLineHermiteIsStopped( line ) )
    }
    
    func test_retarget() {
        let line = LCAlgoLineHermiteMake()
        // 初期点と初期スパン
        let pt1 = LLPointMake( 50.0, 100.0 )
        LCAlgoLineHermiteStart( line, pt1, 1.2 )

        // 次の点と変化後スパン(線形に変化していく)
        let pt2 = LLPointMake( 120.0, 200.0 )
        LCAlgoLineHermiteRetarget( line, pt2, 3.8 )
        
        // 次をターゲットしたのでStopped = false
        XCTAssertFalse( LCAlgoLineHermiteIsStopped( line ) )
        
        var prev_step = LCAlgoLineHermiteNow( line )
        var now_step = LCAlgoLineHermiteNow( line )

        // ステップのチェック
        while !LCAlgoLineHermiteIsStopped( line ) {
            // 次のポイント種t区
            now_step = LCAlgoLineHermiteNext( line )
            // 移動距離を取得
            let dx = (now_step.pt.x - prev_step.pt.x)
            let dy = (now_step.pt.y - prev_step.pt.y)
            let dx2 = dx * dx
            let dy2 = dy * dy
            let dist = sqrt( dx2 + dy2 )
            //print( "\(dist), \(prev_step.span)" )
            //print( dist.withinRange( of:now_step.span, plus_or_minus:0.25 ) )
            print( "\(now_step.pt.x),\(now_step.pt.y)")
            // 移動距離がスパンの誤差範囲であるか確認(ただし初期点はdist = 0になるので除外)
             // エルミートは積分値で近似のステップ距離を取るため、二乗距離より長くなるため0.25のズレを許容した. spanが大きいとさらにズレは広がる
            if( 0.0 < dist ) {
                XCTAssertTrue( dist.withinRange( of:now_step.span, plus_or_minus:0.1 ) )
            }
            
            // 前回の点を更新
            prev_step = now_step
        }
    }
    
}
