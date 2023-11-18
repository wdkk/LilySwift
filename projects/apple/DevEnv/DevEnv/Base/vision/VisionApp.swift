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
import CompositorServices
import LilySwift

@main
struct VisionApp
: App 
{
    var body: some Scene {
        WindowGroup {
            VisionFullyContentView()
        }
        .windowStyle( .volumetric )
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.VisionFullyRenderConfiguration() ) { layerRenderer in
                
                let renderFlow = DevEnv.RenderFlow( device:layerRenderer.device, viewCount:Lily.Stage.fullyViewCount )
                let renderEngine = Lily.Stage.VisionFullyRenderEngine( 
                    layerRenderer,
                    renderFlow:renderFlow
                )
                renderEngine.startRenderLoop()
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
