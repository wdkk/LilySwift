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
            VisionContentView()
        }
        .windowStyle( .plain )
        
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.ContentStageConfiguration() ) { layerRenderer in
                let renderEngine = Lily.Stage.VisionRenderEngine( layerRenderer )
                renderEngine.startRenderLoop()
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
