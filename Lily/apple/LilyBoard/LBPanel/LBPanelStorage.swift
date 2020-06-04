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
    public var metalVertex = LLMetalQuadrangles<LBActorVertex>()
    public var atlas:LBTextureAtlas?    // .pictureのみで利用
    public var texture:MTLTexture?      // .textureのみで利用
    
    // Metalエンコーダ描画の関数
    public override func draw( encoder:MTLRenderCommandEncoder, index:Int ) {
        let sorted_params = self.params.sorted { 
            // zIndexの並びで描画する
            $0.zindex < $1.zindex
        }
        
        for param in sorted_params {
            let i = param.arrayIndex
            encoder.drawPrimitives( type: .triangleStrip, vertexStart: i * 4, vertexCount: 4 )
        }
    }

    public override func reuse() -> Int? {
        let trushes = params.filter { $0.state == .trush }
        guard let trush = trushes.first else { return nil }
        return trush.arrayIndex
    }
    
    // パネルデータを要求する
    public override func request() -> Int {        
        let quad_v = LLQuad<LBActorVertex>(
            LBActorVertex( xy:LLFloatv2( -1.0,  1.0 ), uv:LLFloatv2( 0.0, 0.0 ) ),
            LBActorVertex( xy:LLFloatv2(  1.0,  1.0 ), uv:LLFloatv2( 1.0, 0.0 ) ),
            LBActorVertex( xy:LLFloatv2( -1.0, -1.0 ), uv:LLFloatv2( 0.0, 1.0 ) ),
            LBActorVertex( xy:LLFloatv2(  1.0, -1.0 ), uv:LLFloatv2( 1.0, 1.0 ) )
        )
        // Quadranglesの描画処理を書き換え
        metalVertex.drawFunc = self.draw
        
        var pp = LBActorParam()

        if let reuse_idx = reuse() {
            pp.arrayIndex = reuse_idx
            
            // 再利用
            metalVertex.vertice[reuse_idx] = quad_v
            params[reuse_idx] = pp
            return reuse_idx
        }
        
        let new_index:Int = metalVertex.count
        pp.arrayIndex = new_index
        
        // 追加
        metalVertex.append( quad_v )
        params.append( pp )
        
        return new_index
    }
}
