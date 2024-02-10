//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(iOS) || os(visionOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import Metal
import SwiftUI

extension Lily.Stage.Playground2D
{
    #if os(iOS) || os(visionOS)
    public struct PGScreenCoreView : UIViewControllerRepresentable
    {
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment
        var particleCapacity:Int
        var textures:[String]
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        var visibled:Binding<Bool>
        
        public init( 
            device:MTLDevice,
            visibled:Binding<Bool>,
            environment:Lily.Stage.ShaderEnvironment,
            particleCapacity:Int,
            textures:[String],
            design:(( PGScreen )->Void)?,
            update:(( PGScreen )->Void)? 
        )
        {
            self.device = device
            self.visibled = visibled
            
            self.environment = environment
            self.particleCapacity = particleCapacity
            self.textures = textures
            
            self.design = design
            self.update = update
        }
        
        public func makeUIViewController( context:Context ) -> PGScreen {
            let screen = PGScreen(
                device:device,
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures 
            )
            
            screen.pgDesignHandler = self.design
            screen.pgUpdateHandler = self.update
            
            return screen
        }
        
        public func updateUIViewController( _ uiViewController:PGScreen, context:Context ) {
            if visibled.wrappedValue == true {
                uiViewController.rebuild()
                uiViewController.startLooping()
            }
            else {
                uiViewController.pauseLooping()
            }
        }
    }
        
    #elseif os(macOS)
    public struct PGScreenCoreView : NSViewControllerRepresentable
    {
        var device:MTLDevice
        
        var environment:Lily.Stage.ShaderEnvironment
        var particleCapacity:Int
        var textures:[String]
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        var visibled:Binding<Bool>
        
        public init( 
            device:MTLDevice,
            visibled:Binding<Bool>,
            environment:Lily.Stage.ShaderEnvironment,
            particleCapacity:Int,
            textures:[String],
            design:(( PGScreen )->Void)?,
            update:(( PGScreen )->Void)? 
        )
        {
            self.device = device
            self.visibled = visibled
            
            self.environment = environment
            self.particleCapacity = particleCapacity
            self.textures = textures
            
            self.design = design
            self.update = update
        }
        
        public func makeNSViewController( context:Context ) -> PGScreen {
            let screen = PGScreen(
                device:device,
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures 
            )
            
            screen.pgDesignHandler = self.design
            screen.pgUpdateHandler = self.update
            
            return screen
        }
        
        public func updateNSViewController( _ nsViewController:PGScreen, context:Context ) {
            if visibled.wrappedValue == true {
                nsViewController.rebuild()
                nsViewController.startLooping()
            }
            else {
                nsViewController.pauseLooping()
            }
        }
    }
    #endif
    
    public struct PGScreenView : View
    {
        @State var visibled:Bool = false
        
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment
        var particleCapacity:Int
        var textures:[String]
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        public init( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment = .string,
            particleCapacity:Int = 2000,
            textures:[String] = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            design:(( PGScreen )->Void)? = nil,
            update:(( PGScreen )->Void)? = nil 
        )
        {
            self.device = device

            self.environment = environment
            self.particleCapacity = particleCapacity
            self.textures = textures
            
            self.design = design
            self.update = update
        }
        
        public var body: some View 
        {
            let v = PGScreenCoreView(
                device: device,
                visibled:$visibled,
                environment:self.environment,
                particleCapacity:self.particleCapacity,
                textures:self.textures,
                design:self.design,
                update:self.update
            )
            .background( .clear )
            .onAppear { visibled = true }
            .onDisappear { visibled = false }
            // 画面表示状態に対して反応させるためのonChange
            if #available(iOS 17.0, * ), #available(macOS 14.0, *) {
                v.onChange( of:visibled, initial:false ) { _, _ in }
            } 
            else {
                v.onChange( of:visibled ) { _ in }
            }
        }       
    }
}
