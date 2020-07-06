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
import MetalKit

public class LLMetalSampler
{
    static public var `default` : MTLSamplerState {
        // descriptorを作ってそこからsamplerを生成
        let sampler = MTLSamplerDescriptor()
        sampler.minFilter             = MTLSamplerMinMagFilter.nearest
        sampler.magFilter             = MTLSamplerMinMagFilter.nearest
        sampler.mipFilter             = MTLSamplerMipFilter.nearest
        sampler.maxAnisotropy         = 1
        sampler.sAddressMode          = MTLSamplerAddressMode.clampToEdge   // width
        sampler.tAddressMode          = MTLSamplerAddressMode.clampToEdge   // height
        sampler.rAddressMode          = MTLSamplerAddressMode.clampToEdge   // depth
        sampler.normalizedCoordinates = true
        sampler.lodMinClamp           = 0
        sampler.lodMaxClamp           = Float.greatestFiniteMagnitude
        
        return LLMetalManager.shared.device!.makeSamplerState(descriptor: sampler)!
    }
}
