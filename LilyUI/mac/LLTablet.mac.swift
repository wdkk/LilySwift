//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import Cocoa

open class LLTablet
{
    static var _state = LLTabletState( x: 0.0, y: 0.0, z: 0.0, twist: 0.0, altitude: 0.0, azimuth: 0.0, pressure: 1.0 )
    
    static func updateState( event:NSEvent ) {
        LLTablet._state.x = event.absoluteX.f
        LLTablet._state.y = event.absoluteY.f
        LLTablet._state.z = event.absoluteZ.f
        LLTablet._state.pressure = event.pressure
        LLTablet._state.twist = 0.0
        LLTablet._state.altitude = 0.0
        LLTablet._state.azimuth = 0.0
    }
    
    static public func currentState() -> LLTabletState {
        return LLTablet._state
    }
}

#endif
