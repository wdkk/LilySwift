//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

public extension LLAngle
{
    static var zero:LLAngle { return LLAngleZero() }
    
    static func degrees( _ deg:LLDouble ) -> LLAngle { return LLAngleMakeWithDegrees( deg ) }

    static func radians( _ rad:LLDouble ) -> LLAngle { return LLAngleMakeWithRadians( rad ) } 
    
    static var random:LLAngle { return LLAngle.radians( LLRandomd( LL_2_PI ) ) }
      
    init( degrees:LLDouble ) { self.init( radians:LLAngleMakeWithDegrees( degrees ).radians ) }
    
    var degrees:LLDouble { return LLAngleDegrees( self ) }
    
    var radians:LLDouble { return LLAngleRadians( self ) }
}

public func + ( left:LLAngle, right:LLAngle ) -> LLAngle {
    return LLAngle( radians: left.radians + right.radians )
}

public func + <T:BinaryInteger>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians + Double( right ) )
}

public func + <T:BinaryFloatingPoint>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians + Double( right ) )
}

public func - ( left:LLAngle, right:LLAngle ) -> LLAngle {
    return LLAngle( radians: left.radians - right.radians )
}

public func - <T:BinaryInteger>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians - Double( right ) )
}

public func - <T:BinaryFloatingPoint>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians - Double( right ) )
}

public func * ( left:LLAngle, right:LLAngle ) -> LLAngle {
    return LLAngle( radians: left.radians * right.radians )
}

public func * <T:BinaryInteger>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians * Double( right ) )
}

public func * <T:BinaryFloatingPoint>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians * Double( right ) )
}

public func / ( left:LLAngle, right:LLAngle ) -> LLAngle {
    return LLAngle( radians: left.radians / right.radians )
}

public func / <T:BinaryInteger>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians / Double( right ) )
}

public func / <T:BinaryFloatingPoint>( left:LLAngle, right:T ) -> LLAngle {
    return LLAngle( radians: left.radians / Double( right ) )
}

public func == ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians == right.radians
}

public func != ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians != right.radians
}

public func > ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians > right.radians
}

public func < ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians < right.radians
}

public func >= ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians >= right.radians
}

public func <= ( left:LLAngle, right:LLAngle ) -> Bool {
    return left.radians <= right.radians
}
