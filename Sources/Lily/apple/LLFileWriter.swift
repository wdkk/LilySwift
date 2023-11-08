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

/// ファイル書き込みモジュール
open class LLFileWriter
{
    /// LilyCoreオブジェクト
    fileprivate var fw:LCFileWriterSmPtr

    /// pathを指定してファイル書き込みオブジェクトを作成する
    /// - Parameters:
    ///   - path: 書き込むファイルパス
    ///   - mode: 追記モード = true, 新規書き込みモード = false
    public init( path:String, added mode:Bool = false ) { 
        fw = LCFileWriterMake( path.lcStr, mode )
    }
    
    /// ファイル読み込みオブジェクトがアクティブかどうかを取得する
    public var isActive:Bool { return LCFileWriterIsActive( fw ) }

    /// binのポインタの内容をファイルに書き込む
    /// - Parameters:
    ///   - bin: 書き込み元ポインタ
    ///   - length: 書き込み長さ(バイト)
    /// - Returns: 書き込み成功 = true, 失敗 = false
    @discardableResult
    open func write( _ bin:LLNonNullUInt8Ptr, length:LLInt64 ) -> Bool { 
        return LCFileWriterWrite( fw, bin, length )
    }
    
    /// LilyCore文字列をファイルに書き込む
    /// - Parameters:
    ///   - lcStr: 書き込むLilyCore文字列
    /// - Returns: 書き込み成功 = true, 失敗 = false
    @discardableResult
    open func write( _ lcStr:LCStringSmPtr ) -> Bool {
        return LCFileWriterWriteText( fw, lcStr )
    }
    
    /// Swift文字列をファイルに書き込む
    /// - Parameters:
    ///   - str: 書き込む文字列
    /// - Returns: 書き込み成功 = true, 失敗 = false
    @discardableResult
    open func write( _ str:String ) -> Bool { 
        return write( str.lcStr )
    }
}

