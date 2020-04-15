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

/// ファイル/ディレクトリの存在を確認する
/// - Parameter path: 確認するファイルパス
/// - Returns: true = 存在する, false = 存在しない
@discardableResult
public func LCFileExists( _ path:LCStringSmPtr ) -> Bool {
    return FileManager.default.fileExists( atPath: String( path ) )
}

/// 指定したパスがディレクトリか否かを確認する
/// - Parameter path: 確認するファイルパス
/// - Returns: true = ディレクトリ, false = ディレクトリ以外 or 存在しない
@discardableResult
public func LCFileIsDirectory( _ path:LCStringSmPtr ) -> Bool {
    var is_dir:ObjCBool = false
    let _ = FileManager.default.fileExists(atPath: String( path ), isDirectory: &is_dir )
    return is_dir.boolValue
}

/// ファイルのサイズを取得
/// - Parameter path: 対象のファイルパス
/// - Returns: ファイルサイズ(バイト), 存在しない場合や失敗した場合0を返す
public func LCFileGetSize( _ path:LCStringSmPtr ) -> LLInt64 {
    if !LCFileExists( path ) {
        LLLogWarning( "ファイルがみつかりませんでした. \(String( path ))" )
        return 0
    }
    
    do {
        let attr:[FileAttributeKey : Any] = try FileManager.default.attributesOfItem( atPath: String( path ) )
         return attr[FileAttributeKey.size] as! LLInt64
    }
    catch {
        LLLogWarning( "ファイルサイズの取得に失敗しました. \(String( path )): error:\(error.localizedDescription)" )
        return 0    
    }
}

/// ファイルを削除する
/// - Parameter path: 削除するファイルのパス
/// - Returns: true = 成功 or もともと存在しない, false = 削除失敗
@discardableResult
public func LCFileRemove( _ path:LCStringSmPtr ) -> Bool {
    if !LCFileExists( path ) {
        LLLogWarning( "成功: 削除対象のファイルが見つかりません.(\( String( path ) )), trueを返します." )
        return true
    }
    
    do {
        try FileManager.default.removeItem( atPath: String( path ) )
        return true
    }
    catch {
        return false
    }
}

/// ファイルを移動する
/// - Parameters:
///   - from_path: 移動元ファイルパス
///   - to_path: 移動先ファイルパス
/// - Returns: true = 成功, false = 失敗 or 移動元にファイルが存在しない
@discardableResult
public func LCFileMove( _ from_path:LCStringSmPtr, _ to_path:LCStringSmPtr ) -> Bool {
    if !LCFileExists( from_path ) {
        LLLogWarning( "失敗: ファイルが見つかりません. (\(String( from_path )))" )
        return false
    }   

    do {
        try FileManager.default.moveItem( atPath: String( from_path ), toPath: String( to_path ) )
        return true
    }
    catch {
        LLLogWarning( "失敗: ファイルの移動に失敗しました. (\(error.localizedDescription))" )
        return false
    }
}

/// ファイルをコピーする
/// - Parameters:
///   - from_path: コピー元ファイルパス
///   - to_path: コピー先ファイルパス
/// - Returns: true = 成功, false = 失敗 or コピー元にファイルが存在しない
@discardableResult
public func LCFileCopy( _ from_path:LCStringSmPtr, _ to_path:LCStringSmPtr ) -> Bool { 
    if !LCFileExists( from_path ) {
        LLLogWarning( "失敗: ファイルが見つかりません. (\(String( from_path )))" )
        return false
    }  

    do {
        try FileManager.default.copyItem( atPath: String( from_path ), toPath: String( to_path ) )
        return true
    }
    catch {
        LLLogWarning( "失敗: ファイルのコピーに失敗しました. (\(error.localizedDescription))" )
        return false
    }
}

/// ディレクトリを作成する
/// - Parameter path: 作成するディレクトリのパス
/// - Returns: true = 成功 or すでに存在する, false = 失敗
@discardableResult
public func LCFileCreateDirectory( _ path:LCStringSmPtr ) -> Bool {
    if LCFileExists( path ) {
        LLLogWarning( "成功: ディレクトリはすでに存在しています. (\(String( path ))), trueを返します." )
        return true
    }
    
    do {
        try FileManager.default.createDirectory(atPath: String( path ), 
                                                withIntermediateDirectories: true,
                                                attributes: nil )
        return true
    }
    catch {
        return false
    }
}

/// ディレクトリを削除する
/// - Parameter path: 削除するディレクトリのパス
/// - Returns: true = 成功 or 存在しない, false = 失敗
@discardableResult
public func LCFileRemoveDirectory( _ path:LCStringSmPtr ) -> Bool { 
    if !LCFileExists( path ) {
        LLLogWarning( "成功: 削除対象のディレクトリが見つかりません. (\(String( path ))), trueを返します." )
        return true
    }
    
    do {
        var ret:Bool = true
        let files:LCStringArraySmPtr = LCPathEnumerateFiles( path, LCStringArrayMake() )
        
        for i:Int in 0 ..< LCStringArrayCount( files ) {
            let file_name:LCStringSmPtr = LCStringArrayAt( files, i )
            if !LCFileRemove( LCStringJoin( LCStringJoin( path, LCStringMakeWithCChars( "/" ) ), file_name ) ) {
                ret = false
                break
            }
        }
        
        // remove directories (recersive process)
        let directories:LCStringArraySmPtr = LCPathEnumerateDirectories( path )
        for i:Int in 0 ..< LCStringArrayCount( directories ) {
            let dir_path:LCStringSmPtr = LCStringArrayAt( directories, i )
            if !LCFileRemoveDirectory( LCStringJoin( LCStringJoin( path, dir_path ), LCStringMakeWithCChars( "/" ) ) ) {
                ret = false
                break
            }
        }
        
        if !ret { return false }
        
        try FileManager.default.removeItem( atPath: String( path ) )
        return true
    }
    catch {
        LLLogWarning( "失敗: ディレクトリの削除に失敗しました. (\(error.localizedDescription))" )
        return false
    }
}

/// ディレクトリを移動する
/// - Parameters:
///   - from_path: 移動元ディレクトリパス
///   - to_path: 移動先ディレクトリパス
/// - Returns: true = 成功, false = 失敗 or 移動先にすでにディレクトリがある
@discardableResult
public func LCFileMoveDirectory( _ from_path:LCStringSmPtr, _ to_path:LCStringSmPtr ) -> Bool {
    do {
        if !LCFileExists( from_path ) {
            LLLogWarning( "失敗: from_pathのディレクトリが見つかりません. (\(String( from_path )))" )
            return false
        }
        
        if LCFileExists( to_path ) {
            LLLogWarning( "失敗: to_pathのディレクトリはすでに存在しています. (\(String( to_path )))" )
            return false
        }
        
        try FileManager.default.moveItem( atPath: String( from_path ), toPath: String( to_path ) )
        return true
    }
    catch {
        LLLogWarning( "失敗: ディレクトリの移動に失敗しました. (\(error.localizedDescription))" )
        return false
    }
}

/// ディレクトリをコピーする
/// - Parameters:
///   - from_path: コピー元ディレクトリパス
///   - to_path: コピー先ディレクトリパス
/// - Returns: true = 成功, false = 失敗 or 移動先にすでにディレクトリがある
@discardableResult
public func LCFileCopyDirectory( _ from_path:LCStringSmPtr, _ to_path:LCStringSmPtr ) -> Bool {
    do {
        if !LCFileExists( from_path ) {
            LLLogWarning( "失敗: from_pathのディレクトリが見つかりません. (\(String( from_path )))" )
            return false
        }
        
        if LCFileExists( to_path ) {
            LLLogWarning( "失敗: to_pathのディレクトリはすでに存在しています. (\(String( to_path )))" )
            return false
        }
        
        try FileManager.default.copyItem( atPath: String( from_path ), toPath: String( to_path ) )
        return true
    }
    catch {
        LLLogWarning( "失敗: ディレクトリのコピーに失敗しました. (\(error.localizedDescription))" )
        return false
    }
}
