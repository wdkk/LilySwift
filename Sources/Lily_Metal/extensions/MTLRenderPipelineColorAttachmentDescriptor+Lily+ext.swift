//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

/// コメント未済

import Foundation
import Metal

extension MTLRenderPipelineColorAttachmentDescriptor
{
    public enum BlendType : Int
    {
        case none
        case alphaBlend
        case add
        case sub
        case max
        case min
    }
    
    public func composite( type:BlendType )
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
            self.destinationAlphaBlendFactor = .one
            break
        // 加算合成
        case .add:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .add
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .one
            // 合成先データ = 1+(1-α)
            self.destinationRGBBlendFactor = .one
            self.destinationAlphaBlendFactor = .one
            break
        // 減算合成
        case .sub:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .reverseSubtract
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .one
            // 合成先データ = 1-(1-α)
            self.destinationRGBBlendFactor = .one
            self.destinationAlphaBlendFactor = .one
            break
        // 最大値合成
        case .max:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .max
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .one
            // 合成先データ = 1-α
            self.destinationRGBBlendFactor = .one
            self.destinationAlphaBlendFactor = .one
            break
        // 最小値合成
        case .min:
            self.isBlendingEnabled = true
            // 2値の加算方法
            self.rgbBlendOperation = .min
            self.alphaBlendOperation = .add
            // 入力データ = α
            self.sourceRGBBlendFactor = .sourceAlpha
            self.sourceAlphaBlendFactor = .one
            // 合成先データ = 1-α
            self.destinationRGBBlendFactor = .one
            self.destinationAlphaBlendFactor = .one
            break
        }
    }
}

#endif
