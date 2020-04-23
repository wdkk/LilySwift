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

/// システム管理モジュール
open class LLSystem
{
    #if LILY_FULL
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
    #endif
	
    /// デバイスのretinaスケール(2.0, 3.0など)
    static public var retinaScale:Double {
        return LCSystemGetRetinaScale()
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
        guard let ms = msd.i else { return }
        LCSystemWait( ms ) 
    }
}
