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
import simd

extension Lily.Stage.Playground
{
    open class ClearPass
    { 
        var device:MTLDevice
 
        public var passDesc:MTLRenderPassDescriptor?
        public var depthState:MTLDepthStencilState?
        
        public init( device:MTLDevice ) {
            self.device = device
            // レンダーパスの準備
            passDesc = .make {
                $0.depthAttachment.action( load:.clear, store:.store ).clearDepth( 1.0 )
                // テクスチャに落とすことにしたのでストアする
                $0.colorAttachments[0].action( load:.clear, store:.store ).clearColor( .darkGrey )
            }
            
            // Depth stateの作成
            depthState = device.makeDepthStencilState( descriptor:.make {
                $0
                .depthCompare( .lessEqual )
                .depthWriteEnabled( true )
            } )
        }
        
        // 公開ファンクション
        public func updatePass(
            rasterizationRateMap:Lily.Metal.RasterizationRateMap?,
            renderTargetCount:Int
        )
        {
            #if !targetEnvironment(macCatalyst)
            passDesc?.rasterizationRateMap = rasterizationRateMap
            #endif
            #if os(visionOS)
            passDesc?.renderTargetArrayLength = renderTargetCount
            #endif
        }
        
        public func setDestination( texture:MTLTexture? ) {
            passDesc?.colorAttachments[0].texture = texture
        }
        
        public func setDepth( texture:MTLTexture? ) {
            passDesc?.depthAttachment.texture = texture
        }
        
        public func setClearColor( _ color:LLColor? ) {
            if let color = color {
                passDesc?.colorAttachments[0].clearColor( color.metalColor )
                passDesc?.colorAttachments[0].action( load:.clear, store:.store )
            }
            else {
                passDesc?.colorAttachments[0].clearColor( .clear )
                passDesc?.colorAttachments[0].action( load:.clear, store:.store )            
            }
        }
        
        public func setClearColor( _ color:MTLClearColor ) {
            passDesc?.colorAttachments[0].clearColor( color )
            passDesc?.colorAttachments[0].action( load:.clear, store:.store )
        }
    }
    
    open class ClearRenderFlow
    : Lily.Stage.BaseRenderFlow
    {
        var pass:Lily.Stage.Playground.ClearPass?
        weak var modelRenderTextures:Lily.Stage.Playground.Model.ModelRenderTextures?
        weak var mediumTexture:Lily.Stage.Playground.MediumTexture?
        
        public var clearColor:LLColor = .white
        public let viewCount:Int
        
        public init(
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment,
            viewCount:Int,
            modelRenderTextures:Lily.Stage.Playground.Model.ModelRenderTextures?,
            mediumTexture:Lily.Stage.Playground.MediumTexture?
        ) 
        {
            self.pass = .init( device:device )
            self.viewCount = viewCount
            self.modelRenderTextures = modelRenderTextures
            self.mediumTexture = mediumTexture
            
            super.init( device:device )
        }
        
        public override func changeSize( scaledSize:CGSize ) {
            self.modelRenderTextures?.updateBuffers( size:scaledSize, viewCount:self.viewCount )
            self.mediumTexture?.updateBuffers( size:scaledSize, viewCount:self.viewCount )
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
            
            // 共通処理
            pass.updatePass(
                rasterizationRateMap:rasterizationRateMap,
                renderTargetCount:viewCount        
            )
            
            pass.setDestination( texture:mediumTexture?.resultTexture )
            pass.setDepth( texture:depthTexture )
            pass.setClearColor( self.clearColor )

            let encoder = commandBuffer.makeRenderCommandEncoder( descriptor:pass.passDesc! )
            
            encoder?.label( "Playground Clear Render" )

            encoder?.endEncoding()
        }
    }
}
