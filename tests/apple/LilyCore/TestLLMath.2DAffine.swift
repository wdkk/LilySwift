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

class TestLLMath_2DAffine: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    func test_affineMake() {
        let af = LL2DAffineMake( 2, 0, 0, -30, 2, 50 )
        XCTAssertEqual( af.a, 2 )
        XCTAssertEqual( af.b, 0 )
        XCTAssertEqual( af.c, 0 )
        XCTAssertEqual( af.d, -30 )
        XCTAssertEqual( af.e, 2 )
        XCTAssertEqual( af.f, 50 )
    }
    
    func test_affineIdentity() {
        let af = LL2DAffineIdentity()
        XCTAssertEqual( af.a, 1 )
        XCTAssertEqual( af.b, 0 )
        XCTAssertEqual( af.c, 0 )
        XCTAssertEqual( af.d, 0 )
        XCTAssertEqual( af.e, 1 )
        XCTAssertEqual( af.f, 0 )
    }
    
    func test_affineTranslate() {
        let af_translate = LL2DAffineTranslate( -30, 50 )
        XCTAssertEqual( af_translate.a, 1 )
        XCTAssertEqual( af_translate.b, 0 )
        XCTAssertEqual( af_translate.c, -30 )
        XCTAssertEqual( af_translate.d, 0 )
        XCTAssertEqual( af_translate.e, 1 )
        XCTAssertEqual( af_translate.f, 50 )
    }
    
    func test_affineScale() {
        let af_scale = LL2DAffineScale( 2.3, 3.7 )
        XCTAssertEqual( af_scale.a, 2.3 )
        XCTAssertEqual( af_scale.b, 0 )
        XCTAssertEqual( af_scale.c, 0 )
        XCTAssertEqual( af_scale.d, 0 )
        XCTAssertEqual( af_scale.e, 3.7 )
        XCTAssertEqual( af_scale.f, 0 )
    }
    
    func test_affineRotate() {
        let af_rotate = LL2DAffineRotate( 30.0 )
        let radian = 30.0 * Double.pi / 180.0
        XCTAssertEqual( af_rotate.a, cos( radian ) )
        XCTAssertEqual( af_rotate.b, -sin( radian ) )
        XCTAssertEqual( af_rotate.c, 0 )
        XCTAssertEqual( af_rotate.d, sin( radian ) )
        XCTAssertEqual( af_rotate.e, cos( radian ) )
        XCTAssertEqual( af_rotate.f, 0 )
    }
    
    func test_affineMultiply() {
        let af_translate = LL2DAffineTranslate( -30, 50 )
        let af_scale = LL2DAffineScale( 2.3, 3.7 )
        let af_multi = LL2DAffineMultiply( af_translate, af_scale )
        XCTAssertEqual( af_multi.a, 1.0 * 2.3 )
        XCTAssertEqual( af_multi.b, 0 )
        XCTAssertEqual( af_multi.c, -30.0 * 2.3 )
        XCTAssertEqual( af_multi.d, 0 )
        XCTAssertEqual( af_multi.e, 1.0 * 3.7 )
        XCTAssertEqual( af_multi.f, 50.0 * 3.7 )
    }
    
    func test_affineInverse() {
        // 3つのアフィン係数を合成
        let af_translate = LL2DAffineTranslate( -30, 50 )
        let af_scale = LL2DAffineScale( 2.3, 3.7 )
        let af_rotate = LL2DAffineRotate( 30.0 )
        let af_multi = LL2DAffineMultiply( LL2DAffineMultiply( af_translate, af_scale ), af_rotate )
        
        // 初期点
        let pt = LLPointMake( 180.0, 120.0 )
        
        // 初期点をアフィン変換をほどこす
        let pt_multi = LLPointMake(
            pt.x * af_multi.a + pt.y * af_multi.b + af_multi.c,
            pt.x * af_multi.d + pt.y * af_multi.e + af_multi.f 
        )
        
        // 逆アフィン変換係数をもとめる
        let af_inverse = LL2DAffineInverse( af_multi )
        
        // アフィン変換後の点に逆アフィン変換をほどこす
        let pt_inverse = LLPointMake(
            pt_multi.x * af_inverse.a + pt_multi.y * af_inverse.b + af_inverse.c,
            pt_multi.x * af_inverse.d + pt_multi.y * af_inverse.e + af_inverse.f 
        )
        
        // 元の座標値に戻っているかを確認
        XCTAssertEqual( roundDouble( pt.x ), roundDouble( pt_inverse.x ) )
        XCTAssertEqual( roundDouble( pt.y ), roundDouble( pt_inverse.y ) )
    }
}
