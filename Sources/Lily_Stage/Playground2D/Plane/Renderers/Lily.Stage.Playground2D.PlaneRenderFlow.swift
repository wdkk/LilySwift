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

extension Lily.Stage.Playground2D.Plane
{
    open class PlaneRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:PlanePass?
        weak var mediumTextures:Lily.Stage.Playground2D.MediumTextures?
        weak var storage:PlaneStorage?
        
        var alphaRenderer:PlaneAlphaRenderer?
        var addRenderer:PlaneAddRenderer?
        var subRenderer:PlaneSubRenderer?
    
        public let viewCount:Int
        
        public var clearColor:LLColor = .white
        
        public private(set) var screenSize:CGSize = .zero
        
        public init(
            device:MTLDevice,
            viewCount:Int,
            mediumTextures:Lily.Stage.Playground2D.MediumTextures,
            environment:Lily.Stage.ShaderEnvironment,
            storage:PlaneStorage?
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            
            self.mediumTextures = mediumTextures
            self.storage = storage
            
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
            
            super.init( device:device )
        }
        
        public override func changeSize( scaledSize:CGSize ) {
            screenSize = scaledSize
            screenSize.width /= LLSystem.retinaScale
            screenSize.height /= LLSystem.retinaScale
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
            
            guard let storage = self.storage else { return }
        
            storage.statuses.update { acc, _ in
                for i in 0 ..< acc.count-1 {
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
            pass.setClearColor( self.clearColor )
            
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
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            alphaRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTextures:mediumTextures!,
                storage:storage,
                screenSize:screenSize
            )
            
            encoder?.endEncoding()
        }
    }
}
