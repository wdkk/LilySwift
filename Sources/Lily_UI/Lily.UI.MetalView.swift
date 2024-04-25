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

import SwiftUI
import Metal
#if os(macOS)
import AppKit
#else
import UIKit
#endif

extension Lily.UI
{
    #if os(macOS)
    public struct MetalView : NSViewControllerRepresentable
    {        
        public typealias NSViewControllerType = Lily.View.MetalViewController
        
        var device:MTLDevice?
        public var setupHandler:(( Lily.View.MetalView )->())?
        public var buildupHandler:(( Lily.View.MetalView )->())?
        public var drawHandler:(( Lily.View.MetalView, MTLDrawable, MTLRenderPassDescriptor )->())?
        
        public init(
            device:MTLDevice?,
            setup:(( Lily.View.MetalView )->())? = nil,
            buildup:(( Lily.View.MetalView )->())? = nil,
            draw:(( Lily.View.MetalView, MTLDrawable, MTLRenderPassDescriptor )->())? = nil
        )
        {
            self.device = device
            self.setupHandler = setup
            self.buildupHandler = buildup
            self.drawHandler = draw
        }
        
        public func makeNSViewController( context:Context ) -> NSViewControllerType {
            let vc = Lily.View.MetalViewController( device:self.device )
            vc.setupHandler = { me, vc in self.setupHandler?( me ) }
            vc.buildupHandler = { me, vc in self.buildupHandler?( me ) }
            vc.drawHandler = { me, vc, drawable, renderPassDesc in self.drawHandler?( me, drawable, renderPassDesc ) }
            return vc
        }
        
        public func updateNSViewController(_ nsViewController:NSViewControllerType, context: Context) {
            nsViewController.rebuild()
        }
    }
    
    #else
    public struct MetalView : UIViewControllerRepresentable
    {
        public typealias UIViewControllerType = Lily.View.MetalViewController
        
        var device:MTLDevice?
        public var setupHandler:(( Lily.View.MetalView )->())?
        public var buildupHandler:(( Lily.View.MetalView )->())?
        public var drawHandler:(( Lily.View.MetalView, MTLDrawable, MTLRenderPassDescriptor )->())?
        
        public init(
            device:MTLDevice?,
            setup:(( Lily.View.MetalView )->())? = nil,
            buildup:(( Lily.View.MetalView )->())? = nil,
            draw:(( Lily.View.MetalView, MTLDrawable, MTLRenderPassDescriptor )->())? = nil
        )
        {
            self.device = device
            self.setupHandler = setup
            self.buildupHandler = buildup
            self.drawHandler = draw
        }
        
        public func makeUIViewController( context:Context ) -> UIViewControllerType {
            let vc = Lily.View.MetalViewController( device:self.device )
            vc.setupHandler = { me, vc in self.setupHandler?( me ) }
            vc.buildupHandler = { me, vc in self.buildupHandler?( me ) }
            vc.drawHandler = { me, vc, drawable, renderPassDesc in self.drawHandler?( me, drawable, renderPassDesc ) }
            return vc
        }
        
        public func updateUIViewController(_ uiViewController:UIViewControllerType, context: Context) {
            uiViewController.rebuild()
        }
    }
    #endif
}

#endif
