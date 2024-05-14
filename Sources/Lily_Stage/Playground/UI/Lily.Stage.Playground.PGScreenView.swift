//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if !os(watchOS)

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
            return PGScreen(
                device:device,
                environment:self.environment,
                scene:self.scene.wrappedValue
            )
        }
        
        func updateViewController( _ vc:PGScreen, context:Context ) { 
            // 終了時にredesignのリクエストをTaskでクリアする
            defer { Task { @MainActor in scene.wrappedValue.finishRedesign() } }
            
            // sceneの値でvcの値を更新する
            vc.planeStorage    = scene.wrappedValue.planeStorage
            vc.bbStorage       = scene.wrappedValue.bbStorage
            vc.modelStorage    = scene.wrappedValue.modelStorage
            vc.audioStorage    = scene.wrappedValue.audioStorage
            vc.pgReadyHandler  = scene.wrappedValue.ready
            vc.pgDesignHandler = scene.wrappedValue.design
            vc.pgUpdateHandler = scene.wrappedValue.update
            vc.pgResizeHandler = scene.wrappedValue.resize
            
            // redesignが必要かを確認してtrueだった場合redesignを呼ぶ
            if scene.wrappedValue.checkNeedRedesign() { vc.redesign() }
        
            // 画面の切り替えによる表示/非表示での処理
            if visibled.wrappedValue {
                vc.rebuild()
                vc.startLooping()
            }
            else {
                vc.pauseLooping()
            }
        }
        
        #if os(macOS)
        public func makeNSViewController( context:Context ) -> PGScreen { 
            makeViewController( context:context )
        }
        public func updateNSViewController( _ nsViewController:PGScreen, context:Context ) { 
            updateViewController( nsViewController, context:context )
        }
        #else
        public func makeUIViewController( context:Context ) -> PGScreen {
            makeViewController( context:context )
        }
        public func updateUIViewController( _ uiViewController:PGScreen, context:Context ) {
            updateViewController( uiViewController, context:context )
        }
        #endif
    }
    
    public struct PGScreenView : View
    {
        @Environment(\.scenePhase) private var scenePhase
        @State private var visibled:Bool = false
        
        var scene:Binding<PGScene>
        
        var device:MTLDevice
        var environment:Lily.Stage.ShaderEnvironment
        
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
                if #available( iOS 17.0, * ), #available( macOS 14.0, *), #available( tvOS 17.0, * ) {
                    v
                    .onChange( of:visibled, initial:false ) { _, _ in }
                    .onChange(of: scenePhase) { oldPhase, newPhase in
                        if newPhase == .background { visibled = false }
                        if newPhase == .active { visibled = true }
                    }
                } 
                else {
                    v.onChange( of:visibled ) { _ in }
                    .onChange( of:scenePhase ) { phase in
                        if phase == .background { visibled = false }
                        if phase == .active { visibled = true }
                    }
                }

            }
        }
    }
}

#endif
