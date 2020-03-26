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
import QuartzCore

open class LLMetalDepthTexture
{
    /// Metalデプス情報
    public private(set) var depthState = LLMetalDepthState()
    public private(set) var depthTexture:MTLTexture?

    public init() { }
    
    private func makeDepthTextureDescriptor( drawable:CAMetalDrawable, depthState:LLMetalDepthState )
    -> MTLTextureDescriptor 
    {
        // depthテクスチャの設定（デプスとステンシルを合わせもつテクスチャ）
        let depth_desc:MTLTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: depthState.depthFormat,
            width: drawable.texture.width,
            height: drawable.texture.height,
            mipmapped: false )
        depth_desc.textureType = (depthState.sampleCount > 1) ? .type2DMultisample : .type2D
        depth_desc.sampleCount = depthState.sampleCount
        depth_desc.usage = .renderTarget
        depth_desc.storageMode = .private                   // 追加: macOS対応
        depth_desc.resourceOptions = .storageModePrivate    // 追加: macOS対応
        return depth_desc
    }
    
    /// デプステクスチャの作成
    public func makeDepthTexture( depthDesc:MTLTextureDescriptor, depthState:LLMetalDepthState ) {
        // まだテクスチャメモリが生成されていない場合、もしくはサイズが変更された場合、新しいテクスチャを生成する
        if depthTexture == nil || 
            depthTexture!.width != depthDesc.width ||
            depthTexture!.height != depthDesc.height
        {
            depthTexture = LLMetalManager.device?.makeTexture( descriptor: depthDesc )
        }
    }
    
    /// デプステクスチャの設定と再生成
    public func updateDepthTexture( drawable:CAMetalDrawable ) {
        // デプステクスチャディスクリプタの設定
        let depth_desc = makeDepthTextureDescriptor( drawable:drawable, depthState:depthState )
        // デプステクスチャの作成
        makeDepthTexture( depthDesc:depth_desc, depthState:depthState )
    }
}
