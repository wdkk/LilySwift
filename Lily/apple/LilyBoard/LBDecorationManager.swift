//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import CoreGraphics
import Metal

open class LBDecorationManager
{
    public static let shared = LBDecorationManager()  
    private init() {}
    
    public var decorations = [String:LBDecoratable]()
    
    // デコレーションの追加登録
    public func add<TDeco:LBDecoratable>( deco:TDeco ) -> TDeco {
        decorations[deco.keyLabel] = deco
        return decorations[deco.keyLabel] as! TDeco
    }
    
    // デコレーションの登録削除
    public func remove( label:String ) {
        decorations.removeValue(forKey: label )
    }
    
    public func compute( encoder:MTLComputeCommandEncoder ) {
        for (_, deco) in decorations {
            encoder.use( deco.compute_pipeline ) {
                // デコレーションのコンピュート処理をながす
                deco.compute( $0 )
            }
        }
    }
    
    public func render( encoder:MTLRenderCommandEncoder, size:LLSize ) {
        // プロジェクション行列を画面のピクセルサイズ変換に指定
        let sz = CGSize( size.width, size.height )
        
        var proj_matrix:LLMatrix4x4 = .pixelXYProjection( sz )
        
        // デコレーションをすべてスキャンしてlayerの順番に並べ替える
        let sorted_decorations = LBDecorationManager.shared.decorations.sorted { 
            $0.value.layerIndex < $1.value.layerIndex
        }
        
        for (_, deco) in sorted_decorations {
            // 描画
            encoder.use( deco.render_pipeline ) {
                // 共通のプロジェクション行列
                $0.setVertexBytes( &proj_matrix, length: 64, index: 0 )
                // デコレーションの処理を流す
                deco.render( $0 )
            }
        }
    }
}
