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

import Metal
import QuartzCore
 
extension Lily.View
{
    open class MetalView
    : BaseView
    {
        public private(set) lazy var metalLayer = CAMetalLayer()
        
        public let device:MTLDevice
        public private(set) var lastDrawable:CAMetalDrawable?
        public private(set) var depthTexture:MTLTexture?
        
        public var drawMetalField:DrawField?
        
        open override var bounds:CGRect { 
            didSet {
                if bounds.width == 0 || bounds.height == 0 { return }
                Task { @MainActor in
                    metalLayer.drawableSize = self.scaledBounds.size
                    metalLayer.frame = self.bounds
                    updateDepthTexture(
                        device: device, 
                        width: self.scaledBounds.width.i!,
                        height: self.scaledBounds.height.i! 
                    )
                }
            }
        }
        
        open override var frame:CGRect { 
            didSet {
                if bounds.width == 0 || bounds.height == 0 { return }
                Task { @MainActor in
                    metalLayer.drawableSize = self.scaledBounds.size
                    metalLayer.frame = self.bounds
                    updateDepthTexture(
                        device: device, 
                        width: self.scaledBounds.width.i!,
                        height: self.scaledBounds.height.i! 
                    )
                }
            } 
        }
        
        open func layerOpaque( _ torf:Bool ) {
            metalLayer.isOpaque = torf
        }
        
        public init( device:MTLDevice ) {
            self.device = device
            super.init()
        }
        
        required public init?(coder decoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func drawMetal() {
            guard let drawable = drawable,
                  let depthTexture = depthTexture else { return }
            
            let render_pass_descriptor = makeRenderPassDescriptor(
                drawable: drawable,
                depthTexture: depthTexture
            )
            
            drawMetalField?.appear( .init( drawable:drawable, renderPassDesc:render_pass_descriptor ) )
        }
        
        public override func setup() {
            super.setup()
            setupMetal( device:device )
        }
        
        /// Metalの初期化 / Metal Layerの準備
        open func setupMetal( device:MTLDevice? ) {
            metalLayer.device = device
            metalLayer.pixelFormat = .bgra8Unorm_srgb
            metalLayer.framebufferOnly = false
            metalLayer.contentsScale = LLSystem.retinaScale.cgf
            metalLayer.frame = self.bounds
            self.layerOpaque( true )
            #if os(macOS)
            self.backgroundColor = .clear
            self.isOpaque = false
            self.addSublayer( metalLayer )
            #else
            self.layer.addSublayer( metalLayer )
            #endif
        }
        
        open var drawable:CAMetalDrawable? {
            if metalLayer.bounds.width < 64 || metalLayer.bounds.height < 64 { return nil }
            
            lastDrawable = metalLayer.nextDrawable()
            
            guard let w = lastDrawable?.texture.width.cgf, let h = lastDrawable?.texture.height.cgf,
                  self.scaledBounds.width == w && self.scaledBounds.height == h 
            else { return nil }
            
            return lastDrawable
        }
        
        func makeRenderPassDescriptor( 
            drawable:CAMetalDrawable,
            color:LLColor = .clear, 
            depthTexture:MTLTexture 
        )
        -> MTLRenderPassDescriptor 
        {
            let r_pass_desc = MTLRenderPassDescriptor()
            // カラーアタッチメントの設定
            r_pass_desc.colorAttachments[0].texture = drawable.texture
            //r_pass_desc.colorAttachments[0].loadAction = (color != .clear) ? .clear : .load
            if color.A > 0.0 { 
                r_pass_desc.colorAttachments[0].loadAction = .clear
                r_pass_desc.colorAttachments[0].clearColor = color.metalColor
            }
            else {
                r_pass_desc.colorAttachments[0].loadAction = .load
            }
            r_pass_desc.colorAttachments[0].storeAction = .store
            
            // デプスの設定
            r_pass_desc.depthAttachment.texture = depthTexture
            r_pass_desc.depthAttachment.loadAction = .clear
            r_pass_desc.depthAttachment.storeAction = .store
            r_pass_desc.depthAttachment.clearDepth = 1.0
            // ステンシルの設定
            r_pass_desc.stencilAttachment.texture = depthTexture
            r_pass_desc.stencilAttachment.loadAction = .clear
            r_pass_desc.stencilAttachment.storeAction = .store
            r_pass_desc.stencilAttachment.clearStencil = 0
            
            return r_pass_desc
        }
        
        private func updateDepthTexture( 
            device:MTLDevice,
            width:Int,
            height:Int,
            depthFormat:MTLPixelFormat = .depth32Float_stencil8, 
            type:MTLTextureType = .type2D, 
            sampleCount:Int = 1,
            mipmapped:Bool = false 
        )
        {
            if width == 0 || height == 0 { 
                depthTexture = nil 
                return
            }
            
            // depthテクスチャの設定
            let depth_desc:MTLTextureDescriptor = MTLTextureDescriptor.texture2DDescriptor(
                pixelFormat: depthFormat,
                width: width,
                height: height,
                mipmapped: mipmapped 
            )
            depth_desc.textureType = type
            depth_desc.sampleCount = sampleCount
            depth_desc.usage = .renderTarget
            depth_desc.storageMode = .private                   // 追加: macOS対応
            depth_desc.resourceOptions = .storageModePrivate    // 追加: macOS対応
            
            // まだテクスチャメモリが生成されていない or サイズが変更された場合、新しいテクスチャを生成する
            if depthTexture == nil || 
                depthTexture!.width != depth_desc.width ||
                depthTexture!.height != depth_desc.height
            {
                depthTexture = device.makeTexture( descriptor: depth_desc )
                depthTexture?.label = "MetalView DepthTexture"
            }
        }
    }
}

extension Lily.View.MetalView
{
    public struct DrawingStatus 
    {
        public var drawable:MTLDrawable
        public var renderPassDesc:MTLRenderPassDescriptor
    }
    
    public typealias Me = Lily.View.MetalView
    public typealias DrawField = Lily.Field.ViewEvent<Me, DrawingStatus>
    
    public func draw( _ field:@escaping (Me, DrawingStatus)->() ) -> Self {
        drawMetalField = DrawField( me:self, action:field )
        return self
    }
    
    public func draw<TCaller:AnyObject>( caller:TCaller, _ field:@escaping (Me, TCaller, DrawingStatus)->() ) -> Self {
        drawMetalField = DrawField( me:self, caller:caller, action:field )
        return self
    }
}
  
#endif
