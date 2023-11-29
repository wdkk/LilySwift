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
        
        var pool:PGPool
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
            
            self.pool = PGPool()
            self.pool.storage = self.storage
        
            super.init( device:device )
            
            PGPool.current = pool
            
            PGRectangle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGTriangle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGAddCircle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGSubCircle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
        
            PGSubRectangle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGBlurryCircle()
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGPicture( "lily" )
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGMask( "mask-star" )
            .color( .random )
            .scale( width: 300.0, height: 300.0 )
            .position( cx: (-300...300).randomize, cy: (-300...300).randomize )
            
            PGPool.current?.storage?.statuses?.commit()
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
