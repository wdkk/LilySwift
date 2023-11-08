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

public class LCImageLoaderInternal
{
    public init() {}
}

/// 画像ロードモジュール
public class LCImageLoaderSmPtr
{
    /// 内部オブジェクト
    var loader:LCImageLoaderInternal
    
    /// 初期化
    init() { loader = LCImageLoaderInternal() }
}
