//
// Lily Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation

/// 起動位置のパスを取得
/// - Parameter filename: パスに追加するファイル名
/// - Returns: 起動位置のパス文字列
/// - Description: 最後にスラッシュがつく. filenameはその最後尾に付与される
public func LCPathGetLaunching( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    #if os(iOS)
    return LCStringMakeWithCChars( (NSHomeDirectory() + "/" + String( filename )).cChar )
    #elseif os(macOS)
    let dir = LCStringMakeWithCChars( Bundle.main.bundlePath.url.deletingLastPathComponent().relativePath.cChar )
    return LCStringJoin( dir, LCStringJoin( LCStringMakeWithCChars( "/" ), filename ) )
    #endif    
}

/// バンドルのパスを取得
/// - Parameter filename: パスに追加するファイル名
/// - Returns: バンドルパス文字列
/// - Description: 最後にスラッシュがつく. filenameはその最後尾に付与される
public func LCPathGetBundle( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    var full_path = Bundle.main.bundlePath
    
    #if targetEnvironment(macCatalyst)
    full_path = "\(full_path)/Contents/Resources/\(String(filename))"
    #elseif os(iOS)
    full_path = "\(full_path)/\(String(filename))"
    #elseif os(macOS)
    full_path = "\(full_path)/Contents/Resources/\(String(filename))"
    #endif
    
    return LCStringMakeWithCChars( full_path.cChar )
}

/// ドキュメントディレクトリのパスを取得
/// - Parameter filename: パスに追加するファイル名
/// - Returns: ドキュメントディレクトリパス文字列
/// - Description: 最後にスラッシュがつく. filenameはその最後尾に付与される
public func LCPathGetDocuments( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    #if os(iOS)
    let path = "\(NSHomeDirectory())/Documents/\(String(filename))"
    #elseif os(macOS)
    let paths = NSSearchPathForDirectoriesInDomains( .documentDirectory, .userDomainMask, true )
    let path = "\(paths[0])/\(String(filename))"
    #endif
    
    return LCStringMakeWithCChars( path.cChar )
}

/// 一時保存ディレクトリのパスを取得
/// - Parameter filename: パスに追加するファイル名
/// - Returns: 一時保存ディレクトリパス文字列
/// - Description: 最後にスラッシュがつく. filenameはその最後尾に付与される
public func LCPathGetTemp( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    #if os(iOS)
    let path = "\(NSHomeDirectory())/tmp/\(String(filename))"
    #elseif os(macOS)
    let path = "\(NSTemporaryDirectory())\(String(filename))"
    #endif
    
    return LCStringMakeWithCChars( path.cChar )
}

/// キャッシュディレクトリのパスを取得
/// - Parameter filename: パスに追加するファイル名
/// - Returns: キャッシュディレクトリパス文字列
/// - Description: 最後にスラッシュがつく. filenameはその最後尾に付与される
public func LCPathGetCache( _ filename:LCStringSmPtr ) -> LCStringSmPtr { 
    #if os(iOS)
    let path = "\(NSHomeDirectory())/Library/Caches/\(String(filename))"
    #elseif os(macOS)
    let paths = NSSearchPathForDirectoriesInDomains( .cachesDirectory, .userDomainMask, true )
    let path = "\(paths[0])/\(String(filename))"
    #endif
    
    return LCStringMakeWithCChars( path.cChar )
}

/// パスからファイル名(拡張子なし)を抽出する
/// - Parameter filename: パス文字列
/// - Returns: ファイル名文字列
/// - Description: ex: /aaa/bbb/ccc.jpg -> ccc が得られる
public func LCPathPickFilename( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    let path = String( filename ).url.deletingPathExtension().lastPathComponent
    return LCStringMakeWithCChars( path.cChar )
}

/// パスからファイル名 + 拡張子を抽出する
/// - Parameter filename: パス文字列
/// - Returns: ファイル名文字列
/// - Description: ex: /aaa/bbb/ccc.jpg -> ccc.jpg が得られる
public func LCPathPickFilenameFull( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    let path = String( filename ).url.lastPathComponent
    return LCStringMakeWithCChars( path.cChar )
}

/// パスから拡張子を抽出する
/// - Parameter filename: パス文字列
/// - Returns: ファイル名文字列
/// - Description: ex: /aaa/bbb/ccc.jpg -> jpg が得られる
public func LCPathPickExtension( _ filename:LCStringSmPtr ) -> LCStringSmPtr {
    let path = String( filename ).url.pathExtension
    return LCStringMakeWithCChars( path.cChar )
}

/// 指定したディレクトリ内のファイルをリスト化する
/// - Parameters:
///   - dir_path: スキャンするディレクトリパス
///   - filters: ファイル名の条件フィルタ
/// - Returns: ファイル名配列オブジェクト
/// - Description: フィルタはワイルドカード(*)が使える. *とすればすべてのファイル, *.pngとすればpngファイルなど
public func LCPathEnumerateFiles( _ dir_path:LCStringSmPtr, _ filters:LCStringArraySmPtr )
-> LCStringArraySmPtr {
    let array = LCStringArrayMake()
    
    do {
        // ファイル/フォルダ名を取得
        let str_dir_path = String( dir_path )
        let contents = try FileManager.default.contentsOfDirectory(atPath: str_dir_path )
        let count_contents = contents.count
        // フィルタの数
        let count_filters = LCStringArrayCount( filters )
        
        // ファイルを走査し、フィルタで該当するファイルを配列に追加していく
        for i in 0 ..< count_contents {
            // ファイル名
            let filename = contents[i]
            // ファイルのフルパス
            let path = str_dir_path.url.appendingPathComponent( filename ).relativePath
            
            // フォルダの場合次へ
            var is_dir:ObjCBool = false
            if FileManager.default.fileExists( atPath: path, isDirectory: &is_dir ) && is_dir.boolValue {
                continue
            }
            
            // ファイルがない場合も次へ
            if !FileManager.default.fileExists( atPath: path ) {
                continue
            }
            
            // LCString型のファイル名
            let lc_filename = LCStringMakeWithCChars( filename.cChar )
            
            // フィルタがない場合はそのままファイル名をリストに追加
            if count_filters < 1 { 
                LCStringArrayAppend( array, lc_filename )
            }
            
            // いずれかのフィルタに該当するかをチェック
            for i in 0 ..< count_filters {
                // フィルタ文字列の取得
                let filter = LCStringArrayAt( filters, i )     
                // ファイル名がフィルタに該当した場合リストに追加してループから抜ける
                if LCPathIsMatchFilter( lc_filename, filter ) {
                    LCStringArrayAppend( array, lc_filename )
                    break
                }
            }
        }
        return array
    }
    catch {
        return array
    }
}

/// 指定したディレクトリ内のサブディレクトリをリスト化する
/// - Parameters:
///   - dir_path: スキャンするディレクトリパス
/// - Returns: サブディレクトリ名配列オブジェクト
public func LCPathEnumerateDirectories( _ dir_path:LCStringSmPtr ) 
-> LCStringArraySmPtr {
    let array = LCStringArrayMake()
    
    do {
        // ファイル/フォルダ名を取得
        let str_dir_path = String( dir_path )
        let contents = try FileManager.default.contentsOfDirectory(atPath: str_dir_path )
        let count_contents = contents.count
    
        for i in 0 ..< count_contents {
            let name = contents[i]
            // フルパス
            let path = str_dir_path.url.appendingPathComponent( name ).relativePath
            
            // フォルダだった場合追加する
            var is_dir:ObjCBool = false
            if FileManager.default.fileExists( atPath: path, isDirectory: &is_dir ) && is_dir.boolValue {
                LCStringArrayAppendChars( array, name.cChar )
            }
        }
        
        return array
    }
    catch {
    
        return array
    }
}

public func LCPathIsMatchFilter( _ path_:LCStringSmPtr, _ filter_:LCStringSmPtr ) -> Bool {
    var pos:Int = 0
    let wildcard = LCStringMakeWithCChars("*")
    let wildcard2 = LCStringMakeWithCChars("**")
    
    var path = LCStringMake( path_ )
    var filter = LCStringMake( filter_ )
    
    // 文字列がない場合はすべてtrueとする
    if LCStringIsEmpty( filter ) { return true }
    // ワイルドカードのみbの場合もすべてtrueとする
    if LCStringIsEqual( filter, wildcard ) { return true }

    // "**"を"*"にまとめていく
    while true {
        let p = LCStringFind( filter, 0, wildcard2 )
        if p == -1 { break }
        filter = LCStringReplace( filter, wildcard2, wildcard )
    }
    
    // dev_filterに文字列分割
    var dev_filter = [String]()
    // filterの文字をワイルドカードで分割
    while( true ) {
        let p = LCStringFind( filter, pos, wildcard )
        if p == -1 {
            // *が見つからなくなったら、最後の文字列を追加し処理を終了
            let str = LCStringSubString( filter, pos, LCStringByteLength( filter ) )
            if 0 < LCStringByteLength( str ) {
                dev_filter.append( String( str ) )
            }
            break 
        }
        let length = p - pos
        // 見つけた*直前までの文字列をstrに格納
        let str = LCStringSubString( filter, pos, length )
        // strの長さが0でなければ追加
        if 0 < LCStringByteLength( str ) {
            dev_filter.append( String( str ) )
            pos += length
        }
        // 発見した*分を追加
        dev_filter.append( "*" )
        pos += 1
    }
    
    let count = dev_filter.count
    for i in (0 ..< count).reversed() {
        let curr_word = LCStringMakeWithCChars( dev_filter[i].cChar )
 
        // ワイルドカードのときはいずれのチェックもOKとして次のwordに進む
        if LCStringIsEqual( curr_word, wildcard ) { continue }
        
        // ワイルドカードでない場合、後方文字列一致を行う
        let p = LCStringFindReverse( path, curr_word )
        // 後方一致が取れなかった場合、ミスマッチなのでfalseを返して終了
        if p == -1 { return false }
        
        // 検索対象パスの削減
        path = LCStringSubString( path, 0, p )
    }
    
    // 最終のフィルタ区間がワイルドカードではなく, pathに文字が残る場合は先頭がミスマッチなのでfalseで終了
    if dev_filter[0] != "*" && LCStringByteLength( path ) > 0 { return false }
    
    // ここまで通ってきたものはフィルタ対象になるのでtrue
    return true
}
