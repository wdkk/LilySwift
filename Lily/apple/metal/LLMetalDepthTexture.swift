//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
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
    public private(set) var depthTexture:MTLTexture?

    public init() { }
    
    private func makeDepthTextureDescriptor( 
        width:Int,
        height:Int,
        depthFormat:MTLPixelFormat, 
        type:MTLTextureType, 
        sampleCount:Int,
        mipmapped:Bool 
    )
    -> MTLTextureDescriptor 
    {
        // depthテクスチャの設定
        let depth_desc:MTLTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
            pixelFormat: depthFormat,
            width: width,
            height: height,
            mipmapped: mipmapped 
        )
        depth_desc.textureType = type
        depth_desc.sampleCount = sampleCount
        depth_desc.usage = .renderTarget
        depth_desc.storageMode = .private                   // 追加: macOS対応
        depth_desc.resourceOptions = .storageModePrivate    // 追加: macOS対応
        return depth_desc
    }
    
    /// デプステクスチャの作成
    public func makeDepthTexture( depthDesc:MTLTextureDescriptor ) {
        // まだテクスチャメモリが生成されていない or サイズが変更された場合、新しいテクスチャを生成する
        if depthTexture == nil || 
            depthTexture!.width != depthDesc.width ||
            depthTexture!.height != depthDesc.height
        {
            depthTexture = LLMetalManager.shared.device?.makeTexture( descriptor: depthDesc )
        }
    }
    
    /// デプステクスチャの設定と再生成
    public func updateDepthTexture( 
        drawable:CAMetalDrawable,
        depthFormat:MTLPixelFormat,
        type:MTLTextureType = .type2D, 
        sampleCount:Int = 1,
        mipmapped:Bool = false 
    )
    {
        // デプステクスチャディスクリプタの設定
        let depth_desc = makeDepthTextureDescriptor( 
            width:drawable.texture.width,
            height:drawable.texture.height,
            depthFormat:depthFormat,
            type:type,
            sampleCount:sampleCount,
            mipmapped: mipmapped
        )
        // デプステクスチャの作成
        makeDepthTexture( depthDesc:depth_desc )
    }
}
