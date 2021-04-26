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

import Foundation
import Metal

/// Metal描画パイプライン
public class LLMetalRenderPipeline
{
    // パイプラインの状態情報
    public private(set) var state:MTLRenderPipelineState?
    
    public init() {}
    
    // パイプラインの作成関数
    public func make( _ f:( inout LLMetalRenderSetting )->() ) {
        // 設定オブジェクトの作成
        var setting = LLMetalRenderSetting()
        // コールバックで設定を行う
        f( &setting )
        // 設定を用いてパイプライン記述を作成
        let rpd = makeRenderPipelineDesc( setting:setting )
        // パイプラインの作成
        self.makePipeline( rpd )
    }
    
    public func makeRenderPipelineDesc( setting:LLMetalRenderSetting ) -> MTLRenderPipelineDescriptor {
        // パイプラインディスクリプタの作成
        let rpd = MTLRenderPipelineDescriptor()
        rpd.vertexFunction = setting.vertexShader.function
        rpd.fragmentFunction = setting.fragmentShader.function
        // パイプラインディスクリプタのデプス・ステンシル情報を設定
        rpd.vertexDescriptor = setting.vertexDesc
        rpd.sampleCount = setting.depthState.sampleCount
        rpd.depthAttachmentPixelFormat = setting.depthState.depthFormat
        rpd.stencilAttachmentPixelFormat = setting.depthState.depthFormat
        // 色設定
        rpd.colorAttachments[0] = setting.colorAttachment
        
        return rpd
    }
    
    public func makePipeline( _ rpd:MTLRenderPipelineDescriptor ) {
        // パイプラインの生成
        do {
            state = try LLMetalManager.shared.device?.makeRenderPipelineState( descriptor: rpd )
        }
        catch {
            print( error.localizedDescription )
        }
    }
}

public extension MTLRenderCommandEncoder
{
    func use( _ pipeline:LLMetalRenderPipeline, _ drawFunc:( MTLRenderCommandEncoder )->() ) {
        guard let pipeline_state = pipeline.state else { return }
        // エンコーダにパイプラインを指定
        self.setRenderPipelineState( pipeline_state )
        // 描画関数を実行
        drawFunc( self )
    }
}
