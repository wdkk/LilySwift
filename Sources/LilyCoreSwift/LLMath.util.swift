//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public func LLRandom() -> LLFloat {
    return LLFloat( arc4random() ) / LLFloat( UINT32_MAX )
}

public func LLRandomf( _ v_:LLFloat ) -> LLFloat {
    return v_ * LLFloat( arc4random() ) / LLFloat( UINT32_MAX )
}

public func LLRandomd( _ v_:LLDouble ) -> LLDouble {
    return v_ * LLDouble( arc4random() ) / LLDouble( UINT32_MAX )
}

public func LLRandomi( _ v_:LLInt32 ) -> LLInt32 {
    if v_ < 1 { return 0 }
    return Int32((arc4random() >> 1)) % v_
}

public func LLRandomu( _ v_:LLUInt32 ) -> LLUInt32 {
    return arc4random() % v_
}

public func LLAngleZero() -> LLAngle {
    return LLAngle( radians:0 )
}

public func LLAngleMakeWithDegrees( _ deg_:LLDouble ) -> LLAngle {
    return LLAngle( radians:deg_ * LL_PI / 180.0 )
}

public func LLAngleMakeWithRadians( _ rad_:LLDouble ) -> LLAngle {
    return LLAngle( radians:rad_ )
}

public func LLAngleDegrees( _ angle_:LLAngle ) -> LLDouble {
    return angle_.value * 180.0 / LL_PI
}

public func LLAngleRadians( _ angle_:LLAngle ) -> LLDouble {
    return angle_.value
}
