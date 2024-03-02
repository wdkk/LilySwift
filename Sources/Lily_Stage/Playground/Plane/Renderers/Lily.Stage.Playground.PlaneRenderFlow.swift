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

extension Lily.Stage.Playground.Plane
{
    open class PlaneRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:PlanePass?
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        public weak var storage:PlaneStorage?
        
        var alphaRenderer:PlaneAlphaRenderer?
        var addRenderer:PlaneAddRenderer?
        var subRenderer:PlaneSubRenderer?
        
        var planeCompute:PlaneCompute?
    
        public let viewCount:Int
        
        public private(set) var screenSize:CGSize = .zero
        
        public init(
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            mediumTexture:Lily.Stage.Playground.MediumTexture,
            storage:PlaneStorage?
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            
            self.mediumTexture = mediumTexture
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
            
            self.planeCompute = .init(
                device: device, 
                environment: environment
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
                    let TOO_FAR:Float = 999999.0
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    
                    let enabled_k:Float = acc[i].states[0]
                    let state_k:Float = acc[i].states[1]
                    let alpha:Float = acc[i].color[3]
                    let visibility_y:Float = state_k * enabled_k * alpha > 0.00001 ? 0.0 : TOO_FAR
                    
                    let sc = acc[i].scale * 0.5
                    let ang = acc[i].angle
                    var t = acc[i].position
                    t.y += visibility_y
                    acc[i].matrix = LLMatrix4x4.affine2D(scale: sc, angle:ang, translate:t )
                }
            }
            
            let shapes = PGPool.shared.shapes( on:storage ).sorted { $0.childDepth <= $1.childDepth }
            for shape in shapes {
                guard let parent = shape.parent else { continue }
                shape.matrix = parent.matrix * shape.matrix
            }
            storage.statuses.commit()
            
            // 共通処理
            pass.updatePass( 
                mediumTexture:mediumTexture!,
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            pass.setDestination( texture:destinationTexture )
            pass.setDepth( texture:depthTexture )
            
            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 2D Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .depthStencilState( pass.depthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
            // Playgroundレンダー描画
            alphaRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            alphaRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            addRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.draw(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            subRenderer?.drawTriangle(
                with:encoder,
                globalUniforms:uniforms,
                mediumTexture:mediumTexture!,
                storage:storage,
                screenSize:screenSize
            )
            
            encoder?.endEncoding()
            
            planeCompute?.updateMatrices(
                with:commandBuffer, 
                globalUniforms: uniforms,
                storage: storage
            )
        }
    }
}
