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

import MetalKit

extension Lily.Stage.Playground.Billboard
{
    open class RenderFlow
    : Lily.Stage.Playground.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground.Billboard.Pass?
        
        weak var mediumResource:Lily.Stage.Playground.MediumResource?
        
        public weak var storage:BBStorage?
        
        var comDelta:ComDelta?
        
        var alphaRenderer:AlphaRenderer?
        var addRenderer:AddRenderer?
        var subRenderer:SubRenderer?
          
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Metal.ShaderEnvironment,
            viewCount:Int,
            mediumResource:Lily.Stage.Playground.MediumResource,
            storage:BBStorage?
        ) 
        {
            self.mediumResource = mediumResource
            
            self.pass = .init( device:device )
            self.viewCount = viewCount
            
            self.storage = storage
            
            BBShader.shared.ready( device:device )
            let funcs = BBShader.shared.functions
            
            // レンダラーの作成
            self.alphaRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                bbFunctions:funcs
            )
            self.addRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                bbFunctions:funcs
            )
            self.subRenderer = .init( 
                device:device,
                environment:environment,
                viewCount:viewCount,
                bbFunctions:funcs
            )
            
            self.comDelta = .init(
                device: device, 
                environment: environment
            )
            
            super.init( device:device )
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
            uniforms:Lily.Metal.RingBuffer<Lily.Stage.Playground.GlobalUniformArray>
        )
        {
            guard let pass = self.pass else { return }
            
            guard let mediumResource = self.mediumResource else { LLLog( "mediumResourceが設定されていません" ); return }
            
            guard let storage = self.storage else { return }
            
            // TODO: 最適化したい
            storage.statuses.update { acc, _ in
                let now = LLClock.Precision.now.f
                
                // 各オブジェクトのマトリクス計算
                for i in 0 ..< acc.count - 1 {
                    let TOO_FAR:Float = 999999.0
                    let us = acc[i]
                    if us.enabled == false || us.state == .trush { continue }
                    
                    let enabled_k:Float = us.states[0]
                    let state_k:Float = us.states[1]
                    let alpha:Float = acc[i].color[3]
                    let visibility_z:Float = state_k * enabled_k * alpha > 0.00001 ? 0.0 : TOO_FAR
                    
                    let sc = us.scale
                    let ro = us.rotation
                    var t = us.position
                    t.z += visibility_z
                    
                    acc[i].matrix = LLMatrix4x4.affine3D( scale:sc, rotate:ro, translate:t )
                    acc[i].comboAngle = us.angle * 180.0 / .pi
                    
                    // オブジェクトの経過時間 
                    acc[i].elapsedTime = now - acc[i].startTime
                }
                
                // 親子関係含めた計算
                let sorted_shapes = BBPool.shared.shapes( on:storage ).sorted { s0, s1 in s0.childDepth <= s1.childDepth }
                for shape in sorted_shapes {
                    guard let parent = shape.parent else { continue }
                    shape.matrix = parent.matrix * shape.matrix
                    shape.comboAngle = parent.comboAngle + shape.comboAngle 
                }
            }
                        
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetViewIndex:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            pass.setDestination( texture:mediumResource.resultTexture )
            pass.setDepth( texture:depthTexture )
            
            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 3D Render" )
            .cullMode( .front )
            .depthStencilState( pass.depthState! )
            .viewports( viewports )
            .vertexAmplification( viewports:viewports )
            
            // Playgroundレンダー描画
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
            
            comDelta?.updateMatrices(
                with:commandBuffer, 
                globalUniforms: uniforms,
                storage: storage
            )
        }
    }
}

#endif
