//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal
import MetalKit
import simd

extension Lily.Stage
{
    public enum BufferFormats
    {
        public static let backBuffer:MTLPixelFormat = .bgra8Unorm_srgb
        
        public static let particleBuffer:MTLPixelFormat = .bgra8Unorm
        
        public static let GBuffer0:MTLPixelFormat = .bgra8Unorm_srgb
        public static let GBuffer1:MTLPixelFormat = .rgba8Unorm
        public static let GBuffer2:MTLPixelFormat = .rgba8Unorm
        public static let GBufferDepth:MTLPixelFormat = .r32Float
        public static let depth:MTLPixelFormat = .depth32Float_stencil8
        public static let shadowDepth:MTLPixelFormat = .depth32Float_stencil8
        public static let sampleCount:Int = 1
    }
}
