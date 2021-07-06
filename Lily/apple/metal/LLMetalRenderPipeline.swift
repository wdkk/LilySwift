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
    
    public func make( _ fn:( inout MTLRenderPipelineDescriptor )->() ) {
        // パイプラインディスクリプタをデフォルト設定で作成
        var rp_desc = MTLRenderPipelineDescriptor.default
        // コールバックで設定の上書きを行う
        fn( &rp_desc )
        // パイプラインの作成
        self.makePipeline( rp_desc )        
    }
    
    private func makePipeline( _ rpd:MTLRenderPipelineDescriptor ) {
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
