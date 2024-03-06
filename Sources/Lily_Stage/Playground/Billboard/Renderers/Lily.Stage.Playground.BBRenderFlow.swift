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

extension Lily.Stage.Playground.Billboard
{
    open class BBRenderFlow
    : Lily.Stage.Playground.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground.Billboard.BBPass?
        
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        
        public weak var storage:BBStorage?
        
        var alphaRenderer:BBAlphaRenderer?
        var addRenderer:BBAddRenderer?
        var subRenderer:BBSubRenderer?
          
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            mediumTexture:Lily.Stage.Playground.MediumTexture,
            storage:BBStorage?
        ) 
        {
            self.mediumTexture = mediumTexture
            
            self.pass = .init( device:device )
            self.viewCount = viewCount
            
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
            
            guard let mediumTexture = self.mediumTexture else { LLLog( "mediumTextureが設定されていません" ); return }
            
            guard let storage = self.storage else { return }
            
            // TODO: 最適化したい
            storage.statuses.update { acc, _ in
                // 各オブジェクトのマトリクス計算
                for i in 0 ..< acc.count - 1 {
                    let TOO_FAR:Float = 999999.0
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    
                    let enabled_k:Float = acc[i].states[0]
                    let state_k:Float = acc[i].states[1]
                    let alpha:Float = acc[i].color[3]
                    let visibility_z:Float = state_k * enabled_k * alpha > 0.00001 ? 0.0 : TOO_FAR
                    
                    let sc = LLFloatv3( acc[i].scale, 2.0 ) * 0.5
                    let ro = acc[i].rotate
                    var t = acc[i].position
                    t.z += visibility_z
                    acc[i].matrix = LLMatrix4x4.affine3D( scale:sc, rotate:ro, translate:t )
                }
                
                // 親子関係含めた計算
                let sorted_shapes = BBPool.shared.shapes( on:storage ).sorted { s0, s1 in s0.childDepth <= s1.childDepth }
                for shape in sorted_shapes {
                    guard let parent = shape.parent else { continue }
                    shape.matrix = parent.matrix * shape.matrix
                }
            }
                        
            // 共通処理
            pass.updatePass( 
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            // フォワードレンダリング : パーティクルの描画の設定
            pass.setDestination( texture:mediumTexture.resultTexture )
            pass.setDepth( texture:depthTexture )
            
            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?
            .label( "Playground 3D Render" )
            .cullMode( .none )
            .frontFacing( .counterClockwise )
            .depthStencilState( pass.depthState! )
            .viewports( viewports )
            .vertexAmplification( count:viewCount, viewports:viewports )
            
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
            
            storage.statuses.update { acc, _ in
                for i in 0 ..< acc.count-1 {
                    if acc[i].enabled == false || acc[i].state == .trush { continue }
                    acc[i].position += acc[i].deltaPosition
                    acc[i].scale += acc[i].deltaScale
                    acc[i].rotate += acc[i].deltaRotate
                    acc[i].color += acc[i].deltaColor
                    acc[i].life += acc[i].deltaLife
                }
            }
        }
    }
}
