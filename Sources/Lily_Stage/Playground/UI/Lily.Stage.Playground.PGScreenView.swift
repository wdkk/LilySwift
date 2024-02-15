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
        var planeStorage:Plane.PlaneStorage?
        var modelStorage:Model.ModelStorage?
        var bbStorage:Billboard.BBStorage?
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        var visibled:Binding<Bool>
                
        public init( 
            device:MTLDevice,
            visibled:Binding<Bool>,
            environment:Lily.Stage.ShaderEnvironment,
            planeStorage:Plane.PlaneStorage?,
            modelStorage:Model.ModelStorage?,
            bbStorage:Billboard.BBStorage?,
            design:(( PGScreen )->Void)?,
            update:(( PGScreen )->Void)? 
        )
        {
            self.device = device
            self.visibled = visibled
            self.environment = environment
            
            self.planeStorage = planeStorage
            self.modelStorage = modelStorage
            self.bbStorage = bbStorage
        
            self.design = design
            self.update = update
        }
        
        func makeViewController( context:Context ) -> PGScreen {
            let screen = PGScreen(
                device:device,
                environment:self.environment,
                planeStorage:self.planeStorage,
                bbStorage:self.bbStorage,
                modelStorage:self.modelStorage
            )
            
            screen.pgDesignHandler = self.design
            screen.pgUpdateHandler = self.update
            
            return screen        
        }
        
        func updateViewController( _ vc:PGScreen, context:Context ) {
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
        @State var visibled:Bool = false
        
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment
        var planeStorage:Plane.PlaneStorage?
        var modelStorage:Model.ModelStorage?
        var bbStorage:Billboard.BBStorage?
        public var design:(( PGScreen )->Void)?
        public var update:(( PGScreen )->Void)?
        
        public init( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment = .string,
            planeCapacity:Int? = 2000,
            planeTextures:[String]? = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            modelCapacity:Int? = 500,
            modelAssets:[String]? = [ "cottonwood1", "acacia1", "plane" ],
            billboardCapacity:Int? = 2000,
            billboardTextures:[String]? = ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"],
            design:(( PGScreen )->Void)? = nil,
            update:(( PGScreen )->Void)? = nil 
        )
        {
            self.device = device
            self.environment = environment
            
            // ストレージの生成
            if let planeCapacity = planeCapacity,
               let planeTextures = planeTextures 
            {
                self.planeStorage = .init( 
                    device:device, 
                    capacity:planeCapacity,
                    textures:planeTextures
                )
            }
            
            if let modelAssets = modelAssets,
               let modelCapacity = modelCapacity
            {
                self.modelStorage = .init( 
                    device:device, 
                    modelCapacity:modelCapacity,                    
                    modelAssets:modelAssets
                )
            }
    
            if let billboardCapacity = billboardCapacity,
               let billboardTextures = billboardTextures
            {
                self.bbStorage = .init( 
                    device:device, 
                    capacity:billboardCapacity,
                    textures:billboardTextures
                )
            }
            
            self.design = design
            self.update = update
        }
        
        public init( 
            device:MTLDevice,
            environment:Lily.Stage.ShaderEnvironment = .string,
            planeStorage:Lily.Stage.Playground.Plane.PlaneStorage? = nil,
            modelStorage:Lily.Stage.Playground.Model.ModelStorage? = nil,
            bbStorage:Lily.Stage.Playground.Billboard.BBStorage? = nil,
            design:(( PGScreen )->Void)?,
            update:(( PGScreen )->Void)? 
        )
        {
            self.device = device
            self.environment = environment
            
            self.planeStorage = planeStorage
            self.modelStorage = modelStorage
            self.bbStorage = bbStorage
            
            self.design = design
            self.update = update
        }
        
        public var body: some View 
        {
            let v = PGScreenCoreView(
                device: device,
                visibled:$visibled,
                environment:self.environment,
                planeStorage:self.planeStorage,
                modelStorage:self.modelStorage,
                bbStorage:self.bbStorage,
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
