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

extension Lily.Stage.Playground.Billboard
{
    public struct BBVIn
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
    
    open class BBStorage : Hashable
    {
        // Hashableの実装
        public static func == ( lhs:BBStorage, rhs:BBStorage ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
        
        public static var current:BBStorage? = nil
        
        public var particles:Lily.Stage.Model.Quadrangles<BBVIn>
        public var statuses:Lily.Metal.Buffer<BBUnitStatus>
        public var reuseIndice:[Int]
        
        public var textureAtlas:Lily.Metal.TextureAtlas
        
        public var capacity:Int
        
        static let defaultQuadrangleVertice = LLQuad<BBVIn>(
            .init( xyz:.init( -1.0,  1.0, 0.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xyz:.init(  1.0,  1.0, 0.0 ), uv:.init( 1.0, 0.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xyz:.init( -1.0, -1.0, 0.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xyz:.init(  1.0, -1.0, 0.0 ), uv:.init( 1.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
        )
        
        static let defaultTriangleVertice = LLQuad<BBVIn>(
            .init( xyz:.init(  0.0,  1.15470053838, 0.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xyz:.init( -1.0, -0.57735026919, 0.0 ), uv:.init(-1.0, 1.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xyz:.init(  1.0, -0.57735026919, 0.0 ), uv:.init( 1.0,-1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xyz:.init(  0.0,  0.0, 0.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) )
        )
        
        public static func playgroundDefault( 
            device:MTLDevice,
            capacity:Int = 2000,
            appendTextures:[String] = []
        )
        -> BBStorage 
        {
            var texs = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
            texs.append( contentsOf:appendTextures )
            return .init( 
                device:device, 
                capacity:capacity,
                textures:texs
            )
        }
        
        public init( 
            device:MTLDevice, 
            capacity:Int,
            textures:[String]
        )
        {
            self.capacity = capacity
            
            self.particles = .init( device:device, count:2 )    // 四角と三角を1つずつ
            self.particles.update { acc, _ in
                acc[0] = Self.defaultQuadrangleVertice
                acc[1] = Self.defaultTriangleVertice
            }
            
            self.statuses = .init( device:device, count:capacity + 1 )  // 1つ余分に確保
            self.statuses.update( range:0..<capacity ) { us, _ in
                us.state = .trush
                us.enabled = false
            }
            
            self.reuseIndice = .init( (0..<capacity).reversed() )
            
            self.textureAtlas = .init( device:device )
            addTextures( textures )
        }
        
        public func addTextures( _ textures:[String] ) {
            textures.forEach { self.textureAtlas.reserve( $0, $0 ) }
            self.textureAtlas.commit()
        }
        
        // パーティクルの確保をリクエストする
        public func request() -> Int {
            guard let idx = reuseIndice.popLast() else { 
                LLLogWarning( "Playground.BBStorage: ストレージの容量を超えたリクエストです. インデックス=capacityを返します" )
                return capacity
            }
            statuses.accessor?[idx] = .init()
            
            return idx
        }
        
        // パーティクルをデータ上で廃棄する
        public func trush( index idx:Int ) {
            statuses.update( at:idx ) { us in
                us.state = .trush
                us.enabled = false
            }
            reuseIndice.append( idx )
        }
    }
}
