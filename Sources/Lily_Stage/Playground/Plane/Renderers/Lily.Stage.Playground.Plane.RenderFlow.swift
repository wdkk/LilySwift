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
    : Lily.Stage.Playground.BaseRenderFlow
    {
        var pass:Pass?
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        public weak var storage:PlaneStorage?
        
        var comDelta:PlaneComDelta?
        
        var alphaRenderer:AlphaRenderer?
        var addRenderer:AddRenderer?
        var subRenderer:SubRenderer?
    
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
            
            var pgFunctions:[PGFunction] = []
            
            pgFunctions.append(
                PGFunction(
                    device:device,
                    name:"f1",
                    code:"return float4( 1.0, 1.0, 0.0, 1.0 );"
                )
            )
            // レンダラーの作成
            self.alphaRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                pgFunctions:pgFunctions
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
            
            self.comDelta = .init(
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
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>
        )
        {
            guard let pass = self.pass else { return }
            
            guard let storage = self.storage else { return }

            // TODO: 最適化したい
            storage.statuses.update { acc, _ in
                // 各オブジェクトのマトリクス計算
                for i in 0 ..< acc.count - 1 {
                    let TOO_FAR:Float = 999999.0
                    let us = acc[i]
                    if us.enabled == false || us.state == .trush { continue }
                    
                    let enabled_k:Float = us.states[0]
                    let state_k:Float = us.states[1]
                    let alpha:Float = us.color[3]
                    let visibility_y:Float = state_k * enabled_k * alpha > 0.00001 ? 0.0 : TOO_FAR
                    
                    let sc = us.scale * 0.5
                    let ang = us.angle
                    var t = us.position
                    t.y += visibility_y
                    acc[i].matrix = LLMatrix4x4.affine2D( scale:sc, angle:ang, translate:t )
                }
                
                // 親子関係含めた計算
                let sorted_shapes = PGPool.shared.shapes( on:storage ).sorted { s0, s1 in s0.childDepth <= s1.childDepth }
                for shape in sorted_shapes {
                    guard let parent = shape.parent else { continue }
                    shape.matrix = parent.matrix * shape.matrix
                }
            }
            
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
            .cullMode( .front )
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
            
            comDelta?.updateMatrices(
                with:commandBuffer, 
                globalUniforms: uniforms,
                storage: storage
            )
        }
    }
}
