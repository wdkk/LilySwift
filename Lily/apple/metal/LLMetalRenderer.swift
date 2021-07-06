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

open class LLMetalRenderer
{
    static func makeRenderPassDescriptor( 
        drawable:CAMetalDrawable,
        color:LLColor, 
        depthTexture:LLMetalDepthTexture? 
    )
    -> MTLRenderPassDescriptor 
    {
        let r_pass_desc = MTLRenderPassDescriptor()
        // カラーアタッチメントの設定
        r_pass_desc.colorAttachments[0].texture = drawable.texture
        r_pass_desc.colorAttachments[0].loadAction = (color != .clear) ? .clear : .load
        if color != .clear { 
            r_pass_desc.colorAttachments[0].clearColor = color.metalColor
        }
        r_pass_desc.colorAttachments[0].storeAction = .store
        
        if let depth_tex = depthTexture?.depthTexture {
            // デプスの設定
            r_pass_desc.depthAttachment.texture = depth_tex
            r_pass_desc.depthAttachment.loadAction = .clear
            r_pass_desc.depthAttachment.storeAction = .store
            r_pass_desc.depthAttachment.clearDepth = 1.0
            // ステンシルの設定
            r_pass_desc.stencilAttachment.texture = depth_tex
            r_pass_desc.stencilAttachment.loadAction = .clear
            r_pass_desc.stencilAttachment.storeAction = .store
            r_pass_desc.stencilAttachment.clearStencil = 0
        }
        else {
            // デプスの設定
            r_pass_desc.depthAttachment.texture = nil
            // ステンシルの設定
            r_pass_desc.stencilAttachment.texture = nil
        }
        
        return r_pass_desc
    }
     
    /// エンコーダの設定と再生成
    private static func makeEncoder(
        commandBuffer:MTLCommandBuffer,
        drawable:CAMetalDrawable, 
        clearColor:LLColor,
        depthTexture:LLMetalDepthTexture?
    )
    -> MTLRenderCommandEncoder?
    {
        // レンダーパスディスクリプタの設定
        let r_pass_desc = makeRenderPassDescriptor(
            drawable:drawable,
            color:clearColor,
            depthTexture:depthTexture
        )
        // エンコーダ生成
        return commandBuffer.makeRenderCommandEncoder( descriptor: r_pass_desc )
    }
    
    @discardableResult
    public static func render(
        commandBuffer:MTLCommandBuffer,
        drawable: CAMetalDrawable?,
        clearColor:LLColor,
        depthTexture:LLMetalDepthTexture? = nil,
        renderer:( MTLRenderCommandEncoder )->Void
    )
    -> Bool
    {
        guard let drawable = drawable else {
            LLLogWarning( "Metal Drawableが取得できませんでした." )
            return false
        }
            
        guard let encoder = makeEncoder(
            commandBuffer:commandBuffer,
            drawable:drawable,
            clearColor:clearColor,
            depthTexture: depthTexture 
        )
        else {
            LLLogWarning( "RenderCommandEncoderを取得できませんでした." )
            return false 
        }
                
        // 指定された関数オブジェクトの実行
        renderer( encoder )
        
        // エンコーダの終了
        encoder.endEncoding()
        
        // コマンドバッファを画面テクスチャへ反映
        commandBuffer.present( drawable )
        
        return true
    }
}
