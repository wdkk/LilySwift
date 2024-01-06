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

extension Lily.Stage.Playground3D
{
    public struct PG3DVIn
    {
        var xyzw  = LLFloatv4()    // -1.0 ~ 1.0, 中央が0.0のローカル座標系
        var uv    = LLFloatv2()    // 0.0 ~ 1.0, 左上が0.0のラスタ座標系
        var texUV = LLFloatv2()    // 0.0 ~ 1.0 テクスチャのuv座標
        
        public init( xyz:LLFloatv3, uv:LLFloatv2, texUV:LLFloatv2 ) {
            self.xyzw  = LLFloatv4( xyz, 1.0 )
            self.uv    = uv
            self.texUV = texUV
        }
    }
    
    open class BBStorage
    {
        public var particles:Lily.Stage.Model.Quadrangles<PG3DVIn>?
        public var statuses:Lily.Metal.Buffer<BBUnitStatus>?
        public var reuseIndice:[Int]
        
        public var textureAtlas:Lily.Metal.TextureAtlas
        
        public var capacity:Int
        
        static let defaultQuadrangleVertice = LLQuad<Lily.Stage.Playground3D.PG3DVIn>(
            .init( xyz:.init( -1.0,  1.0, 0.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xyz:.init(  1.0,  1.0, 0.0 ), uv:.init( 1.0, 0.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xyz:.init( -1.0, -1.0, 0.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xyz:.init(  1.0, -1.0, 0.0 ), uv:.init( 1.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
        )
        
        static let defaultTriangleVertice = LLQuad<Lily.Stage.Playground3D.PG3DVIn>(
            .init( xyz:.init(  0.0,  1.15470053838, 0.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xyz:.init( -1.0, -0.57735026919, 0.0 ), uv:.init(-1.0, 1.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xyz:.init(  1.0, -0.57735026919, 0.0 ), uv:.init( 1.0,-1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xyz:.init(  0.0,  0.0, 0.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) )
        )
        
        public init( device:MTLDevice, capacity:Int ) {
            self.capacity = capacity
            
            self.particles = .init( device:device, count:2 )    // 四角と三角を1つずつ
            self.particles?.update { acc, _ in
                acc[0] = Self.defaultQuadrangleVertice
                acc[1] = Self.defaultTriangleVertice
            }
            
            self.statuses = .init( device:device, count:capacity + 1 )  // 1つ余分に確保
            self.statuses?.update( range:0..<capacity ) { us, _ in
                us.state = .trush
                us.enabled = false
            }
            
            self.reuseIndice = .init( (0..<capacity).reversed() )
            
            self.textureAtlas = .init( device:device )
        }
        
        public func addTextures( _ textures:[String] ) {
            textures.forEach { self.textureAtlas.reserve( $0, $0 ) }
            self.textureAtlas.commit()
        }
        
        // パーティクルの確保をリクエストする
        public func request() -> Int {
            guard let idx = reuseIndice.popLast() else { 
                LLLogWarning( "Playground3D.Storage: ストレージの容量を超えたリクエストです. インデックス=capacityを返します" )
                return capacity
            }
            statuses?.accessor?[idx] = .reset
            
            return idx
        }
        
        // パーティクルをデータ的廃棄する
        public func trush( index idx:Int ) {
            statuses?.update( at:idx ) { us in
                us.state = .trush
                us.enabled = false
            }
            reuseIndice.append( idx )
        }
    }
}
