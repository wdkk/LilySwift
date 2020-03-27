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

/// ファイル書き込みの内部実装クラス
fileprivate class LCFileWriterInternal
{
    /// 出力ストリーム
    var _ostream:OutputStream?
    /// 書き込み対象のパス
    var _file_path:LCStringSmPtr
    /// ロールバック用保管ファイルのテンポラリパス
    var _tmp_path:LCStringSmPtr
    /// テンポラリファイルの存在フラグ
    var _exists_tmp_file:Bool
    
    /// パスで指定したファイルで初期化しファイル書き込みオブジェクトを作成
    /// - Parameters:
    ///   - path: ファイルパス
    ///   - is_add_mode: 追記モード(true = 追記, false = 上書き)
    /// - Description: オープンに失敗した場合ストリームを閉じたオブジェクトを返す
    /// - Note: ファイル書き込み開始時にロールバックを可能にするため元ファイルをテンポラリに退避する仕組み
    init( _ path:LCStringSmPtr, _ is_add_mode:Bool ) {
        _file_path = LCStringMake( path )
        _tmp_path = LCStringJoin( path, LCStringMakeWithCChars( "_tmp@LilyRollback" ) )

        if LCFileExists( _file_path ) {
            _exists_tmp_file = LCFileCopy( _file_path, _tmp_path )
        }
        else {
            _exists_tmp_file = false
        }
        
        guard let ostream = OutputStream( toFileAtPath: String( path ), append: is_add_mode ) else {
            _ostream = nil
            return
        }
        
        _ostream = ostream
        _ostream?.open()
    }
    
    /// 解放時処理
    deinit {
        end()
    }

    /// 書き込み状態を返す
    /// - Description: true = 書き込み中, false = 停止中
    var isActive:Bool {
        guard let ostrm = _ostream else { return false }
        return ostrm.streamStatus == .open || ostrm.streamStatus == .opening || ostrm.streamStatus == .writing
    }
    
    /// ファイルの書き込みを終了する
    @discardableResult
    func end() -> Bool {
        if !isActive { return false }

        _ostream?.close()
        
        if _exists_tmp_file {
            LCFileRemove( _tmp_path )
        }

        _exists_tmp_file = false

        return true
    }

    /// ファイルの書き込みなどに失敗した時, 書き込み前のファイルの状態に復元する
    /// - Returns: true = 成功, false = 失敗
    func rollback() -> Bool {
        if !isActive { return false }

        _ostream?.close()
        
        LCFileRemove( _file_path )

        if !_exists_tmp_file {
            LCFileMove( _tmp_path, _file_path )
        }
        
        _exists_tmp_file = false
        return true
    }

    /// ファイルにデータを書き込む
    /// - Parameters:
    ///   - bin: 書き込むデータのポインタ
    ///   - length: 書き込む長さ(バイト)
    /// - Returns: true = 成功, false = 失敗
    func write( _ bin:LLNonNullUInt8Ptr, _ length:LLInt64 ) -> Bool {
        if !isActive { return false }
        if length < 1 { return false }
        guard let leng = length.i else { return false }
        
        _ostream?.write( bin, maxLength: leng )
        return true
    }
}

/// ファイル書き込みモジュール
public class LCFileWriterSmPtr
{
    /// 内部オブジェクト
    fileprivate var fwi:LCFileWriterInternal
    
    /// ファイルパスで初期化
    /// - Parameters:
    ///   - path: 対象のファイルパス
    ///   - add_mode: 追記モード(true = 追記, false = 上書き)
    fileprivate init( path:LCStringSmPtr, add_mode:Bool ) {
        fwi = LCFileWriterInternal( path, add_mode )
    }
}

/// ファイル書き込みオブジェクトを作成
/// - Parameters:
///   - file_path: ファイルパス
///   - is_add_mode: 追記モード( true = 追記, false = 上書き)
/// - Returns: ファイル書き込みオブジェクト
/// - Description: 書き込みの成功可否は戻り値のisActiveで確認
public func LCFileWriterMake( _ file_path:LCStringSmPtr, _ is_add_mode:Bool ) -> LCFileWriterSmPtr {
    return LCFileWriterSmPtr( path:file_path, add_mode:is_add_mode )
}

/// ファイル書き込みオブジェクトが書き込み可能か確認する
/// - Parameter writer: ファイル書き込みオブジェクト
/// - Returns: true = 書き込み可能, false = 書き込み不可(閉じている, 書き込みが完了しているなど)
public func LCFileWriterIsActive( _ writer:LCFileWriterSmPtr ) -> Bool {
    return writer.fwi.isActive
}

/// ファイル書き込みオブジェクトを用いてデータを書き込む
/// - Parameters:
///   - writer: ファイル書き込みオブジェクト
///   - bin: 書き込み元のポインタ
///   - length: 書き込みする長さ(バイト)
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileWriterWrite( _ writer:LCFileWriterSmPtr, _ bin:LLNonNullUInt8Ptr, _ length:LLInt64 ) -> Bool {
    return writer.fwi.write( bin, length )
}

/// ファイル書き込みオブジェクトを用いてC文字列を書き込む
/// - Parameters:
///   - writer: ファイル書き込みオブジェクト
///   - chars: 文字列データポインタ
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileWriterWriteChars( _ writer:LCFileWriterSmPtr, _ chars:LLConstCharPtr ) -> Bool {
    let opaque_ptr = OpaquePointer( chars )
    guard let cchars_ptr = LLConstCCharsPtr( opaque_ptr ) else { return false }
    let str = LCStringMakeWithCChars( cchars_ptr )
    let length = LCStringByteLength( str )
    
    guard let nnui8ptr = LLNonNullUInt8Ptr( opaque_ptr ) else { return false }
    return writer.fwi.write( nnui8ptr, length.i64 )
}

/// ファイル書き込みオブジェクトを用いてテキストを書き込む
/// - Parameters:
///   - writer: ファイル書き込みオブジェクト
///   - cstr: 書き込むLilyCore文字列オブジェクト
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileWriterWriteText( _ writer:LCFileWriterSmPtr, _ cstr:LCStringSmPtr ) -> Bool {
    //let opaque_ptr = OpaquePointer( LCStringToCChars( cstr ) )
    //let nnui8ptr = LLNonNullUInt8Ptr( opaque_ptr )
    let nnui8ptr = unsafeBitCast( LCStringToCChars( cstr ), to: LLNonNullUInt8Ptr.self )
    return writer.fwi.write( nnui8ptr, LCStringByteLength( cstr ).i64 )
}

/// ファイル書き込みオブジェクトの書き込みを完了する
/// - Parameters:
///   - writer: ファイル書き込みオブジェクト
/// - Returns: true = 成功, false = 失敗
@discardableResult
public func LCFileWriterEnd( _ writer:LCFileWriterSmPtr ) -> Bool {
    return writer.fwi.end()
}
