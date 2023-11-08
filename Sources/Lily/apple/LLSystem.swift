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
#if os(macOS)
import AppKit
#endif

/// システム管理モジュール
open class LLSystem
{
    /// 空きメモリ容量(MB)
    static public var freeMemory:Double {
        return LCSystemGetFreeMemory()
    }
    
    /// 空きストレージ容量を返す
    /// - Parameter path: 対象のストレージボリュームのパス
    /// - Returns: 空き容量(MB)
    static public func freeStorage( path:String = "/" ) -> Double {
        return LCSystemGetFreeStorage( path.cChar ) 
    }
    
    #if os(macOS)
    static public var currentWindow:NSWindow?
    static private var _retinaScale:Double = 1.0
    
    static public func updateRetinaScale() {
        _retinaScale = LLSystem.currentWindow?.backingScaleFactor.d ?? 1.0
    }
    #endif
    
    /// デバイスのretinaスケール(2.0, 3.0など)
    static public var retinaScale:Double {
        #if os(macOS)
        return _retinaScale
        #else
        return LCSystemGetRetinaScale()
        #endif
    }
    
    /// 指定したミリ秒だけ処理を停止する(待機時間が長い場合, wait()を使う)
    /// - Parameter ms: 待機時間(ミリ秒)
	static public func sleep( _ ms:Int ) { 
        LCSystemSleep( ms )
    }
    
    /// 指定したミリ秒だけ処理を待機する（待機時間が長い時向け)
    /// - Parameter ms: 待機時間(ミリ秒)
	static public func wait( _ ms:Int ) { 
        LCSystemWait( ms ) 
    }
    
    /// 指定したミリ秒だけ処理を待機する（待機時間が長い時向け)
    /// - Parameter ms: 待機時間(ミリ秒)
    static public func wait( _ msd:Double ) { 
        guard let ms:Int = msd.i else { return }
        LCSystemWait( ms ) 
    }
}
