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

open class LBTriangleStorage : LBActorStorage
{
    public var tris = LLMetalTriangles<LBTriangleVertex>()
    public var params = [LBTriangleParam]()
    public var atlas:LBTextureAtlas?    // .pictureのみで利用
    public var texture:MTLTexture?      // .solotexのみで利用
    
    // Metalエンコーダ描画の関数
    private func draw( encoder:MTLRenderCommandEncoder, index:Int ) {
        let sorted_params = self.params.sorted { 
            // zIndexの並びで描画する
            $0.zindex < $1.zindex
        }
        
        for param in sorted_params {
            let i = param.arrayIndex
            encoder.drawPrimitives( type: .triangle, vertexStart: i * 3, vertexCount: 3 )
        }
    }

    private func reuse() -> Int? {
        let trushes = params.filter { $0.state == .trush }
        guard let trush = trushes.first else { return nil }
        return trush.arrayIndex
    }
    
    // トライアングルデータを要求する
    public func request() -> Int {        
        let tri_v = LLTriple<LBTriangleVertex>(
            LBTriangleVertex( xy:LLFloatv2(  0.0,  1.0 ), uv:LLFloatv2(  0.0,  1.0 ) ),
            LBTriangleVertex( xy:LLFloatv2( -1.0, -1.0 ), uv:LLFloatv2( -1.0,  1.0 ) ),
            LBTriangleVertex( xy:LLFloatv2(  1.0, -1.0 ), uv:LLFloatv2(  1.0, -1.0 ) )
        )
        // Trianglesの描画処理を書き換え
        tris.drawFunc = self.draw
        
        var tp = LBTriangleParam()

        if let reuse_idx = reuse() {
            tp.arrayIndex = reuse_idx
            // 再利用
            tris.vertice[reuse_idx] = tri_v
            params[reuse_idx] = tp
            return reuse_idx
        }
        
        let new_index:Int = tris.count
        tp.arrayIndex = new_index
        
        // 追加
        tris.append( tri_v )
        params.append( tp )
        
        return new_index
    }
}
