//
// Lily Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// 時間モジュールの初期化
public func LCClockInit() {
}

/// システムの現在時間をミリ秒の値で取得
/// - Returns: システム現在時間(ミリ秒)
public func LCClockNow() -> LLInt64 {
    var now_time:timeval = timeval()
    var tzp:timezone = timezone()
    gettimeofday( &now_time, &tzp )
    return LLInt64( now_time.tv_sec * 1000 ) + LLInt64( now_time.tv_usec / 1000 )  
}

public func LCClockNowMicroSecond() -> Double {
    var now_time:timeval = timeval()
    var tzp:timezone = timezone()
    gettimeofday( &now_time, &tzp )
    return Double( now_time.tv_sec ) * 1_000_000 + Double( now_time.tv_usec )  
}

fileprivate var is_started:Bool = false
fileprivate var time_span:LLInt64 = 0
fileprivate var fps:Int = 0

/// FPSをコンソール出力する
/// - Description: アプリケーションループ内で繰り返し呼びだして用いる. 1秒に何回呼ばれたかを蓄積し、1秒毎に出力する
public func LCClockFPS() {
    if !is_started {
        is_started = true
        time_span = LCClockNow()
        fps = 0
    }
    
    if LCClockNow() - time_span >= 1000 {
        LLLogForce( "FPS:\(fps)" )
        time_span = LCClockNow()
        fps = 0
    }

    fps += 1
}
