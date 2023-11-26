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
        
        var storage:Storage
        
        var alphaRenderer:AlphaRenderer?
        
        let viewCount:Int
        var screenSize:CGSize = .zero
        
        public init( device:MTLDevice, viewCount:Int ) {
            self.pass = .init( device:device )
            self.storage = .init( device:device, capacity:1024 )
            self.viewCount = viewCount
            // レンダラーの用意
            alphaRenderer = .init( device:device, viewCount:viewCount )
            
            let idx = self.storage.request()
            
            super.init( device:device )
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
            pass.setClearColor( .white )
            
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
            
            encoder?.endEncoding()
        }
    }
}
