//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import CoreGraphics
import Metal

open class LBObjectPipelineManager
{
    public static let shared:LBObjectPipelineManager = LBObjectPipelineManager()  
    private init() {}
    
    public var pipelines:[String:LBObjectPipelineProtocol] = [:]
    
    // オブジェクトパイプラインの追加登録
    public func add<TObjPL:LBObjectPipelineProtocol>( objpl:TObjPL ) -> TObjPL {
        pipelines[objpl.keyLabel] = objpl
        return pipelines[objpl.keyLabel] as! TObjPL
    }
    
    // オブジェクトパイプラインの登録削除
    public func remove( label:String ) {
        pipelines.removeValue(forKey: label )
    }
    
    public func compute( encoder:MTLComputeCommandEncoder ) {
        for (_, objpl) in pipelines {
            encoder.use( objpl.compute_pipeline ) {
                // オブジェクトパイプラインのコンピュート処理をながす
                objpl.compute( $0 )
            }
        }
    }
    
    public func render( encoder:MTLRenderCommandEncoder, screenSize size:LLSize ) {
        // プロジェクション行列を画面のピクセルサイズ変換に指定
        let sz:CGSize = CGSize( size.width, size.height )
        
        var proj_matrix:LLMatrix4x4 = .pixelXYProjection( sz )
        
        // TODO: Z-Indexオーダーに切り替えたい
        // オブジェクトパイプラインをすべてスキャンしてlayerの順番に並べ替える
        let sorted_pipelines = LBObjectPipelineManager.shared.pipelines.sorted { 
            $0.value.layerIndex < $1.value.layerIndex
        }
        
        for (_, objpl) in sorted_pipelines {
            // 描画
            encoder.use( objpl.render_pipeline ) {
                // 共通のプロジェクション行列
                $0.setVertexBytes( &proj_matrix, length: 64, index: 0 )
                // オブジェクトパイプラインの処理を流す
                objpl.render( $0 )
            }
        }
    }
}
