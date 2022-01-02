//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS)

import UIKit

open class LLTouchTapRecognizer
{
    private var _tapped:Bool = false
    private var _tap_start_time:LLInt64 = 0
    private var _tap_end_time:LLInt64 = 0
    open    var tapCount:Int = 0
    open    var tapInterval:Int = 192
    
    open func startTap() {
        _tap_start_time = LLClock.now
    }
    
    open func checkNextTap() -> Bool {
        let dt = LLClock.now - _tap_end_time
        if dt <= tapInterval.i64 {
            _tap_start_time = LLClock.now
            _tap_end_time = 0
            _tapped = true
            tapCount += 1
            return true
        }
        else {
            tapCount = 1
            _tapped = false
            return false
        }
    }
    
    open func checkIgniteTap( 
        tapped tappedFunc:( Int )->Void,
        nontapped nontappedFunc:()->Void )
    {
        // multi tap event
        let dt = LLClock.now - _tap_start_time
        if dt <= tapInterval.i64 {
            _tap_start_time = 0
            _tap_end_time = LLClock.now
            if _tapped { tappedFunc( tapCount ) }
            else { nontappedFunc() }
        }
        else {
            endTap()
        }
    }
    
    open func endTap() {
        _tapped = false
        tapCount = 0
        _tap_start_time = 0
        _tap_end_time = 0
    }
}


#endif
