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

public class LBTriangleStorage : LBActorStorage
{
    public var metalVertex = LLMetalTriangles<LBActorVertex>()
    public var atlas:LLMetalTextureAtlas?    // .pictureのみで利用
    public var texture:MTLTexture?      // .textureのみで利用
    
    // トライアングルデータを要求する
    public override func request() -> Int {        
        let tri_v = LLTriple<LBActorVertex>(
            // 正三角形
            LBActorVertex( xy:LLFloatv2(  0.0,  1.15470053838 ), uv:LLFloatv2(  0.0,  1.0 ) ),
            LBActorVertex( xy:LLFloatv2( -1.0, -0.57735026919 ), uv:LLFloatv2( -1.0,  1.0 ) ),
            LBActorVertex( xy:LLFloatv2(  1.0, -0.57735026919 ), uv:LLFloatv2(  1.0, -1.0 ) )
        )
   
        var tp = LBActorParam()

        if let reuse_idx = reuse() {
            tp.arrayIndex = reuse_idx
            metalVertex.vertice[reuse_idx] = tri_v
            params.accessor![reuse_idx] = tp
            return reuse_idx
        }
        
        tp.arrayIndex = metalVertex.count
        
        // 追加
        metalVertex.append( tri_v )
        params.append( tp )
        
        return tp.arrayIndex
    }
}
