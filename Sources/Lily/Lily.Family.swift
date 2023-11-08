//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import simd

open class Lily
{
    // View(AppKit/UIKit)のモジュールセット
    open class View
    {
    }
    
    // SwiftUIのモジュールセット
    open class UI
    {
    }
    
    // Metalのモジュールセット
    open class Metal
    {
    }
    
    // 3Dグラフィック系のモジュールセット
    open class Stage 
    {
        // Swift<->Metalの共有モジュール
        open class Shared { }
        // モデルデータ系のモジュール
        open class Model { }
    }
    
    // フィールドモジュールセット
    open class Field
    {
    }
}
