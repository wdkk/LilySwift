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

/// ファイル管理モジュール
open class LLFile
{
    /// ファイルの存在を確認する
    /// - Parameter path: 確認するファイルパス
    /// - Returns: 存在する = true, 存在しない = false
    public static func exists( _ path:LLString ) -> Bool {
        return LCFileExists( path.lcStr ) 
    }

    /// ディレクトリであるか否かを確認する
    /// - Parameter path: 確認するディレクトリパス
    /// - Returns: ディレクトリ = true, それ以外 = false
    public static func isDirectory( _ path:LLString ) -> Bool { 
        return LCFileIsDirectory( path.lcStr )
    }
    
    /// ファイルのサイズを取得する
    /// - Parameter path: 確認するファイルパス
    /// - Returns: ファイルサイズ(バイト)
    public static func size( of path:LLString ) -> LLInt64 { 
        return LCFileGetSize( path.lcStr )
    }
    
    /// ファイルを削除する
    /// - Parameter path: 削除するファイルのパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func removeFile( _ path:LLString ) -> Bool {
        return LCFileRemove( path.lcStr ) 
    }
     
    /// ファイルを移動する
    /// - Parameters:
    ///   - from_path: 移動元ファイルパス
    ///   - to_path: 移動先ファイルパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func moveFile( _ from_path:LLString, to_path:LLString ) -> Bool {
        return LCFileMove( from_path.lcStr, to_path.lcStr ) 
    }
    
    /// ファイルをコピーする
    /// - Parameters:
    ///   - from_path: コピー元ファイルパス
    ///   - to_path: コピー先ファイルパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func copyFile( _ from_path:LLString, to_path:LLString ) -> Bool {
        return LCFileCopy(from_path.lcStr, to_path.lcStr)
    }
    
    /// ディレクトリを作成する
    /// - Parameter path: 作成するディレクトリパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func createDirectory( _ path:LLString ) -> Bool { 
        return LCFileCreateDirectory( path.lcStr ) 
    }

    /// ディレクトリを削除する. サブディレクトリや中身のファイルも同時に消す
    /// - Parameter path: 削除対象のディレクトリパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func removeDirectory( _ path:LLString ) -> Bool { 
        return LCFileRemoveDirectory( path.lcStr )
    }
    
    /// ディレクトリを移動する
    /// - Parameters:
    ///   - from_path: 移動元ディレクトリパス
    ///   - to_path: 移動先ディレクトリパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func moveDirectory( from from_path:LLString, to to_path:LLString ) -> Bool {
        return LCFileMoveDirectory( from_path.lcStr, to_path.lcStr )
    }

    /// ディレクトリをコピーする
    /// - Parameters:
    ///   - from_path: コピー元ディレクトリパス
    ///   - to_path: コピー先ディレクトリパス
    /// - Returns: 成功 = true, 失敗 = false
    @discardableResult
    public static func copyDirectory( from from_path:LLString, to to_path:LLString ) -> Bool {
        return LCFileCopyDirectory( from_path.lcStr, to_path.lcStr )
    }
}
