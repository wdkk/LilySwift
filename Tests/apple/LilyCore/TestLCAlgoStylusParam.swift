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

class TestLCAlgoStylusParam : XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_init() {
        let line = LCAlgoLineHermiteMake()
        XCTAssertNotNil( line )
        
        let param = LCAlgoStylusParamMake()
        XCTAssertNotNil( param )
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

        let stylus_param = LCAlgoStylusParamMake()
        XCTAssertNotNil( stylus_param )
        
        var param_step = LLAlgoStylusParamStep()
        param_step.force = 0.0
        param_step.azimuth_angle = 0.0
        param_step.azimuth_vec_x = 0.0
        param_step.azimuth_vec_y = 0.0
        param_step.altitude = 0.0        
        
        LCAlgoStylusParamStart( stylus_param, param_step )
    }
    
    func test_retarget() {
        let line = LCAlgoLineHermiteMake()
        // 初期点と初期スパン
        let pt1 = LLPointMake( 50.0, 100.0 )
        LCAlgoLineHermiteStart( line, pt1, 1.2 )

        // 次の点と変化後スパン(線形に変化していく)
        let pt2 = LLPointMake( 240.0, 490.0 )
        LCAlgoLineHermiteRetarget( line, pt2, 3.8 )
        
        // 次をターゲットしたのでStopped = false
        XCTAssertFalse( LCAlgoLineHermiteIsStopped( line ) )
        
        var now_step = LCAlgoLineHermiteNow( line )
        
        // スタイラスパラメータの作成        
        let stylus_param = LCAlgoStylusParamMake()
        XCTAssertNotNil( stylus_param )
        // 初期パラメータの作成
        var param_step1 = LLAlgoStylusParamStep()
        param_step1.force = 0.0
        param_step1.azimuth_angle = 0.0
        param_step1.azimuth_vec_x = 0.0
        param_step1.azimuth_vec_y = 0.0
        param_step1.altitude = 0.0        
        // 初期パラメータの指定
        LCAlgoStylusParamStart( stylus_param, param_step1 )
        // 次のパラメータの作成
        var param_step2 = LLAlgoStylusParamStep()
        param_step2.force = 1.0
        param_step2.azimuth_angle = 2.0
        param_step2.azimuth_vec_x = 3.0
        param_step2.azimuth_vec_y = 4.0
        param_step2.altitude = 5.0    
        // 次のパラメータの再ターゲット
        LCAlgoStylusParamRetarget( stylus_param, param_step2 )        
        
        // ステップのチェック
        while !LCAlgoLineHermiteIsStopped( line ) {
            // 次のポイント種t区
            now_step = LCAlgoLineHermiteNext( line )
            
            // 進捗度の取得
            let progress = now_step.progress
            
            // スタイラスパラメータの進捗情報を取得
            let param_step3 = LCAlgoStylusParamProgress( stylus_param, progress )
            
            let k1 = (1.0 - progress)
            let k2 = progress
            
            XCTAssertEqual( param_step3.force, (param_step1.force * k1 + param_step2.force * k2) )
            XCTAssertEqual( param_step3.azimuth_angle, (param_step1.azimuth_angle * k1 + param_step2.azimuth_angle * k2) )
            XCTAssertEqual( param_step3.azimuth_vec_x, (param_step1.azimuth_vec_x * k1 + param_step2.azimuth_vec_x * k2) )
            XCTAssertEqual( param_step3.azimuth_vec_y, (param_step1.azimuth_vec_y * k1 + param_step2.azimuth_vec_y * k2) )
            XCTAssertEqual( param_step3.altitude, (param_step1.altitude * k1 + param_step2.altitude * k2) )
        }
    }
    
}
