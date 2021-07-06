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
import Metal

open class LBPanelStorage : LBActorStorage
{
    public var metalVertex = LLMetalQuadrangles<LBActorVertex>()
    public var atlas:LLMetalTextureAtlas?    // .pictureのみで利用
    public var texture:MTLTexture?      // .textureのみで利用
        
    // パネルデータを要求する
    public override func request() -> Int {        
        let quad_v = LLQuad<LBActorVertex>(
            LBActorVertex(
                xy:LLFloatv2( -1.0,  1.0 ),
                uv:LLFloatv2( 0.0, 0.0 ) 
            ),
            LBActorVertex( 
                xy:LLFloatv2(  1.0,  1.0 ), 
                uv:LLFloatv2( 1.0, 0.0 )
            ),
            LBActorVertex( 
                xy:LLFloatv2( -1.0, -1.0 ),
                uv:LLFloatv2( 0.0, 1.0 ) 
            ),
            LBActorVertex( 
                xy:LLFloatv2(  1.0, -1.0 ),
                uv:LLFloatv2( 1.0, 1.0 )
            )
        )
        
        var pp = LBActorParam()

        // 再利用
        if let reuse_idx = reuse() {
            pp.arrayIndex = reuse_idx
            metalVertex.vertice[reuse_idx] = quad_v
            params.accessor![reuse_idx] = pp
            return reuse_idx
        }
        
        pp.arrayIndex = metalVertex.count
            
        // 追加
        metalVertex.append( quad_v )
        params.append( pp )
        
        return pp.arrayIndex
    }
}
