//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// 時間管理モジュール
open class LLClock 
{
    /// 現在時間(ミリ秒)を取得する
	static public var now:LLInt64 { 
        return LCClockNow()
    }
    
    #if LILY_FULL
    /// くりかえす呼び出すことでframe per secondをコンソールに出力する
	static public func fps() {
        return LCClockFPS()
    }
    #endif
}
