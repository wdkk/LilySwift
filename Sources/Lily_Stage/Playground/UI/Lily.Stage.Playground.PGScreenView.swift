//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Metal
import SwiftUI

extension Lily.Stage.Playground
{
    #if os(macOS)
    public typealias ViewControllerRepresentable = NSViewControllerRepresentable
    #else
    public typealias ViewControllerRepresentable = UIViewControllerRepresentable
    #endif
    
    public struct PGScreenCoreView : ViewControllerRepresentable
    {
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment

        var visibled:Binding<Bool>
        var scene:Binding<PGScene>
        
        public init( 
            device:MTLDevice,
            visibled:Binding<Bool>,
            scene:Binding<PGScene>,
            environment:Lily.Stage.ShaderEnvironment
        )
        {
            self.device = device
            self.visibled = visibled
            self.scene = scene
            self.environment = environment
        }
        
        func makeViewController( context:Context ) -> PGScreen {
            let screen = PGScreen(
                device:device,
                environment:self.environment,
                scene:self.scene.wrappedValue
            )
  
            return screen        
        }
        
        func updateViewController( _ vc:PGScreen, context:Context ) {
            vc.changeStorages(
                planeStorage: scene.wrappedValue.planeStorage,
                bbStorage: scene.wrappedValue.bbStorage,
                modelStorage: scene.wrappedValue.modelStorage,
                design: scene.wrappedValue.design, 
                update: scene.wrappedValue.update,
                resize: scene.wrappedValue.resize
            )

            if visibled.wrappedValue == true {
                vc.rebuild()
                vc.startLooping()
            }
            else {
                vc.pauseLooping()
            }
        }
        
        #if os(macOS)
        public func makeNSViewController( context:Context ) -> PGScreen { 
            return makeViewController( context:context )
        }
        public func updateNSViewController( _ nsViewController:PGScreen, context:Context ) { 
            updateViewController( nsViewController, context:context )
        }
        #else
        public func makeUIViewController( context:Context ) -> PGScreen {
            return makeViewController( context:context )
        }
        public func updateUIViewController( _ uiViewController:PGScreen, context:Context ) {
            updateViewController( uiViewController, context:context )
        }
        #endif
    }
    
    public struct PGScreenView : View
    {
        @State private var visibled:Bool = false
        var scene:Binding<PGScene>
        
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment
        
        /*
        public init
        ( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment = .string
        )
        {
            self.device = device
            self.environment = environment
        }
        */
        
        public init
        ( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment = .string,
            scene:Binding<PGScene>
        )
        {
            self.device = device
            self.environment = environment
            self.scene = scene
        }

        public var body: some View 
        {
            return GeometryReader { geo in
                let v = PGScreenCoreView(
                    device:device,
                    visibled:self.$visibled,
                    scene:self.scene,
                    environment:self.environment
                )
                .frame( width:geo.size.width, height:geo.size.height )
                .background( .clear )
                .onAppear { visibled = true }
                .onDisappear { visibled = false }
                // 画面表示状態に対して反応させるためのonChange
                if #available( iOS 17.0, * ), #available( macOS 14.0, *) {
                    v.onChange( of:visibled, initial:false ) { _, _ in }
                } 
                else {
                    v.onChange( of:visibled ) { _ in }
                }
            }
        }
        
        /*
        public func onDesign( _ action: @escaping ( PGScreen )->Void ) -> Self {
            var view = self
            view.scene.wrappedValue.design = action
            return view        
        }
        
        public func onUpdate( _ action: @escaping ( PGScreen )->Void ) -> Self {
            var view = self
            view.scene.wrappedValue.update = action
            return view        
        }
        
        public func onResize( _ action: @escaping ( PGScreen )->Void ) -> Self {
            var view = self
            view.scene.wrappedValue.resize = action
            return view
        }
        */
    }
}
