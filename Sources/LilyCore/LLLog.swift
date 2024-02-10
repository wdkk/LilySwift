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

/// 有効ログタイプ
/// - LLLogのみログタイプと関係なく、Debugモードならば必ず表示される
public enum LLLogEnableType : Int
{
    case none = 0      /// ログ出力無し (警告ログ,強いログともに無効)
    case force = 1     /// 強いログの表示 (警告ログは無効)
    case warning = 2   /// 警告ログの表示 (強いログは無効)
    case all = 3       /// すべてのログの表示
}

/// 内部変数: 有効なLLLogを示すタイプの状態変数
fileprivate var __LLLog_enable_type:LLLogEnableType = .all

public func LLLogEnabled() -> Bool {
    return (__LLLog_enable_type.rawValue & LLLogEnableType.all.rawValue) > 0
}

public func LLLogWarningEnabled() -> Bool {
    return (__LLLog_enable_type.rawValue & LLLogEnableType.warning.rawValue) > 0
}

public func LLLogForceEnabled() -> Bool {
    return (__LLLog_enable_type.rawValue & LLLogEnableType.force.rawValue) > 0
}

public func LLLogSetEnableType( _ type: LLLogEnableType ) {
    __LLLog_enable_type = type
}
