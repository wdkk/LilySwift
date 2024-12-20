//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
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
	public static var now:LLInt64 { return LCClockNow() }

    open class Precision {
        /// 現在時間(秒 & 小数でのマイクロ秒までの値)を取得する
        public static var now:Double { return LCClockPrecisionNow() }
    }

    /// くりかえす呼び出すことでframe per secondをコンソールに出力する
	@MainActor public static func fps() {
        return LCClockFPS()
    }
}
