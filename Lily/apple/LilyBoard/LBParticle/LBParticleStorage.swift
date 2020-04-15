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

open class LBParticleStorage : LBActorStorage
{
    public var points = LLMetalPoints<LBParticleVertex>()
    public var params = [LBParticleParam]()
    public var atlas:LBTextureAtlas?    // .texatlasのみで利用
    public var texture:MTLTexture?      // .textureのみで利用
    
    // Metalエンコーダ描画の関数
    private func draw( encoder:MTLRenderCommandEncoder, index:Int ) {        
        encoder.drawPrimitives( type: .point, 
                                vertexStart: 0, 
                                vertexCount: 1,
                                instanceCount: points.count )
    }

    private func reuse() -> Int? {
        let trushes = params.filter { $0.state == .trush }
        guard let trush = trushes.first else { return nil }
        return trush.arrayIndex
    }
    
    // パネルデータを要求する
    public func request() -> Int {        
        let point_v = LBParticleVertex( xy:LLFloatv2( 0.0, 0.0 ) )
        
        // Pointsの描画処理を書き換え
        points.drawFunc = self.draw
        
        var pp = LBParticleParam()

        if let reuse_idx = reuse() {
            pp.arrayIndex = reuse_idx
            
            // 再利用
            points.vertex[reuse_idx] = point_v
            params[reuse_idx] = pp
            return reuse_idx
        }
        
        let new_index:Int = points.count
        pp.arrayIndex = new_index
        
        // 追加
        points.append( point_v )
        params.append( pp )
        
        return new_index
    }
}
