//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import SwiftUI
#if os(visionOS)
import CompositorServices
#endif

import LilySwift
import LilySwiftAlias

@main
struct DevSwiftUIApp: App
{
    #if os(visionOS)
    @State var fullyScreen:PGVisionFullyScreen?
    var visionPlayground = VisionPlayground()
    #endif
    
    var body: some Scene {
        //LLLogSetEnableType( .none )
        
        WindowGroup {
            ContentView()
        }
        
        #if os(visionOS)
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.Playground.VisionFullyRenderConfiguration() ) { layerRenderer in
                let device = layerRenderer.device
                
                fullyScreen = PGVisionFullyScreen(
                    layerRenderer:layerRenderer, 
                    environment:.metallib,
                    scene:.init(
                        planeStorage:.playgroundDefault( device:device ),
                        bbStorage:.playgroundDefault( device:device ),
                        modelStorage:.playgroundDefault( device:device ),
                        design:visionPlayground.design,
                        update:visionPlayground.update
                    )
                )
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
        #endif
    }
}
