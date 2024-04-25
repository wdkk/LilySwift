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
#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif

/// iOS/macOSのシステム属性へのアクセス
private var systemAttributes: [FileAttributeKey: Any]? {
    return try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory())
}

/// システム初期化
/// - Description: iOS/macOSではnoop.
public func LCSystemInit() {
    //print( "[ Lily build ]" )
}

/// 空きメモリの取得
/// - Returns: メガバイト数, 取得失敗した場合 = 0.0
public func LCSystemGetFreeMemory() -> LLDouble {
    // 参考
    // https://qiita.com/rinov/items/f30d386fb7b8b12278a5
    var info = mach_task_basic_info()
    var count = UInt32( MemoryLayout.size( ofValue: info ) / MemoryLayout<integer_t>.stride )
    let result = withUnsafeMutablePointer( to: &info ) {
        task_info(
            mach_task_self_,
            task_flavor_t(MACH_TASK_BASIC_INFO),
            // task_infoの引数にするため, Int32ポインタ型
            $0.withMemoryRebound(to: Int32.self, capacity: 1) { pointer in
                UnsafeMutablePointer<Int32>( pointer )
            }, &count )
    }
    
    return result == KERN_SUCCESS ? LLDouble(info.resident_size) / 1000000.0 : 0.0
}

/// 空きストレージ容量の取得
/// - Parameter root_path: ストレージのパス
/// - Returns: メガバイト数, 取得失敗した場合 = 0.0
public func LCSystemGetFreeStorage( _ root_path:LLConstCharPtr ) -> LLDouble {
    // 参考
    // https://qiita.com/rinov/items/f30d386fb7b8b12278a5
    guard let attributes = systemAttributes,
    let size = (attributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.doubleValue
    else { return 0.0 }
    return size / 1000000.0
}

/// Retinaスケールを返す
/// - Returns: 解像度倍率
public func LCSystemGetRetinaScale() -> LLDouble {
    #if os(iOS)
    return LLDouble( UIScreen.main.scale )
    #elseif os(macOS)
    // TODO: メインスレッド以外で呼ぶと問題があるため修正必要
    guard let scale = NSScreen.main?.backingScaleFactor else { return 1.0 }
    return LLDouble( scale )
    #else
    return 1.0
    #endif
}

/// Dpi倍率を返す
/// - Returns: Dpi倍率サイズ
/// - Description: iOS/macOSではRetinaスケールと同様
public func LCSystemGetDpiScale() -> LLSize {
    return LLSizeMake( LCSystemGetRetinaScale(), LCSystemGetRetinaScale() )
}

/// 処理待機する
/// - Parameter milli_second: 待機する時間(ミリ秒)
/// - Description: 注意. 待機で負荷が増えるため, 待機時間が長い場合LCSystemWaitを用いる
public func LCSystemSleep( _ milli_second:Int ) {
    if milli_second > 0 {
        Thread.sleep(forTimeInterval: LLDouble( milli_second ) / 1000.0 )
    }
}

/// 処理待機する
/// - Parameter milli_second: 待機する時間(ミリ秒)
public func LCSystemWait( _ milli_second:Int ) {
    let wait_time = milli_second
    let t = LCClockNow()
    while LCClockNow() - t < wait_time { LCSystemSleep( 1 ) }
}
