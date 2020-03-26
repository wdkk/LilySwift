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

/// ファイル読み込みモジュール
open class LLFileReader
{
    /// LilyCoreオブジェクト
    fileprivate var fr:LCFileReaderSmPtr
	
    /// 指定したパスのファイルでファイル読み込みオブジェクトを作成する
    /// - Parameter path: 読み込むファイルパス
    public init( path:String ) {
        fr = LCFileReaderMake( path.lcStr )
    }
	
    /// ファイル読み込みオブジェクトがアクティブかどうかを取得する
	public var isActive:Bool { 
        return LCFileReaderIsActive( fr )
    }
    
    /// 前回読み終わった位置から指定したbinポインタにlengthの長さのバイト列を読み込む
    /// - Parameters:
    ///   - bin: 読み込み先ポインタ
    ///   - length: 長さ(バイト)
    /// - Returns: 読み込み成功 = true, 失敗 = false
    open func read( _ bin:LLNonNullUInt8Ptr, length:LLInt64 ) -> Bool { 
        return LCFileReaderRead( fr, bin, length )
    }
}


