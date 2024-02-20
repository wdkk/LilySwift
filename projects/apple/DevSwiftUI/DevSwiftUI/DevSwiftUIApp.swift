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
import LilySwift
#if os(visionOS)
import CompositorServices
#endif

@main
struct DevSwiftUIApp: App {
    var body: some Scene {
        //LLLogSetEnableType( .none )
        
        WindowGroup {
            ContentView()
        }
        
        #if os(visionOS)
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.VisionFullyRenderConfiguration() ) { layerRenderer in
                /*
                let renderFlow = DevEnv.RenderFlow( device:layerRenderer.device, viewCount:Lily.Stage.fullyViewCount )
                let renderEngine = Lily.Stage.VisionFullyRenderEngine( 
                    layerRenderer,
                    renderFlows:[renderFlow],
                    buffersInFlight:3
                )
                renderEngine.startRenderLoop()
                */
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
        #endif
    }
}
