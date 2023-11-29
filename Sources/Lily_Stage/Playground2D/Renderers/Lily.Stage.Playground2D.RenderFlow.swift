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
import MetalKit

extension Lily.Stage.Playground2D
{
    open class RenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground2D.Pass?
        
        var adapter = PGAdapter()
        var storage:Storage
        
        var alphaRenderer:AlphaRenderer?
        var addRenderer:AddRenderer?
        var subRenderer:SubRenderer?
        
        let viewCount:Int
        var screenSize:CGSize = .zero
        var particleCapacity:Int = 20000
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            // レンダラーの作成
            self.alphaRenderer = .init( device:device, viewCount:viewCount )
            self.addRenderer = .init( device:device, viewCount:viewCount )
            self.subRenderer = .init( device:device, viewCount:viewCount )
            
            self.storage = .init( 
                device:device, 
                capacity:particleCapacity, 
                textures:["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
            )
            
            super.init( device:device )
            
            PGAdapter.current = adapter
            PGAdapter.current?.storage = storage
            
            PGRectangle()
            .color( .red )
            
            /*
            let idx1 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx1 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLFloatv4( 1.0, 0.2, 0.2, 0.7 )
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .alpha
                us.shapeType = .rectangle
            }
            
            let idx2 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx2 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLFloatv4( 0.2, 0.2, 1.0, 0.7 )
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .alpha
                us.shapeType = .triangle
            }
            
            let idx3 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx3 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLFloatv4( .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.4...0.6) )
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .add
                us.shapeType = .circle
            }
            
            let idx4 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx4 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLFloatv4( .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.4...0.6) )
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .sub
                us.shapeType = .circle
            }
            
            let idx5 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx5 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLFloatv4( .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.0...0.8), .random(in:0.4...0.6) )
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .sub
                us.shapeType = .rectangle
            }
            
            let idx6 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx6 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLColor.black.floatv4
                us.scale = LLFloatv2( 300.0, 300.0 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .alpha
                us.shapeType = .blurryCircle
            }
            
            let idx7 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx7 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLColor.black.floatv4
                us.scale = LLFloatv2( 256, 256 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .alpha
                us.shapeType = .picture
                let reg = self.storage.textureAtlas.parts( "lily" ).region
                us.atlasUV = .init( reg!.left.f, reg!.top.f, reg!.right.f, reg!.bottom.f )
            }
            
            let idx8 = storage.request()
            storage.statuses?.updateWithoutCommit( at:idx8 ) { us in
                us.state = .active
                us.enabled = true
                us.color = LLColor.black.floatv4
                us.scale = LLFloatv2( 256, 256 )
                us.position = LLFloatv2( .random(in:-300...300), .random(in:-300...300) )
                us.compositeType = .alpha
                us.shapeType = .mask
                let reg = self.storage.textureAtlas.parts( "mask-star" ).region
                us.atlasUV = .init( reg!.left.f, reg!.top.f, reg!.right.f, reg!.bottom.f )
            }
      
            storage.statuses?.commit()
             */
        }
        
        public override func updateBuffers( size:CGSize ) {
            screenSize = size
        }
        
        public override func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:MTLRasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>
        )
        {
            guard let pass = self.pass else { return }
            
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            pass.setDestination( texture:destinationTexture )
            pass.setDepth( texture:depthTexture )
            pass.setClearColor( .darkKhaki )
            
            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 2D Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .depthStencilState( pass.depthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // Playground2Dレンダー描画
            alphaRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            alphaRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage,
                screenSize:screenSize
            )
            
            encoder?.endEncoding()
        }
    }
}
