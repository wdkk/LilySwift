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

/// ファイル読み込みの内部実装クラス
fileprivate class LCFileReaderInternal
{  
    /// 入力ストリーム
    private var _istream:InputStream?
    
    /// パスで指定したファイルで初期化しファイル読み込みオブジェクトを作成
    /// - Parameter path: ファイルパス
    /// - Description: 読み込みに失敗した場合ストリームを閉じたオブジェクトを返す
    init( path:LCStringSmPtr ) {
        guard let istream = InputStream( fileAtPath: String( path ) ) else {
            LLLogWarning( "ファイルの読み込みに失敗しました. (\(path))" )
            _istream = nil
            return
        }

        _istream = istream
        _istream?.open()
    }
    
    /// 解放時処理
    deinit {
        end()
    }

    /// 読み込み状態を返す
    /// - Description: true = 読み込み中, false = 停止中
    var isActive:Bool {
        guard let istrm = _istream else { return false }
        return istrm.streamStatus == .open || istrm.streamStatus == .opening || istrm.streamStatus == .reading
    }

    /// ストリームがファイル終端にたどり着いたかを返す
    /// - Description: true = 終端 or 閉じている or 開いていない, false = 終端ではない
    var isEOF:Bool { 
        guard let istrm = _istream else { return true }
        return istrm.streamStatus == .atEnd || istrm.streamStatus == .closed || istrm.streamStatus == .notOpen
    }

    /// ファイルの読み込みを終了する
    @discardableResult
    func end() -> Bool {
        if !isActive { return false }
        _istream?.close()
        return true
    }

    /// ファイルを読み込む
    /// - Parameters:
    ///   - bin: 読み込み先のポインタ
    ///   - length: 読み込む長さ(バイト)
    /// - Returns: true = 成功, false = 失敗
    func read( _ bin:LLNonNullUInt8Ptr, _ length:LLInt64 ) -> Bool {
        if !isActive { return false }
        guard let leng = length.i else { return false }
        
        let result = _istream?.read( bin, maxLength: leng )
        if result == -1 {
            LLLogWarning( "InputStreamエラー" )
            return false
        }
        
        return true
    }
}

/// ファイル読み込みモジュール
public class LCFileReaderSmPtr
{
    /// 内部オブジェクト
    fileprivate var fri:LCFileReaderInternal
    
    /// ファイルパスで初期化
    /// - Parameter path: 対象のファイルパス
    fileprivate init( path:LCStringSmPtr ) {
        fri = LCFileReaderInternal( path:path )
    }
}

/// ファイル読み込みオブジェクトを作成
/// - Parameter file_path: ファイルパス
/// - Returns: ファイル読み込みオブジェクト
/// - Description: 読み込みの成功可否は戻り値のisActiveで確認
public func LCFileReaderMake( _ file_path:LCStringSmPtr ) -> LCFileReaderSmPtr {
    return LCFileReaderSmPtr( path:file_path )
}

/// ファイル読み込みオブジェクトが読み込み可能か確認する
/// - Parameter reader: ファイル読み込みオブジェクト
/// - Returns: true = 読み込み可能, false = 読み込み不可(閉じている, 読み込みが完了しているなど)
public func LCFileReaderIsActive( _ reader:LCFileReaderSmPtr ) -> Bool {
    return reader.fri.isActive
}

/// ファイル読み込みオブジェクトを用いてファイルを読み込む
/// - Parameters:
///   - reader: ファイル読み込みオブジェクト
///   - bin: 読み込み先のメモリポインタ
///   - length: 読み込む長さ(バイト)
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileReaderRead( _ reader:LCFileReaderSmPtr, _ bin:LLNonNullUInt8Ptr, _ length:LLInt64 ) -> Bool {
    return reader.fri.read( bin, length )
}

/// ファイル読み込みオブジェクトの読み込みを終了する
/// - Parameters:
///   - reader: ファイル読み込みオブジェクト
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileReaderEnd( _ reader:LCFileReaderSmPtr ) -> Bool {
    return reader.fri.end()
}
