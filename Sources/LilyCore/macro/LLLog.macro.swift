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

/// ログの出力(Debugモードのみ表示される)
/// - Parameters:
///   - body: 出力文字列
///   - file: ログ出力したソースファイル名(default = ファイル名)
///   - function: ログ出力した関数名(default = 実行中関数名)
///   - line: ログ出力した行数(default = 行数)
#if DEBUG
public func LLLog( _ body:Any?, file:String = #file, function:String = #function, line:Int = #line ) {
    if body != nil {
        let fn = LCPathPickFilenameFull( file.lcStr )
        print( "[\( fn ):\(line) \(function)] \(body!)" )
    }
}
#else 
public func LLLog( _ body:Any?, file:String = #file, function:String = #function, line:Int = #line ) {}
#endif

/// 警告ログの出力
/// - Parameters:
///   - body: 出力文字列
///   - file: ログ出力したソースファイル名(default = ファイル名)
///   - function: ログ出力した関数名(default = 実行中関数名)
///   - line: ログ出力した行数(default = 行数)
public func LLLogWarning( _ body:Any?, file:String = #file, function:String = #function, line:Int = #line ) {
    if LLLogWarningEnabled() && body != nil {
        let fn = LCPathPickFilenameFull( file.lcStr )
        print( "[\( fn ):\(line) \(function)] \(body!)" )
    }
}

/// 強いログの出力
/// - Parameters:
///   - body: 出力文字列
///   - file: ログ出力したソースファイル名(default = ファイル名)
///   - function: ログ出力した関数名(default = 実行中関数名)
///   - line: ログ出力した行数(default = 行数)
public func LLLogForce( _ body:Any?, file:String = #file, function:String = #function, line:Int = #line ) {
    if LLLogForceEnabled() && body != nil {
        let fn = LCPathPickFilenameFull( file.lcStr )
        print( "[\( fn ):\(line) \(function)] \(body!)" )
    }
}
