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
    @State var fullyScreen:Lily.Stage.Playground.PGVisionFullyScreen?
    
    var body: some Scene
    {
        WindowGroup {
            VisionContentView()
        }
        .windowStyle( .volumetric )
        
        ImmersiveSpace( id:"LilyImmersiveSpace" ) {
            CompositorLayer( configuration:Lily.Stage.VisionFullyRenderConfiguration() ) { layerRenderer in
                let device = layerRenderer.device
                
                fullyScreen = Lily.Stage.Playground.PGVisionFullyScreen(
                    layerRenderer:layerRenderer, 
                    environment:.string,
                    scene:.init(
                        planeStorage:.playgroundDefault( device:device ),
                        bbStorage:.playgroundDefault( device:device ),
                        modelStorage:.playgroundDefault( device:device )
                    )
                )
            }
        }
        .immersionStyle(
            selection: .constant(.full),
            in: .full
        )
    }
}
