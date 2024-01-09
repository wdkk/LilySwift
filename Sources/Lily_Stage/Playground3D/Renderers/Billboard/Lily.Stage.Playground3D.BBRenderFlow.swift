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

extension Lily.Stage.Playground3D
{
    open class BBRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground3D.BBPass?
        
        weak var mediumTextures:BBMediumRenderTextures?
        weak var renderTextures:ModelRenderTextures?
        
        public private(set) var pool:BBPool
        public private(set) var storage:BBStorage
        
        var alphaRenderer:BBAlphaRenderer?
        var addRenderer:BBAddRenderer?
        var subRenderer:BBSubRenderer?
          
        public let viewCount:Int
        
        public private(set) var particleCapacity:Int
        
        public init(
            device:MTLDevice,
            viewCount:Int,
            BBMediumTextures:BBMediumRenderTextures,
            renderTextures:ModelRenderTextures,
            environment:Lily.Stage.ShaderEnvironment,
            particleCapacity:Int = 10000,
            textures:[String] = []
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            self.particleCapacity = particleCapacity
            
            self.mediumTextures = BBMediumTextures
            
            self.renderTextures = renderTextures
            
            // レンダラーの作成
            self.alphaRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount
            )
            self.addRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount
            )
            self.subRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount
            )
            
            self.storage = .init( 
                device:device, 
                capacity:particleCapacity
            )
            self.storage.addTextures( textures )
            
            self.pool = BBPool()
            self.pool.storage = self.storage
        
            super.init( device:device )
            
            BBPool.current = pool
        }
        
        public override func changeSize( scaledSize:CGSize ) {
           
        }
        
        public override func render(
            commandBuffer:MTLCommandBuffer,
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            viewports:[MTLViewport],
            viewCount:Int,
            destinationTexture:MTLTexture?,
            depthTexture:MTLTexture?,
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Shared.GlobalUniformArray>
        )
        {
            guard let pass = self.pass else { return }
            
            guard let renderTextures = self.renderTextures else { 
                LLLog( "renderTexturesが設定されていません" )
                return
            }
            
            BBPool.current?.storage?.statuses?.update { acc, _ in
                for i in 0 ..< acc.count {
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    acc[i].position += acc[i].deltaPosition
                    acc[i].scale += acc[i].deltaScale
                    acc[i].angle += acc[i].deltaAngle
                    acc[i].color += acc[i].deltaColor
                    acc[i].life += acc[i].deltaLife
                }
            }
            
            // 共通処理
            pass.updatePass( 
                mediumTextures:mediumTextures!,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            pass.setDestination( texture:destinationTexture )
            pass.setDepth( texture:depthTexture )
            
            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 3D Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .depthStencilState( pass.depthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // Playground3Dレンダー描画
            alphaRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )
            
            alphaRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )
            
            addRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )
            
            addRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )
            
            subRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )

            subRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                storage:storage
            )

            encoder?.endEncoding()
        }
    }
}
