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

private func generateConvertDictionary() -> [String:[Any?]] {
    return [ "i":[Any?](), "i8":[Any?](), "i16":[Any?](), "i32":[Any?](), "i64":[Any?](),
             "u":[Any?](), "u8":[Any?](), "u16":[Any?](), "u32":[Any?](), "u64":[Any?](),
             "f":[Any?](), "d":[Any?](), "cgf":[Any?]() ]
}

class TestLLType_ext: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_castFromInt() {
        let arr:[Int] = [ 123, -123, Int.max ]
        
        let flags = [ "i":[ true, true, true ],
                      "i8":[ true, true, false ],
                      "i16":[ true, true, false ],
                      "i32":[ true, true, false ],
                      "i64":[ true, true, true ],
                      "u":[ true, false, true ],
                      "u8":[ true, false, false ],
                      "u16":[ true, false, false ],
                      "u32":[ true, false, false ],
                      "u64":[ true, false, true ],
                      "f":[ true, true, true ],
                      "d":[ true, true, true ],
                      "cgf":[ true, true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            //convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromInt8() {
        let arr:[Int8] = [ 123, -123, Int8.max ]
        
        let flags = [ "i":[ true, true, true ],
                      "i8":[ true, true, true ],
                      "i16":[ true, true, true ],
                      "i32":[ true, true, true ],
                      "i64":[ true, true, true ],
                      "u":[ true, false, true ],
                      "u8":[ true, false, true ],
                      "u16":[ true, false, true ],
                      "u32":[ true, false, true ],
                      "u64":[ true, false, true ],
                      "f":[ true, true, true ],
                      "d":[ true, true, true ],
                      "cgf":[ true, true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            //convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromInt16() {
        let arr:[Int16] = [ 123, -123, 256 ]
        
        let flags = [ "i":[ true, true, true ],
                      "i8":[ true, true, false ],
                      "i16":[ true, true, true ],
                      "i32":[ true, true, true ],
                      "i64":[ true, true, true ],
                      "u":[ true, false, true ],
                      "u8":[ true, false, false ],
                      "u16":[ true, false, true ],
                      "u32":[ true, false, true ],
                      "u64":[ true, false, true ],
                      "f":[ true, true, true ],
                      "d":[ true, true, true ],
                      "cgf":[ true, true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            //convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromInt32() {
        let arr:[Int32] = [ 123, -123, Int32.max ]
        
        let flags = [ "i":[ true, true, true ],
                      "i8":[ true, true, false ],
                      "i16":[ true, true, false ],
                      "i32":[ true, true, true ],
                      "i64":[ true, true, true ],
                      "u":[ true, false, true ],
                      "u8":[ true, false, false ],
                      "u16":[ true, false, false ],
                      "u32":[ true, false, true ],
                      "u64":[ true, false, true ],
                      "f":[ true, true, true ],
                      "d":[ true, true, true ],
                      "cgf":[ true, true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            //convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromInt64() {
        let arr:[Int64] = [ 123, -123, Int64.max ]
        
        let flags = [ "i":[ true, true, true ],
                      "i8":[ true, true, false ],
                      "i16":[ true, true, false ],
                      "i32":[ true, true, false ],
                      "i64":[ true, true, true ],
                      "u":[ true, false, true ],
                      "u8":[ true, false, false ],
                      "u16":[ true, false, false ],
                      "u32":[ true, false, false ],
                      "u64":[ true, false, true ],
                      "f":[ true, true, true ],
                      "d":[ true, true, true ],
                      "cgf":[ true, true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            //convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromUInt() {
        let arr:[UInt] = [ 123, UInt.max ]
        
        let flags = [ "i":[ true, false ],
                      "i8":[ true, false ],
                      "i16":[ true, false ],
                      "i32":[ true, false ],
                      "i64":[ true, false ],
                      "u":[ true, true ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, false ],
                      "u64":[ true, true ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            //convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromUInt8() {
        let arr:[UInt8] = [ 123, UInt8.max ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, false ],
                      "i16":[ true, true ],
                      "i32":[ true, true ],
                      "i64":[ true, true ],
                      "u":[ true, true ],
                      "u8":[ true, true ],
                      "u16":[ true, true ],
                      "u32":[ true, true ],
                      "u64":[ true, true ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            //convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromUInt16() {
        let arr:[UInt16] = [ 123, UInt16.max ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, false ],
                      "i16":[ true, false ],
                      "i32":[ true, true ],
                      "i64":[ true, true ],
                      "u":[ true, true ],
                      "u8":[ true, false ],
                      "u16":[ true, true ],
                      "u32":[ true, true ],
                      "u64":[ true, true ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            //convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromUInt32() {
        let arr:[UInt32] = [ 123, UInt32.max ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, false ],
                      "i16":[ true, false ],
                      "i32":[ true, false ],
                      "i64":[ true, true ],
                      "u":[ true, true ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, true ],
                      "u64":[ true, true ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            //convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromUInt64() {
        let arr:[UInt64] = [ 123, UInt64.max ]
        
        let flags = [ "i":[ true, false ],
                      "i8":[ true, false ],
                      "i16":[ true, false ],
                      "i32":[ true, false ],
                      "i64":[ true, false ],
                      "u":[ true, true ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, false ],
                      "u64":[ true, true ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            //convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromFloat() {
        let arr:[Float] = [ 123.4, -123.4 ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, true ],
                      "i16":[ true, true ],
                      "i32":[ true, true ],
                      "i64":[ true, true ],
                      "u":[ true, false ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, false ],
                      "u64":[ true, false ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            //convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromDouble() {
        let arr:[Double] = [ 123.4, -123.4 ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, true ],
                      "i16":[ true, true ],
                      "i32":[ true, true ],
                      "i64":[ true, true ],
                      "u":[ true, false ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, false ],
                      "u64":[ true, false ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            //convs["d"]!.append( a.d )
            convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
    
    func test_castFromCGFloat() {
        let arr:[CGFloat] = [ 123.4, -123.4 ]
        
        let flags = [ "i":[ true, true ],
                      "i8":[ true, true ],
                      "i16":[ true, true ],
                      "i32":[ true, true ],
                      "i64":[ true, true ],
                      "u":[ true, false ],
                      "u8":[ true, false ],
                      "u16":[ true, false ],
                      "u32":[ true, false ],
                      "u64":[ true, false ],
                      "f":[ true, true ],
                      "d":[ true, true ],
                      "cgf":[ true, true ] ]
        
        // cast結果を代入
        var convs = generateConvertDictionary()
        for a in arr {
            convs["i"]!.append( a.i )
            convs["i8"]!.append( a.i8 )
            convs["i16"]!.append( a.i16 )
            convs["i32"]!.append( a.i32 )
            convs["i64"]!.append( a.i64 )
            convs["u"]!.append( a.u )
            convs["u8"]!.append( a.u8 )
            convs["u16"]!.append( a.u16 )
            convs["u32"]!.append( a.u32 )
            convs["u64"]!.append( a.u64 )
            convs["f"]!.append( a.f )
            convs["d"]!.append( a.d )
            //convs["cgf"]!.append( a.cgf )
        }
        
        for ( key, value ) in convs {
            for i in 0 ..< value.count {
                XCTAssertEqual( value[i] != nil, flags[key]![i], ".\(key): arr[\(i)]" )
            }
        }
    }
}
