//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(visionOS)

import Metal
import MetalKit

extension Lily.View
{
    open class MetalKitView 
    : MTKView
    , LLUILifeEvent
    {
#if os(macOS)
        public var isUserInteractionEnabled:Bool = true
#endif
        
        public var setupField:(any LLField)?
        public var buildupField:(any LLField)?
        public var teardownField:(any LLField)?
        public func setup() {}
        public func buildup() {}
        public func teardown() {}
        
        public var drawMetalField:DrawField?
        
        public init( device:MTLDevice? ) {
            super.init(frame: .zero, device:device )
            self.delegate = self
            self.autoResizeDrawable = true
        }
        
        required public init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public var _mutex = RecursiveMutex()   
        
        // MARK: - メソッド
        
        @discardableResult
        public func frameBufferOnly( _ torf:Bool ) -> Self { 
            self.framebufferOnly = torf
            return self
        }
        
        @discardableResult
        public func colorPixelFormat( _ format:MTLPixelFormat ) -> Self {
            self.colorPixelFormat = format
            return self
        }
        
        @discardableResult
        public func drawableSize( _ size:CGSize ) -> Self {
            if size == .zero { return self }
            self.drawableSize = size
            return self
        }
        
        @discardableResult
        public func sampleCount( _ count:Int ) -> Self {
            self.sampleCount = count
            return self
        }
    }
}

extension Lily.View.MetalKitView
{
    public struct DrawingStatus 
    {
        public var drawable:MTLDrawable
        public var renderPassDesc:MTLRenderPassDescriptor
    }
    
    public typealias Me = Lily.View.MetalKitView
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

extension Lily.View.MetalKitView
: MTKViewDelegate
{
    public func draw( in view:MTKView ) {
        guard let drawable = self.currentDrawable,
              let render_pass_descriptor = self.currentRenderPassDescriptor
        else { return }
        
        drawMetalField?.appear( .init( drawable:drawable, renderPassDesc:render_pass_descriptor ) )
    }
    
    public func mtkView( _ view: MTKView, drawableSizeWillChange size:CGSize ) {
        if size.width < 320 || size.height < 240 { return }
        rebuild()
    }
}

#endif
