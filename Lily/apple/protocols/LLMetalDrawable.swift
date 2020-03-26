//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Metal

/// Metal描画プロトコル
public protocol LLMetalDrawable
{
    func draw( with encoder:MTLRenderCommandEncoder, index idx:Int )
}

/// LLMetalDrawableに対応したMTLRenderCommandEncoder拡張
public extension MTLRenderCommandEncoder
{
    func drawShape( _ shape:LLMetalDrawable, index idx:Int = 0 ) {
        shape.draw( with:self, index:idx )
    }
}
