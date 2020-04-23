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

/// ファイルパス管理モジュール
open class LLPath
{
    /// バンドルパスを取得する(ビルドに含めたバンドルファイルの保管位置)
    /// - Parameter filename: 基準パスに追加する相対ファイルパス
    /// - Returns: パス文字列 ( ex:(Mac) /Users/xxx/Desktop/LilyApp.app/Contents/Resources/ )
    static public func bundle( _ filename:LLString = "" ) -> LLString {
        return LLString( LCPathGetBundle( filename.lcStr ) )
    }
 
    #if LILY_FULL
    /// 起動時パスを取得する(.appの位置)
    /// - Parameter filename: 基準パスに追加する相対ファイルパス
    /// - Returns: パス文字列 ( ex:(Mac) /Users/xxx/Desktop/LilyApp.appの場合 -> /Users/xxx/Desktop/ )
    static public func launching( _ filename:LLString = "" ) -> LLString {
        return LLString( LCPathGetLaunching( filename.lcStr ) )
    }
    
    /// ドキュメントフォルダのパスを取得する(Documentsの位置)
    /// - Parameter filename: 基準パスに追加する相対ファイルパス
    /// - Returns: パス文字列 ( ex:(Mac) /Users/xxx/Documents/ )
    static public func documents( _ filename:LLString = "" ) -> LLString {
        return LLString( LCPathGetDocuments( filename.lcStr ) )
    }

    /// 一時フォルダのパスを取得する(システム管理下に自動生成されるパス)
    /// - Parameter filename: 基準パスに追加する相対ファイルパス
    /// - Returns: パス文字列 ( ex:(Mac) /var/folders/x4/xxxxxxxxxxxxxxxxxxxx/T/ )
    static public func temp( _ filename:LLString = "" ) -> LLString {
        return LLString( LCPathGetTemp( filename.lcStr ) )
    }
    
    /// キャッシュのパスを取得する(Cachesの位置)
    /// - Parameter filename: 基準パスに追加する相対ファイルパス
    /// - Returns: パス文字列 ( ex:(Mac) /Users/xxx/Library/Caches/ )
    static public func cache( _ filename:LLString = "" ) -> LLString {
        return LLString( LCPathGetCache( filename.lcStr ) )
    }
    
    /// 指定したディレクトリのファイル名を列挙する
    /// - Parameters:
    ///   - dir_path: 対象のディレクトリパス
    ///   - filters: ファイル名のフィルタリング文字列配列( ex: "*i*.jpg"のとき"Lily.jpg"などが得られる. "*"ならば全ファイル )
    /// - Returns: ファイル名の配列
    static public func enumerateFiles( at dir_path:LLString, filters:[LLString] = [] ) -> [LLString] {
        // [LLString] -> LCStringArraySmPtrへ転写
        let filters_lcarray = LCStringArrayMake()
        for fil in filters {
            LCStringArrayAppend( filters_lcarray, fil.lcStr )
        }
        
        let efs = LCPathEnumerateFiles( dir_path.lcStr, filters_lcarray )
        var pp = [LLString]()
        for i in 0 ..< LCStringArrayCount( efs ) {
            let lcStr = LCStringArrayAt( efs, i )
            pp.append( LLString( lcStr ) )
        }
        return pp
    }
    
    /// 指定したディレクトリのサブディレクトリ名を列挙する
    /// - Parameters:
    ///   - dir_path: 対象のディレクトリパス
    /// - Returns: サブディレクトリ名の配列
    static public func enumerateDirectories( at dir_path:LLString ) -> [LLString] {
        let efs = LCPathEnumerateDirectories( dir_path.lcStr )
        var pp = [LLString]()
        for i in 0 ..< LCStringArrayCount( efs ) {
            let lcStr = LCStringArrayAt( efs, i )
            pp.append( LLString( lcStr ) )
        }
        return pp
    }
    #endif
    
    /// パスからファイル名を抽出する(拡張子なし)
    /// - Parameter path: ファイル名を含む対象のパス
    /// - Returns: ファイル名 ( ex: /Users/xxx/Documents/abc.jpg -> abc )
    static public func pickFilename( _ path:LLString ) -> LLString {
        return LLString( LCPathPickFilename( path.lcStr ) )
    }

    /// パスからファイル名を抽出する(拡張子あり)
    /// - Parameter path: ファイル名を含む対象のパス
    /// - Returns: ファイル名 ( ex: /Users/xxx/Documents/abc.jpg -> abc.jpg )
    static public func pickFilenameFull( _ path:LLString ) -> LLString {
        return LLString( LCPathPickFilenameFull( path.lcStr ) )
    }

    /// パスから拡張子を抽出する
    /// - Parameter path: ファイル名を含む対象のパス
    /// - Returns: ファイル名 ( ex: /Users/xxx/Documents/abc.jpg -> jpg )
    static public func pickExtension( _ path:LLString ) -> LLString {
        return LLString( LCPathPickExtension( path.lcStr ) )
    }
}

