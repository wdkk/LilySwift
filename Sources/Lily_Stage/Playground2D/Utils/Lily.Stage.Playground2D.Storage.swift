//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Metal

extension Lily.Stage.Playground2D
{
    public struct PG2DVIn
    {
        var xy = LLFloatv2()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
        var uv = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
        var texUV = LLFloatv2() // 0.0 ~ 1.0 テクスチャのuv座標
        
        public init( xy:LLFloatv2, uv:LLFloatv2, texUV:LLFloatv2 ) {
            self.xy = xy
            self.uv = uv
            self.texUV = texUV
        }
    }
    
    open class Storage
    {
        public var particles:Lily.Stage.Model.Quadrangles<PG2DVIn>?
        public var statuses:Lily.Metal.Buffer<UnitStatus>?
        public var reuseIndice:[Int]
        
        public var count:Int { particles?.count ?? 0 }
        
        public init( device:MTLDevice, capacity:Int ) {
            let p = LLQuad<Lily.Stage.Playground2D.PG2DVIn>(
                .init( xy:.init( -1.0,  1.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) ),
                .init( xy:.init(  1.0,  1.0 ), uv:.init( 1.0, 0.0 ), texUV:.init( 1.0, 0.0 ) ),
                .init( xy:.init( -1.0, -1.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) ),
                .init( xy:.init(  1.0, -1.0 ), uv:.init( 1.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
            )
            
            particles = .init( device:device, count:capacity )
            particles?.vertice.update( repeating:p, count:capacity )
            // TODO: シミュレータだと呼び出し必須なんだがこれをなんとかしたいところ
            particles?.update()
            
            statuses = .init( device:device, count:capacity )
            statuses?.update( range:0..<capacity ) { us, idx in
                us.state = .trush
                us.enabled = false
            }
            
            reuseIndice = .init( (0..<capacity).reversed() )
        }
        
        public func request() -> Int {
            guard let idx = reuseIndice.popLast() else { return -1 }
            return idx
        }
        
        public func trush( index idx:Int ) {
            statuses?.update( at:idx ) { us in
                us.state = .trush
                us.enabled = false
            }
            reuseIndice.append( idx )
        }
    }
}
