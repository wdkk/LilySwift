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

public extension MTLRenderPipelineColorAttachmentDescriptor
{
    func composite( type:LLMetalBlendType )
    {
        switch type {
        // 合成なし
        case .none:
            self.isBlendingEnabled = false
            break
        // 通常のアルファブレンディング
        case .alphaBlend:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .add
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .sourceAlpha
            // 合成先データ = 1-α
            self.destinationRGBBlendFactor = .oneMinusSourceAlpha
            self.destinationAlphaBlendFactor = .oneMinusSourceAlpha
            break
        // 加算合成
        case .add:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .add
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .sourceAlpha
            // 合成先データ = 1-α
            self.destinationRGBBlendFactor = .one
            self.destinationAlphaBlendFactor = .oneMinusSourceAlpha
            break
        }
    }
}
