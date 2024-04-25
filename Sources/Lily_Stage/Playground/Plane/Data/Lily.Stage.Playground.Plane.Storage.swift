//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

import Metal

extension Lily.Stage.Playground.Plane
{
    public struct VIn
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
    
    open class PlaneStorage : Hashable
    {
        // Hashableの実装
        public static func == ( lhs:PlaneStorage, rhs:PlaneStorage ) -> Bool { lhs === rhs }
        public func hash(into hasher: inout Hasher) { ObjectIdentifier( self ).hash( into: &hasher ) }
        
        public static var current:PlaneStorage? = nil
        
        public var particles:Lily.Stage.Model.Quadrangles<VIn>
        public var statuses:Lily.Metal.Buffer<UnitStatus>
        public var reuseIndice:[Int]
        
        public var textureAtlas:Lily.Metal.TextureAtlas
        
        public var capacity:Int
        
        static let defaultQuadrangleVertice = LLQuad<VIn>(
            .init( xy:.init( -1.0,  1.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xy:.init( -1.0, -1.0 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xy:.init(  1.0,  1.0 ), uv:.init( 1.0, 0.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xy:.init(  1.0, -1.0 ), uv:.init( 1.0, 1.0 ), texUV:.init( 1.0, 1.0 ) )
        )
        
        static let defaultTriangleVertice = LLQuad<VIn>(
            .init( xy:.init(  0.0,  1.15470053838 ), uv:.init( 0.0, 1.0 ), texUV:.init( 0.0, 0.0 ) ),
            .init( xy:.init( -1.0, -0.57735026919 ), uv:.init(-1.0, 1.0 ), texUV:.init( 1.0, 0.0 ) ),
            .init( xy:.init(  1.0, -0.57735026919 ), uv:.init( 1.0,-1.0 ), texUV:.init( 0.0, 1.0 ) ),
            .init( xy:.init(  0.0,  0.0 ), uv:.init( 0.0, 0.0 ), texUV:.init( 0.0, 0.0 ) )
        )
        
        public static func playgroundDefault( 
            device:MTLDevice,
            capacity:Int = 2000,
            appendTextures:[String] = []
        )
        -> PlaneStorage 
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
            
            self.statuses.update( range:0..<capacity+1 ) { us, _ in
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
                LLLogWarning( "Playground.Storage: ストレージの容量を超えたリクエストです. インデックス=capacityを返します" )
                return capacity
            }
            statuses.accessor?[idx] = .init()
            
            return idx
        }
        
        // パーティクルをデータ的廃棄する
        public func trush( index idx:Int ) {
            statuses.update( at:idx ) { us in
                us.state = .trush
                us.enabled = false
            }
            reuseIndice.append( idx )
        }
        
        public func clear() {
            self.statuses.update( range:0..<capacity+1 ) { us, _ in
                us.state = .trush
                us.enabled = false
            }
            
            self.reuseIndice = .init( (0..<capacity).reversed() )
        }
    }
}

#endif
