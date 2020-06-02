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
import Metal

open class LBPanelStorage : LBActorStorage
{
    public var quads = LLMetalQuadrangles<LBPanelVertex>()
    public var params = [LBPanelParam]()
    public var atlas:LBTextureAtlas?    // .pictureのみで利用
    public var texture:MTLTexture?      // .textureのみで利用
    
    // Metalエンコーダ描画の関数
    private func draw( encoder:MTLRenderCommandEncoder, index:Int ) {
        let sorted_params = self.params.sorted { 
            // zIndexの並びで描画する
            $0.zindex < $1.zindex
        }
        
        for param in sorted_params {
            let i = param.arrayIndex
            encoder.drawPrimitives( type: .triangleStrip, vertexStart: i * 4, vertexCount: 4 )
        }
    }

    private func reuse() -> Int? {
        let trushes = params.filter { $0.state == .trush }
        guard let trush = trushes.first else { return nil }
        return trush.arrayIndex
    }
    
    // パネルデータを要求する
    public func request() -> Int {        
        let quad_v = LLQuad<LBPanelVertex>(
            LBPanelVertex( xy:LLFloatv2( -1.0,  1.0 ), uv:LLFloatv2( 0.0, 0.0 ) ),
            LBPanelVertex( xy:LLFloatv2(  1.0,  1.0 ), uv:LLFloatv2( 1.0, 0.0 ) ),
            LBPanelVertex( xy:LLFloatv2( -1.0, -1.0 ), uv:LLFloatv2( 0.0, 1.0 ) ),
            LBPanelVertex( xy:LLFloatv2(  1.0, -1.0 ), uv:LLFloatv2( 1.0, 1.0 ) )
        )
        // Quadranglesの描画処理を書き換え
        quads.drawFunc = self.draw
        
        var pp = LBPanelParam()

        if let reuse_idx = reuse() {
            pp.arrayIndex = reuse_idx
            
            // 再利用
            quads.vertice[reuse_idx] = quad_v
            params[reuse_idx] = pp
            return reuse_idx
        }
        
        let new_index:Int = quads.count
        pp.arrayIndex = new_index
        
        // 追加
        quads.append( quad_v )
        params.append( pp )
        
        return new_index
    }
}
