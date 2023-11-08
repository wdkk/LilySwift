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

public class LCImageSaverInternal
{
    public init() {}
}

/// 画像セーブモジュール
public class LCImageSaverSmPtr
{
    /// 内部オブジェクト
    var saver:LCImageSaverInternal
    
    /// 初期化
    init() { saver = LCImageSaverInternal() }
}
