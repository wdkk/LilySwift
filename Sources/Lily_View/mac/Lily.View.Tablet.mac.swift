//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import AppKit

extension Lily.View
{
    open class Tablet
    {
        nonisolated(unsafe) static var _state =
            LLTabletState( x: 0.0, y: 0.0, z: 0.0, twist: 0.0, altitude: 0.0, azimuth: 0.0, pressure: 1.0 )
        
        static func updateState( event:NSEvent ) {
            _state.x = event.absoluteX.f
            _state.y = event.absoluteY.f
            _state.z = event.absoluteZ.f
            _state.pressure = event.pressure
            _state.twist = 0.0
            _state.altitude = 0.0
            _state.azimuth = 0.0
        }
        
        public static func currentState() -> LLTabletState {
            return _state
        }
    }
}

#endif
